import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:astroverse/controllers/service_controller.dart';
import 'package:astroverse/models/extra_info.dart';
import 'package:astroverse/models/user.dart' as models;
import 'package:astroverse/models/user_bank_details.dart';
import 'package:astroverse/repo/auth_repo.dart';
import 'package:astroverse/res/strings/backend_strings.dart';
import 'package:astroverse/routes/routes.dart';
import 'package:astroverse/utils/crypt.dart';
import 'package:astroverse/utils/geo.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:astroverse/utils/zego_cloud_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'package:dart_geohash/dart_geohash.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import 'main_controller.dart';

class AuthController extends GetxController {
  final _zegoService = ZegoCloudServices();
  final FirebaseAnalyticsObserver observer =
  FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance);

  final _analytics = FirebaseAnalytics.instance;

  final _crypto = Crypt();

  Rxn<models.User> user = Rxn<models.User>();
  Rx<bool> loading = false.obs;
  Rx<bool> userLoading = false.obs;
  Rxn<String> error = Rxn<String>();
  StreamSubscription<DocumentSnapshot<models.User>>? _sub;
  StreamSubscription<DocumentSnapshot<UserBankDetails>>? _bankSub;
  Rx<String> pass = "".obs;
  final _repo = AuthRepo();
  Rxn<XFile> image = Rxn();
  Rx<int> selectedPlan = 0.obs;
  Rx<bool> emailVerified = false.obs;
  Timer? _timer;
  Timer? _resendTimerInstance;
  Rx<int> resendTimer = 60.obs;
  Rx<int> astroPlanSelected = Rx(0);
  Rx<int> page = 0.obs;
  Rxn<ExtraInfo> info = Rxn();
  RxBool disableAccountUpdate = true.obs;
  RxnString upiError = RxnString();
  RxnString accError = RxnString();
  RxnString ifscError = RxnString();
  RxnString branchError = RxnString();
  Rxn<UserBankDetails> bankDetails = Rxn();
  final MainController _main = Get.put(MainController());
  RxInt selectedUpgradePlan = 0.obs;
  RxBool upgradingPlan = false.obs;

  @override
  void onInit() async {
    final fUser = FirebaseAuth.instance.currentUser;
    if (fUser != null) {
      final res = await _repo.checkForUserData(fUser.uid);
      if (res == true) {
        _analytics.logLogin(loginMethod: "remember me");
        await startListeningToUser(fUser.uid);
        await _repo.updateExtraInfo(
            {"lastActive": FieldValue.serverTimestamp()}, fUser.uid);
        emailVerified.value = _repo.checkIfEmailVerified();
        if (emailVerified.value == true) {
          Get.toNamed(Routes.main);
        }
      }
    }

    super.onInit();
  }

  void clearError() {
    upiError.value = null;
    accError.value = null;
    ifscError.value = null;
    branchError.value = null;
  }

  loginUser(String email, String password,
      void Function(Resource<UserCredential>, bool) updateUI) {
    loading.value = true;
    _repo.loginUser(email, password).then((value) async {
      loading.value = false;
      if (value.isSuccess) {
        value = value as Success<UserCredential>;
        _analytics.logLogin(loginMethod: "Email");

        if (value.data.user != null) {
          await _repo.updateExtraInfo(
              {"lastActive": FieldValue.serverTimestamp()},
              value.data.user!.uid);
          var res = await _repo.getUserData(value.data.user!.uid);
          if (res.isSuccess) {
            res = res as Success<DocumentSnapshot<models.User>>;
            user.value = res.data.data();
            updateUI(value, _repo.checkIfEmailVerified());
            await startListeningToUser(
              value.data.user!.uid,
            );
          } else {
            // TODO(implement error dialog)
          }
        }
        error.value = null;
      } else {
        value = value as Failure<UserCredential>;
        error.value = value.error;
        updateUI(value, _repo.checkIfEmailVerified());
      }
    });
  }

  startListeningToUser(String uid) async {
    userLoading.value = true;
    await _zegoService.initCallInvitationService(uid, "You");
    _sub = _repo.getUserStream(uid).listen((event) {
      debugPrint("user:${event.data()}");
      userLoading.value = false;
      debugPrint("user loading : ${loading.value}");
      if (event.data() != null) {
        user.value = event.data()!;
        _main.setUser(user.value);
      }
    });
  }

  getExtraInfo(String uid) {
    _repo.getExtraInfo(uid).then((value) {
      if (value.isSuccess) {
        value = value as Success<ExtraInfo>;
        info.value = value.data;
      } else {
        info.value = null;
      }
    });
  }

  createUserWithEmail(models.User user, String password,
      void Function(Resource) updateUI) {
    user.plan = 0;
    String path = BackEndStrings.defaultImage;
    if (image.value != null) path = image.value!.path;
    loading.value = true;
    _repo.createUser(user, password).then((event) {
      debugPrint(event.toString());
      if (event.isSuccess) {
        event = event as Success<UserCredential>;

        user.name = _crypto.encryptToBase64String(user.name);
        user.email = _crypto.encryptToBase64String(user.email);

        user.uid = event.data.user!.uid;
        if (image.value != null) {
          _repo
              .storeProfileImage(File(path), event.data.user!.uid)
              .then((task) {
            if (task.isSuccess) {
              debugPrint("image uploaded");
              user.image = (task as Success<String>).data;
              saveData(user, (p0) {
                final info = ExtraInfo(
                    posts: 0,
                    joiningDate: DateTime.now(),
                    lastActive: DateTime.now(),
                    servicesSold: 0);
                _repo.setExtraInfo(info, user.uid).then((value) {
                  _analytics.logSignUp(signUpMethod: "Email");
                  loading.value = false;
                  updateUI(p0);
                });
              }, (event as Success<UserCredential>).data);
            } else {
              loading.value = false;
            }
          });
        } else {
          user.image = BackEndStrings.defaultImage;
          saveData(user, (p0) {
            final info = ExtraInfo(
                posts: 0,
                joiningDate: DateTime.now(),
                lastActive: DateTime.now(),
                servicesSold: 0);
            _repo.setExtraInfo(info, user.uid).then((value) {
              _analytics.logSignUp(signUpMethod: "Email");
              loading.value = false;
              updateUI(p0);
            });
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
    _bankSub?.cancel();
    _timer?.cancel();
    _resendTimerInstance?.cancel();
    super.onClose();
  }

  createUserWithEmailForAstro(models.User user, String password,
      void Function(Resource) updateUI) {
    user.plan = 0;
    String path = BackEndStrings.defaultImage;
    if (image.value != null) path = image.value!.path;
    loading.value = true;
    _repo.createUser(user, password).then((event) {
      debugPrint(event.toString());
      if (event.isSuccess) {
        user.name = _crypto.encryptToBase64String(user.name);
        user.email = _crypto.encryptToBase64String(user.email);
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
                _analytics.logEvent(name: "astro signup Email");
                final info = ExtraInfo(
                    posts: 0,
                    joiningDate: DateTime.now(),
                    lastActive: DateTime.now(),
                    servicesSold: 0);
                _repo.setExtraInfo(info, user.uid).then((value) {
                  _analytics.logSignUp(signUpMethod: "Email");
                  loading.value = false;
                  updateUI(p0);
                });
              }, (event as Success<UserCredential>).data);
            } else {
              loading.value = false;
            }
          });
        } else {
          user.image = BackEndStrings.defaultImage;
          saveData(user, (p0) {
            _analytics.logEvent(name: "astro signup Email");
            final info = ExtraInfo(
                posts: 0,
                joiningDate: DateTime.now(),
                lastActive: DateTime.now(),
                servicesSold: 0);
            _repo.setExtraInfo(info, user.uid).then((value) {
              _analytics.logSignUp(signUpMethod: "Email");
              loading.value = false;
              updateUI(p0);
            });
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

  updateUser(Json data, String uid) {
    _repo.updateUserInfo(data, uid).then((value) {});
  }

  void saveData(models.User user, void Function(Resource<void>) updateUI,
      UserCredential event) {
    _repo.saveUserData(user).then((value) async {
      loading.value = false;
      if (value is Success) {
        if (event.user != null) {
          var res = await _repo.getUserData(event.user!.uid);
          if (res.isSuccess) {
            res = res as Success<DocumentSnapshot<models.User>>;
            this.user.value = res.data.data()!;
            await startListeningToUser(event.user!.uid);
            updateUI(value);
          } else {
            // TODO( implement error dialog )
          }
        }

        error.value = null;
      } else {
        value = value as Failure;
        error.value = value.error;
        updateUI(value);
      }
    });
  }

  sendVerificationEmail(void Function() onVerified) {
    resendTimer.value = 60;
    startResendCountdown();
    _repo.sendEmailVerificationEmail().then((value) {
      debugPrint("res value is success on email sent : ${value.isSuccess}");
      if (value.isSuccess) {
        _analytics.logEvent(name: "verification email sent");
        Get.snackbar("Email", (value as Success<String>).data);
        startEmailVerificationCheck(() {
          onVerified();
          _analytics.logEvent(name: "email verified");
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
        debugPrint("email verified");
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

  startBankDetailsStream(String uid) {
    _bankSub = _repo.userBankDetailsStream(uid).listen((event) {
      bankDetails.value = event.data();
    });
  }

  giveCoinsToUser(int coinsToGive, String uid,
      void Function(Resource<Json>) updateUi) {
    _repo.addCoinsInDatabase(coinsToGive, uid).then((value) {
      updateUi(value);
    });
  }

  endBankDetailsStream() async {
    await _bankSub?.cancel();
  }

  signInWithGoogle(void Function(Resource<UserCredential>) updateUI) {
    _repo.signInWithGoogle().then((value) {
      if (value.isSuccess) {
        _analytics.logLogin(loginMethod: "Google");
        value = value as Success<UserCredential>;
        _repo.checkForUserData(value.data.user!.uid).then((it) async {
          if (it == false) {
            _showError(
              "No Record Found",
              "No user record found\n.Please sign up.",
            );
            GoogleSignIn().signOut();
          } else {
            var res = await _repo
                .getUserData((value as Success<UserCredential>).data.user!.uid);
            if (res.isSuccess) {
              user.value =
                  (res as Success<DocumentSnapshot<models.User>>).data.data();
              await startListeningToUser(
                (value).data.user!.uid,
              );
              Get.offAndToNamed(Routes.main);
            } else {
              // TODO(implement alert)
            }
          }
        });
      } else {
        _showError("Error", (value as Failure<UserCredential>).error);
      }
    });
  }

  void updateRangeForUser(String uid, int range, int cost,
      Function(Resource<Json>) updateUI) {
    upgradingPlan.value = true;
    _repo.updateRangeForUser(uid, range, cost).then((value) {
      upgradingPlan.value = false;
      updateUI(value);
    });
  }

  signUpWithGoogle(void Function(models.User) onComplete, bool astro,
      GeoPoint? loc) {
    _repo.signInWithGoogle().then((value) {
      if (value.isSuccess) {
        value = value as Success<UserCredential>;
        _repo.checkForUserData(value.data.user!.uid).then((it) {
          if (it == false) {
            final cred = (value as Success<UserCredential>).data.user!;
            _analytics.logSignUp(signUpMethod: "Google");
            final user = models.User(
                _crypto
                    .encryptToBase64String(
                    _parseValueForModel(cred.displayName)),
                _crypto.encryptToBase64String(_parseValueForModel(cred.email)),
                _parseValueForModel(cred.photoURL),
                0,
                location: loc,
                coins: 0,
                profileViews: 0,
                _parseValueForModel(cred.uid),
                astro,
                _parseValueForModel(cred.phoneNumber),
                loc == null ? "" : GeoHasher().encode(
                    loc.longitude, loc.latitude)
            );
            final info = ExtraInfo(
                joiningDate: DateTime.now(),
                lastActive: DateTime.now(),
                servicesSold: 0,
                posts: 0);
            _repo.setExtraInfo(info, cred.uid).then((value) {
              if (value.isSuccess) {
                onComplete(user);
              } else {
                _showError("Error", (value as Failure<String>).error);
              }
            });
          } else {
            _showError("Error", "user already exists");
          }
        });
      } else {
        _showError("Error", (value as Failure<UserCredential>).error);
      }
    });
  }

  void saveGoogleData(models.User user,
      void Function(
          Resource<void> value,
          ) updateUI,
      bool astro,
      Function() goTO) {
    loading.value = true;
    user.plan = 0;
    if (image.value != null) {
      _repo.storeProfileImage(File(image.value!.path), user.uid).then((value) {
        if (value.isSuccess) {
          user.image = (value as Success<String>).data;
          _saveDataFromGoogle(user, (p0) {
            if (p0 is Success<void>) {
              debugPrint("saved data");
            }
          }, goTO);
        } else {
          _showError("error", (value as Failure<String>).error);
        }
      });
    } else {
      log("no image selected", name: "SAVE DATA");
      user.image = BackEndStrings.defaultImage;
      _saveDataFromGoogle(user, (p0) {
        if (p0 is Success<void>) {
          debugPrint("saved data");
        }
      }, goTO);
    }
  }

  _saveDataFromGoogle(models.User user, void Function(Resource<void>) updateUI,
      void Function() goTO) {
    _repo.saveUserData(user).then((value) async {
      loading.value = false;
      updateUI(value);
      if (value is Success) {
        await startListeningToUser(user.uid);
        goTO();
      } else {
        value = value as Failure;
        error.value = value.error;
      }
    });
  }

  addUserBankDetails(UserBankDetails data,
      String uid,
      Function(Success<UserBankDetails>) onSuccess,
      Function(String) onFailure) {
    _repo.saveUserBankDetails(data, uid).then((value) {
      if (value.isSuccess) {
        value = value as Success<UserBankDetails>;
        log("bank details updated : ${data.toString()}", name: "BANK DETAILS");
        onSuccess(value);
      } else {
        value = value as Failure<UserBankDetails>;
        log("bank details not updated : ${value.error}", name: "BANK DETAILS");
        onFailure(value.error);
      }
    });
  }

  updateUserBankDetails(Json data, String uid,
      Function(Success<Json>) onSuccess, Function(String) onFailure) {
    _repo.updateUserBankDetails(data, uid).then((value) {
      if (value.isSuccess) {
        value = value as Success<Json>;
        log("bank details updated : ${data.toString()}", name: "BANK DETAILS");
        onSuccess(value);
      } else {
        value = value as Failure<Json>;
        log("bank details not updated : ${value.error}", name: "BANK DETAILS");
        onFailure(value.error);
      }
    });
  }

  void logOut() {
    CometChatUIKit.logout(
        onSuccess: (p0) {
          _repo.logOut().then((value) {
            _zegoService.disposeCallInvitationService().then((value) {
              Get.offAllNamed(Routes.ask);
              _analytics.logEvent(name: "logout");
            });
          });
        },
        onError: (_) {});
  }

  _onNoUserEmailLogin() {}

  _onNoUserGoogleLogin() {
    Get.snackbar("no record found", "Please signup");
  }

  _showError(String title, String msg) {
    Get.snackbar(title, msg);
  }

  String _parseValueForModel(String? s) {
    if (s == null) return "";
    return s;
  }
}
