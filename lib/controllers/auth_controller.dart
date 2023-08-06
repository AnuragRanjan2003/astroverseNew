import 'dart:async';
import 'dart:io';

import 'package:astroverse/models/user.dart' as models;
import 'package:astroverse/repo/auth_repo.dart';
import 'package:astroverse/res/strings/backend_strings.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
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

  @override
  void onInit() {
    final fUser = FirebaseAuth.instance.currentUser;
    if (fUser != null) startListeningToUser(fUser.uid);
  }

  loginUser(String email, String password,
      void Function(Resource<UserCredential>) updateUI) {
    loading.value = true;
    _repo.loginUser(email, password).then((value) {
      loading.value = false;
      updateUI(value);
      if (value.isSuccess) {
        value = value as Success<UserCredential>;
        value.data.user ?? startListeningToUser(value.data.user!.uid);
        error.value = null;
      } else {
        value = value as Failure<UserCredential>;
        error.value = value.error;
      }
    });
  }

  startListeningToUser(String uid) {
    _sub = _repo.getUserStream(uid).listen((event) {
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
      print(event.toString());
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
              });
            }else{
              loading.value = false;
            }
          });
        } else {
          user.image = BackEndStrings.defaultImage;
          saveData(user, (p0) {
            loading.value = false;
            updateUI(p0);
          });
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
    super.onClose();
  }

  void saveData(
      models.User user, void Function(Resource<void>) updateUI) {
    _repo.saveUserData(user).then((value) {
      loading.value = false;
      updateUI(value);
      if (value.isSuccess) {
        value = value as Success<UserCredential>;
        value.data.user ?? startListeningToUser(value.data.user!.uid);
        error.value = null;
      } else {
        value = value as Failure<void>;
        error.value = value.error;
      }
    });
  }
}
