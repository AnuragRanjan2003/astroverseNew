import 'dart:io';

import 'package:astroverse/db/storage.dart';
import 'package:astroverse/models/user.dart' as models;
import 'package:astroverse/utils/resource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../db/auth.dart';
import '../db/db.dart';

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
}
