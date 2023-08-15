import 'dart:async';
import 'dart:io';

import 'package:astroverse/models/user.dart' as models;
import 'package:astroverse/repo/auth_repo.dart';
import 'package:astroverse/res/strings/backend_strings.dart';
import 'package:astroverse/routes/routes.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class AuthController extends GetxController {
  Rxn<models.User> user = Rxn<models.User>();
  Rx<bool> loading = false.obs;
  Rxn<String> error = Rxn<String>();
  StreamSubscription<DocumentSnapshot<models.User>>? _sub;
  Rx<String> pass = "".obs;
  final _repo = AuthRepo();
  Rxn<XFile> image = Rxn();
  Rx<int> selectedPlan = 0.obs;
  Rx<bool> emailVerified = false.obs;
  Timer? _timer;
  Timer? _resendTimerInstance;
  Rx<int> resendTimer = 60.obs;

  @override
  void onInit() {
    final fUser = FirebaseAuth.instance.currentUser;
    if (fUser != null &&
        fUser.providerData.any((element) => element.providerId == "password")) {
      startListeningToUser(fUser.uid);
      emailVerified.value = _repo.checkIfEmailVerified();
    }

    super.onInit();
  }

  loginUser(String email, String password,
      void Function(Resource<UserCredential>, bool) updateUI) {
    loading.value = true;
    _repo.loginUser(email, password).then((value) {
      loading.value = false;
      updateUI(value, _repo.checkIfEmailVerified());
      if (value.isSuccess) {
        value = value as Success<UserCredential>;
        value.data.user ??
            startListeningToUser(
              value.data.user!.uid,
            );
        error.value = null;
      } else {
        value = value as Failure<UserCredential>;
        error.value = value.error;
      }
    });
  }

  startListeningToUser(String uid) {
    _sub = _repo.getUserStream(uid).listen((event) {
      debugPrint("user:${event.data()}");
      if (event.data() != null) user.value = event.data()!;
    });
  }

  createUserWithEmail(
      models.User user, String password, void Function(Resource) updateUI) {
    user.plan = selectedPlan.value;
    String path = BackEndStrings.defaultImage;
    if (image.value != null) path = image.value!.path;
    loading.value = true;
    _repo.createUser(user, password).then((event) {
      debugPrint(event.toString());
      if (event.isSuccess) {
        event = event as Success<UserCredential>;
        user.uid = event.data.user!.uid;
        if (image.value != null) {
          _repo
              .storeProfileImage(File(path), event.data.user!.uid)
              .then((task) {
            if (task.isSuccess) {
              debugPrint("image uploaded");
              user.image = (task as Success<String>).data;
              saveData(user, (p0) {
                loading.value = false;
                updateUI(p0);
              }, (event as Success<UserCredential>).data);
            } else {
              loading.value = false;
            }
          });
        } else {
          user.image = BackEndStrings.defaultImage;
          saveData(user, (p0) {
            loading.value = false;
            updateUI(p0);
          }, event.data);
        }
      } else {
        loading.value = false;
        event = event as Failure<UserCredential>;
        error.value = event.error;
        updateUI(event);
      }
    });
  }

  @override
  void onClose() {
    _sub?.cancel();
    _timer?.cancel();
    _resendTimerInstance?.cancel();
    super.onClose();
  }

  void saveData(models.User user, void Function(Resource<void>) updateUI,
      UserCredential event) {
    _repo.saveUserData(user).then((value) {
      loading.value = false;
      updateUI(value);
      if (value is Success) {
        if (event.user != null) {
          startListeningToUser(event.user!.uid);
        }
        error.value = null;
      } else {
        value = value as Failure;
        error.value = value.error;
      }
    });
  }

  sendVerificationEmail() {
    resendTimer.value = 60;
    startResendCountdown();
    _repo.sendEmailVerificationEmail().then((value) {
      debugPrint("res value is success on email sent : ${value.isSuccess}");
      if (value.isSuccess) {
        Get.snackbar("Email", (value as Success<String>).data);
        startEmailVerificationCheck(() {
          debugPrint("email verified");
        });
      } else {
        Get.snackbar("Email Error", (value as Failure).error);
      }
    });
  }

  startEmailVerificationCheck(void Function() onVerified) {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      emailVerified.value = _repo.checkIfEmailVerified();
      debugPrint("checking email verification");
      if (emailVerified.value == true) {
        onVerified();
        timer.cancel();
        _timer?.cancel();
        Get.offAllNamed(Routes.main);
      }
    });
  }

  startResendCountdown() {
    int value = 60;
    _resendTimerInstance = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendTimer.value == 0) {
        timer.cancel();
      } else {
        value = value - 1;
        resendTimer.value = value;
        debugPrint(resendTimer.value.toString());
      }
    });
  }

  signInWithGoogle(void Function(Resource<UserCredential>) updateUI) {
    _repo.signInWithGoogle().then((value) {
      if (value.isSuccess) {
        value = value as Success<UserCredential>;
        _repo.checkForUserData(value.data.user!.uid).then((it) {
          if (it == false) {
            _showError(
              "No Record Found",
              "No user record found\n.Please sign up.",
            );
            GoogleSignIn().signOut();
          } else {
            startListeningToUser(
              (value as Success<UserCredential>).data.user!.uid,
            );
            Get.offAndToNamed(Routes.main);
          }
        });
      } else {
        _showError("Error", (value as Failure<UserCredential>).error);
      }
    });
  }

  signUpWithGoogle() {
    _repo.signInWithGoogle().then((value) {
      if (value.isSuccess) {
        value = value as Success<UserCredential>;
        _repo.checkForUserData(value.data.user!.uid).then((it) {
          if (it == false) {
            final cred = (value as Success<UserCredential>).data.user!;

            final user = models.User(
                cred.displayName.toString(),
                cred.email.toString(),
                cred.photoURL.toString(),
                0,
                cred.uid,
                false,
                cred.phoneNumber.toString());

            Get.toNamed(Routes.moreProfile, arguments: user);
          } else {
            _showError("Error", "user already exists");
          }
        });
      } else {
        _showError("Error", (value as Failure<UserCredential>).error);
      }
    });
  }

  void saveGoogleData(
      models.User user,
      void Function(
        Resource<void> value,
      ) updateUI) {
    loading.value = true;
    user.plan = selectedPlan.value;
    if (image.value != null) {
      _repo.storeProfileImage(File(image.value!.path), user.uid).then((value) {
        if (value.isSuccess) {
          user.image = (value as Success<String>).data;
          _saveDataFromGoogle(user, (p0) {
            if (p0 is Success<void>) {
              debugPrint("saved data");
            }
          });
        } else {
          _showError("error", (value as Failure<String>).error);
        }
      });
    }
  }

  _saveDataFromGoogle(
      models.User user, void Function(Resource<void>) updateUI) {
    _repo.saveUserData(user).then((value) {
      loading.value = false;
      updateUI(value);
      if (value is Success) {
        startListeningToUser(user.uid);
        Get.offAndToNamed(Routes.main);
      } else {
        value = value as Failure;
        error.value = value.error;
      }
    });
  }

  _onNoUserEmailLogin() {}

  _onNoUserGoogleLogin() {
    Get.snackbar("no record found", "Please signup");
  }

  _showError(String title, String msg) {
    Get.snackbar(title, msg);
  }
}
