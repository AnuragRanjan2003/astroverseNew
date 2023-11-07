import 'dart:developer';

import 'package:astroverse/models/extra_info.dart';
import 'package:astroverse/repo/auth_repo.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class PublicProfileController extends GetxController {
  static const _tag = "EXTRA INFO";
  final _repo = AuthRepo();
  Rxn<ExtraInfo> info = Rxn();

  getExtraInfo(String uid) {
    _repo.getExtraInfo(uid).then((value) {
      if (value.isSuccess) {
        value as Success<ExtraInfo>;
        info.value = value.data;
        log(value.data.toString(), name: _tag);
      } else {
        info.value = null;
      }
    });
  }

  updateProfileViews(String uid) {
    _repo.updateUserInfo({"profileViews": FieldValue.increment(1)}, uid);
  }
}
