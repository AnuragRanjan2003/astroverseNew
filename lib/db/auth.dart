import 'package:astroverse/utils/resource.dart';
import 'package:astroverse/utils/safe_call.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user.dart' as models;

class Auth {
  final mAuth = FirebaseAuth.instance;

  Future<Resource<UserCredential>> loginUser(String email, String pass) async =>
      await SafeCall().authCall<UserCredential>(() async =>
          await mAuth.signInWithEmailAndPassword(email: email, password: pass));

  Future<Resource<UserCredential>> signupWithEmail(
          models.User user, String password) async =>
      await SafeCall().authCall<UserCredential>(() async =>
          await mAuth.createUserWithEmailAndPassword(
              email: user.email, password: password));

  Future<Resource<String>> sendVerificationEmail() async =>
      await SafeCall().authCall<String>(() async {
        mAuth.currentUser?.reload();
        if (mAuth.currentUser != null) {
          if (mAuth.currentUser!.emailVerified == true) return "email verified";
          await mAuth.currentUser!.sendEmailVerification();
          return "email sent";
        } else {
          return null;
        }
      });

  bool checkEmailVerified() {
    mAuth.currentUser?.reload();
    return mAuth.currentUser!.emailVerified;
  }
}
