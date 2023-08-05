import 'dart:async';

import 'package:astroverse/models/user.dart' as models;
import 'package:astroverse/repo/auth_repo.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    if(fUser != null) startListeningToUser(fUser.uid);
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
    loading.value = true;
    _repo.createUser(user, password).then((value) {
      if (value.isSuccess) {
        _repo.saveUserData(user).then((value) {
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
      } else {
        value = value as Failure<UserCredential>;
        error.value = value.error;
      }
    });
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }
}
