import 'dart:io';

import 'package:astroverse/db/storage.dart';
import 'package:astroverse/models/user.dart' as models;
import 'package:astroverse/utils/phone_auth_callbacks.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../db/auth.dart';
import '../db/db.dart';
import '../models/post.dart';

class AuthRepo {
  final _auth = Auth();
  final _db = Database();
  final _store = Storage();

  Future<Resource<UserCredential>> loginUser(
          String email, String password) async =>
      await _auth.loginUser(email, password);

  Future<Resource<UserCredential>> createUser(
          models.User user, String password) async =>
      await _auth.signupWithEmail(user, password);

  Future<Resource<void>> saveUserData(models.User user) async =>
      await _db.saveUserData(user);

  Future<Resource<String>> storeProfileImage(File file, String id) async =>
      await _store.storeProfileImage(file, id);

  Stream<DocumentSnapshot<models.User>> getUserStream(String id) =>
      _db.getUserStream(id);

  Future<Resource<String>> sendEmailVerificationEmail() async =>
      await _auth.sendVerificationEmail();

  bool checkIfEmailVerified() => _auth.checkEmailVerified();

  Future<Resource<UserCredential>> signInWithGoogle() async =>
      await _auth.signInWithGoogle();

  Future<bool> checkForUserData(String uid) async =>
      await _db.checkForUserData(uid);

  Future<void> sendOtp(PhoneAuthCallbacks callbacks ,  String number) async =>
      await _auth.sendOtp(callbacks,number);

  Future<bool> checkOTP(PhoneAuthCredential cred) async => await _auth.checkOtp(cred);



  Future<void> logOut() async => await _auth.logOut();
}
