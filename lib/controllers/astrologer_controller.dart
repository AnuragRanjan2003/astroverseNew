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
  RxBool moreUsers = true.obs;
  RxString searchText = RxString("");
  Rx<bool> nothingToShow = false.obs;
  Rx<bool> loadingMore = false.obs;

  void fetchAstrologers(GeoPoint geoPoint, String uid) {
    _repo.fetchAstrologersByLocation(uid, geoPoint).then((value) {
      if (value.isSuccess) {
        value as Success<List<QueryDocumentSnapshot<User>>>;
        final list = <User>[];
        moreUsers.value = value.data.isNotEmpty;

        for (QueryDocumentSnapshot<User> it in value.data) {
          list.add(it.data());
          if (it.data().plan == VisibilityPlans.locality) {
            lastForLocality.value = value.data.last;
          }
          if (it.data().plan == VisibilityPlans.city) {
            lastForCity.value = value.data.last;
          }
        }
        this.list.value = list;
      } else {}
    });
  }

  void fetchMoreAstrologers(GeoPoint geoPoint, String uid) {
    if (lastForLocality.value == null && lastForCity.value == null) {
      fetchAstrologers(geoPoint, uid);
    }
    loadingMore.value = true;
    _repo
        .fetchMoreAstrologersByLocation(
            uid, geoPoint, lastForLocality.value, lastForCity.value)
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
          if (it.data().plan == VisibilityPlans.city) lastForCity.value = it;
        }
        moreUsers.value = list.isNotEmpty;
        this.list.addAll(list);
      } else {}
    });
  }
}
