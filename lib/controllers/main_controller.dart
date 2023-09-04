import 'dart:developer';

import 'package:astroverse/repo/post_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/post.dart';
import '../utils/resource.dart';

class MainController extends GetxController {
  final _postRepo = PostRepo();
  RxList<Post> postList = <Post>[].obs;
  Rx<bool> morePostsToLoad = true.obs;
  Rxn<QueryDocumentSnapshot<Post>> lastPost = Rxn();
  static const _maxPostLimit = 50;
  Rx<bool> nothingToShow = false.obs;
  Rx<bool> loadingMorePosts = false.obs;

  @override
  void onInit() {
    fetchPostsByGenreAndPage(["a", "b"]);
  }

  void savePost(Post post, void Function(Resource<Post>) updateUI) {
    _postRepo.savePost(post).then((value) {
      updateUI(value);
    });
  }

  void fetchPostsByGenreAndPage(List<String> genre) {
    log("loading  posts", name: "POST LIST");
    if (lastPost.value == null) {
      log("null", name: "LP");
    } else {
      log(lastPost.value!.data().toString(), name: "LP");
    }
    loadingMorePosts.value = true;
    _postRepo.fetchPostsByGenreAndPage(genre).then((value) {
      loadingMorePosts.value = false;
      if (value.isSuccess) {
        value = value as Success<List<QueryDocumentSnapshot<Post>>>;
        List<Post> list = [];
        for (var element in value.data) {
          if (element.exists) {
            list.add(element.data());
            lastPost.value = element;
          }
        }
        log("${lastPost.value!.data()}", name: "IS NULL");
        log(list.length.toString(), name: "GOT LIST SIZE");
        log(list.toString(), name: "GOT LIST");
        postList.value = list;
        nothingToShow.value = list.isEmpty;
        log(postList.length.toString(), name: "POST LIST SUCCESS");
      } else {
        value = value as Failure<List<QueryDocumentSnapshot<Post>>>;
        log(value.error, name: "POST LIST FAILED");
      }
    });
  }

  void fetchMorePosts(List<String> genre) {
    log("loading more posts", name: "POST LIST");
    if (morePostsToLoad.value == false || postList.length >= _maxPostLimit) return;
    loadingMorePosts.value = true;
    _postRepo.fetchMorePost(lastPost.value!, genre).then((value) {
      loadingMorePosts.value = false;
      if (value.isSuccess) {
        value = value as Success<List<QueryDocumentSnapshot<Post>>>;
        List<Post> list = [];

        for (var s in value.data) {
          if (s.exists) {
            list.add(s.data());
            lastPost.value = s;
          }
        }
        log("${lastPost.value!.data()}", name: "IS NULL");
        log(list.length.toString(), name: "GOT LIST SIZE");
        log(list.toString(), name: "GOT LIST");
        postList.addAll(list);
        morePostsToLoad.value = list.isNotEmpty;
        log(postList.length.toString(), name: "POST LIST SUCCESS");
      } else {
        value = value as Failure<List<QueryDocumentSnapshot<Post>>>;
        log(value.error, name: "POST LIST FAILED");
      }
    });
  }

  void refreshPosts() {
    clearPosts();
    fetchPostsByGenreAndPage(["a", "b"]);
  }

  void clearPosts() {
    postList.clear();
    lastPost.value = null;
    morePostsToLoad.value = true;
  }
}
