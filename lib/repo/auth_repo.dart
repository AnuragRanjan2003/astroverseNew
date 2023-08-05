import 'package:astroverse/models/user.dart' as models;
import 'package:astroverse/utils/resource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../db/auth.dart';
import '../db/db.dart';

class AuthRepo{
  final _auth = Auth();
  final _db = Database();

  Future<Resource<UserCredential>> loginUser(String email, String password) async => await _auth.loginUser(email , password);

  Future<Resource<UserCredential>> createUser(models.User user , String password) async => await _auth.signupWithEmail(user, password);

  Future<Resource<UserCredential>> saveUserData(models.User user) async => await _db.saveUserData(user);

  Stream<DocumentSnapshot<models.User>> getUserStream(String id) => _db.getUserStream(id);


}