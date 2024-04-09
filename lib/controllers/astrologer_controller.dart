import 'dart:developer';

import 'package:astroverse/models/user.dart';
import 'package:astroverse/repo/astrologer_repo.dart';
import 'package:astroverse/utils/geo.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AstrologerController extends GetxController {
  final _repo = AstrologerRepo();
  RxList<User> list = RxList();
  Rxn<QueryDocumentSnapshot<User>> lastForLocality = Rxn();
  Rxn<QueryDocumentSnapshot<User>> lastForCity = Rxn();
  Rxn<QueryDocumentSnapshot<User>> lastForState = Rxn();
  Rxn<QueryDocumentSnapshot<User>> lastForAll = Rxn();
  Rxn<QueryDocumentSnapshot<User>> lastForFeatured = Rxn();
  RxBool moreUsers = true.obs;
  RxString searchText = RxString("");
  Rx<bool> nothingToShow = false.obs;
  Rx<bool> loadingMore = false.obs;

  void fetchAstrologers(GeoPoint geoPoint, String uid) {
    _repo.fetchAstrologersByLocation(uid, geoPoint).then((value) {
      if (value.isSuccess) {
        value as Success<List<QueryDocumentSnapshot<User>>>;
        var list = <User>[];
        moreUsers.value = value.data.isNotEmpty;
        for (QueryDocumentSnapshot<User> it in value.data) {
          list.add(it.data());
          if (it.data().featured) {
            lastForFeatured.value = value.data.last;
            continue;
          }
          if (it.data().plan == VisibilityPlans.locality) {
            lastForLocality.value = value.data.last;
          }
          if (it.data().plan == VisibilityPlans.city) {
            lastForCity.value = value.data.last;
          }
          if (it.data().plan == VisibilityPlans.state) {
            lastForState.value = value.data.last;
          }
          if (it.data().plan == VisibilityPlans.all) {
            lastForAll.value = value.data.last;
          }
        }

        this.list.value = list;
        log("$list", name: "ASTRO");
      } else {}
    });
  }

  void fetchMoreAstrologers(GeoPoint geoPoint, String uid) {
    if (lastForLocality.value == null &&
        lastForCity.value == null &&
        lastForState.value == null &&
        lastForAll.value == null &&
        lastForFeatured.value == null) {
      fetchAstrologers(geoPoint, uid);
    }
    loadingMore.value = true;
    _repo
        .fetchMoreAstrologersByLocation(
            uid,
            geoPoint,
            lastForLocality.value,
            lastForCity.value,
            lastForState.value,
            lastForAll.value,
            lastForFeatured.value)
        .then((value) {
      loadingMore.value = false;
      if (value.isSuccess) {
        value as Success<List<QueryDocumentSnapshot<User>>>;
        final list = <User>[];
        for (var it in value.data) {
          list.add(it.data());
          if (it.data().plan == VisibilityPlans.locality) {
            lastForLocality.value = it;
          }
          if(it.data().featured){
            lastForFeatured.value = it;
            continue;
          }
          if (it.data().plan == VisibilityPlans.city) lastForCity.value = it;
          if (it.data().plan == VisibilityPlans.state) lastForState.value = it;
          if (it.data().plan == VisibilityPlans.all) lastForAll.value = it;
        }
        moreUsers.value = list.isNotEmpty;

        this.list.addAll(list);
      } else {}
    });
  }
}
