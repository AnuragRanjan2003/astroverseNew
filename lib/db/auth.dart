import 'package:astroverse/utils/resource.dart';
import 'package:astroverse/utils/safe_call.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user.dart' as models;

class Auth {
  final mAuth = FirebaseAuth.instance;

  Future<Resource<UserCredential>> loginUser(String email, String pass) async =>
      await SafeCall().authCall<UserCredential>(() async =>
        await mAuth.signInWithEmailAndPassword(email: email, password: pass)
      );

  Future<Resource<UserCredential>> signupWithEmail(
          models.User user, String password) async =>
      await SafeCall().authCall<UserCredential>(() async =>
          await mAuth.createUserWithEmailAndPassword(
              email: user.email, password: password));
}
