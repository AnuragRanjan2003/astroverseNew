import 'dart:io';

import 'package:astroverse/db/storage.dart';
import 'package:astroverse/models/extra_info.dart';
import 'package:astroverse/models/user.dart' as models;
import 'package:astroverse/models/user_bank_details.dart';
import 'package:astroverse/utils/phone_auth_callbacks.dart';
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

  Future<Resource<DocumentSnapshot<models.User>>> getUserData(
          String uid) async =>
      await _db.getUserData(uid);

  Future<Resource<String>> sendEmailVerificationEmail() async =>
      await _auth.sendVerificationEmail();

  bool checkIfEmailVerified() => _auth.checkEmailVerified();

  Future<Resource<UserCredential>> signInWithGoogle() async =>
      await _auth.signInWithGoogle();

  Future<bool> checkForUserData(String uid) async =>
      await _db.checkForUserData(uid);

  Future<void> sendOtp(PhoneAuthCallbacks callbacks, String number) async =>
      await _auth.sendOtp(callbacks, number);

  Future<bool> checkOTP(PhoneAuthCredential cred) async =>
      await _auth.checkOtp(cred);

  Future<Resource<SetInfo>> setExtraInfo(ExtraInfo info, String uid) async =>
      await _db.setExtraInfo(info, uid);

  Future<Resource<ExtraInfo>> getExtraInfo(String uid) async =>
      await _db.getExtraInfo(uid);

  Future<Resource<SetInfo>> updateExtraInfo(
          Map<String, dynamic> data, String uid) async =>
      await _db.updateExtraInfo(uid, data);

  Future<Resource<Json>> updateUserInfo(
          Map<String, dynamic> data, String uid) async =>
      await _db.updateUser(data, uid);

  Future<Resource<Json>> addCoinsInDatabase(int coinsToGive, String uid) =>
      _db.updateUser({"coins": FieldValue.increment(coinsToGive)}, uid);

  Future<Resource<UserBankDetails>> saveUserBankDetails(
          UserBankDetails data, String uid) =>
      _db.saveBankDetails(data, uid);

  Future<Resource<Json>> updateUserBankDetails(Json data, String uid) =>
      _db.updateBankDetails(data, uid);

  Stream<DocumentSnapshot<UserBankDetails>> userBankDetailsStream(String uid) =>
      _db.getBankDetailsStream(uid);

  Future<Resource<Json>> updateRangeForUser(String uid, int range, int cost) =>
      _db.upgradeRangeForUser(uid, cost, range);

  Future<Resource<String>> sendPasswordResetEmail(String email) => _auth.sentForgotPasswordEmail(email);

  Future<void> logOut() async => await _auth.logOut();
}
