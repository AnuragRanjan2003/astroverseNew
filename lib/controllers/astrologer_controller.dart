import 'package:astroverse/models/user.dart';
import 'package:astroverse/repo/astrologer_repo.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AstrologerController extends GetxController {
  final _repo = AstrologerRepo();
  RxList<User> list = RxList();
  Rxn<QueryDocumentSnapshot<User>> lastDocument = Rxn();
  RxBool moreUsers = true.obs;
  RxString searchText = RxString("");

  void fetchAstrologers(GeoPoint geoPoint) {
    _repo.fetchAstrologer(geoPoint).then((value) {
      if (value.isSuccess) {
        value as Success<List<QueryDocumentSnapshot<User>>>;
        final list = <User>[];
        moreUsers.value = value.data.isNotEmpty;
        lastDocument.value = value.data.last;
        for (QueryDocumentSnapshot<User> it in value.data) {
          list.add(it.data());
        }

        this.list.value = list;
      } else {}
    });
  }

  void fetchMoreAstrologers(GeoPoint geoPoint) {
    if (lastDocument.value == null) fetchAstrologers(geoPoint);
    final last = lastDocument.value!;
    _repo.fetchMoreAstrologers(last).then((value) {
      if (value.isSuccess) {
        value as Success<List<QueryDocumentSnapshot<User>>>;
        final list = <User>[];
        for (var it in value.data) {
          list.add(it.data());
        }
        list.addAll(list);
        if(value.data.isNotEmpty) lastDocument.value = value.data.last;
      } else {}
    });
  }


}
