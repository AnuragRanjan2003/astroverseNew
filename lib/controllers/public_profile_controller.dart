import 'dart:developer';

import 'package:astroverse/models/extra_info.dart';
import 'package:astroverse/models/post.dart';
import 'package:astroverse/models/save_service.dart';
import 'package:astroverse/repo/auth_repo.dart';
import 'package:astroverse/repo/post_repo.dart';
import 'package:astroverse/repo/service_repo.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class PublicProfileController extends GetxController {
  static const _tag = "EXTRA INFO";
  final _repo = AuthRepo();
  final _post = PostRepo();
  final _service = ServiceRepo();
  Rxn<ExtraInfo> info = Rxn();
  RxList<Post> posts = <Post>[].obs;
  RxList<SaveService> service = <SaveService>[].obs;
  RxBool postsLoading = false.obs;
  RxBool serviceLoading = false.obs;

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

  fetchUserPosts(String userId){
    postsLoading.value = true;
    _post.fetchUserPost(userId).then((value) {
      postsLoading.value = false;
      if(value.isSuccess){
        value as Success<List<QueryDocumentSnapshot<Post>>>;
        final list = <Post>[];
        for(var it in value.data){
          list.add(it.data());
        }

        posts.value = list;

      }else{

      }
    });
  }

  fetchUserServices(String userId){
    serviceLoading.value = true;
    _service.fetchMyServices(userId).then((value) {
      serviceLoading.value = false;
      if(value.isSuccess){
        value as Success<List<QueryDocumentSnapshot<SaveService>>>;
        final list = <SaveService>[];
        for(var it in value.data){
          list.add(it.data());
        }

        service.value = list;

      }else{

      }
    });

  }
}
