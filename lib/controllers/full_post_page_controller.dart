import 'dart:developer';

import 'package:astroverse/models/user.dart';
import 'package:astroverse/repo/auth_repo.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class FullPostPageController extends GetxController {
  final _repo = AuthRepo();

  Rxn<User> author = Rxn();

  void getAuthor(String uid) {
    if (author.value != null) return;
    _repo.getUserData(uid).then((value) {
      if (value.isSuccess) {
        value = value as Success<DocumentSnapshot<User>>;
        if (value.data.data() != null) author.value = value.data.data()!;
        log("$author", name: "AUTHOR");
      }
    });
  }
}
