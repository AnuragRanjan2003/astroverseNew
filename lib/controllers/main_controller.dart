import 'dart:async';
import 'dart:developer';

import 'package:astroverse/controllers/new_page_controller.dart';
import 'package:astroverse/models/post_save.dart';
import 'package:astroverse/models/user.dart';
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
  RxList<PostSave> upVotedPosts = <PostSave>[].obs;
  Rxn<User> user = Rxn();
  StreamSubscription<DocumentSnapshot<String>>? likes;



  void setUser(User? user) {
    this.user.value = user;
    if (this.user.value != null) startReadingUpVotedPosts(this.user.value!.uid);
  }

  @override
  void onClose() {
    likes?.cancel();
  }

  void fetchPostsByGenreAndPage(List<String> genre , String uid) {
    log("loading  posts", name: "POST LIST");
    if (lastPost.value == null) {
      log("null", name: "LP");
    } else {
      log(lastPost.value!.data().toString(), name: "LP");
    }
    loadingMorePosts.value = true;
    _postRepo.fetchPostsByGenreAndPage(genre,uid).then((value) {
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
        //log("${lastPost.value!.data()}", name: "IS NULL");
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

  void fetchMorePosts(List<String> genre , String uid) {
    log("loading more posts", name: "POST LIST");
    if (morePostsToLoad.value == false || postList.length >= _maxPostLimit) {
      return;
    }
    loadingMorePosts.value = true;

    _postRepo.fetchMorePost(lastPost.value!, genre , uid).then((value) {
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

  void refreshPosts(List<String> genre , String uid) {
    clearPosts();
    log(genre.toString(), name: "GENRES");
    fetchPostsByGenreAndPage(genre , uid);
  }

  void increaseVote(String id, String uid, Function() onComplete) {
    final e = postList.indexWhere((element) => element.id == id);
    postList[e].upVotes++;
    postList.refresh();
    _postRepo.increaseVote(id, uid).then((value) {
      if (value.isSuccess) {
        log("up voted");

        log('upvoted to : ${postList[e].upVotes}', name: "UPVOTES");
        onComplete();
      }
    });
  }

  void decrementVote(String id, String uid, Function() onComplete) {
    final e = postList.indexWhere((element) => element.id == id);
    postList[e].upVotes--;
    postList.refresh();
    _postRepo.decreaseVote(id, uid).then((value) {
      if (value.isSuccess) {
        log("down voted");
        log('upvoted to : ${postList[e].upVotes}', name: "UPVOTES");
        onComplete();
      }
    });
  }

  void startReadingUpVotedPosts(String? uid) {
    log("reading upvotes", name: "UPVOTES");
    likes?.cancel();
    var list = <PostSave>[];
    if (uid == null) return;
    _postRepo.upVotedPostStream(uid).listen((event) {
      log("liked changed", name: "UPVOTES");
      for (var it in event.docs) {
        list.add(it.data());
      }
      upVotedPosts.clear();
      upVotedPosts.value = list;
      upVotedPosts.refresh();
      log(upVotedPosts.toString(), name: "UPVOTED");
    });
  }

  void clearPosts() {
    postList.clear();
    lastPost.value = null;
    morePostsToLoad.value = true;
  }

  int filteredLength(List<String> l) {
    int n = 0;
    for (var it in postList) {
      if (areEqual(it.genre, l)) n++;
    }

    return n;
  }

  bool areEqual(List l1, List l2) {
    if (l1.length == l2.length && l1.every((element) => l2.contains(element))) {
      return true;
    }
    return false;
  }
}
