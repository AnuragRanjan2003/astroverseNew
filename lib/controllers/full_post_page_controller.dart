import 'dart:developer';

import 'package:astroverse/models/comment.dart';
import 'package:astroverse/models/user.dart';
import 'package:astroverse/repo/auth_repo.dart';
import 'package:astroverse/repo/comment_repo.dart';
import 'package:astroverse/repo/post_repo.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class FullPostPageController extends GetxController {
  final _repo = AuthRepo();
  final _commentRepo = CommentRepo();
  final _postRepo = PostRepo();

  Rxn<User> author = Rxn();

  RxList<Comment> commentList = RxList();
  Rxn<QueryDocumentSnapshot<Comment>> lastComment = Rxn();
  RxBool moreCommentsToLoad = false.obs;

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

  fetchMoreComments(String postId) {
    log(lastComment.value.toString(), name: "LAST COMMENT");
    if (lastComment.value == null) {
      _commentRepo.fetchComments(postId);
    } else {
      _commentRepo.fetchMoreComments(postId, lastComment.value!).then((value) {
        if (value.isSuccess) {
          value as Success<List<QueryDocumentSnapshot<Comment>>>;
          final list = <Comment>[];

          for (var element in value.data) {
            if (element.exists) {
              list.add(element.data());
              lastComment.value = element;
            }
          }
          moreCommentsToLoad.value = list.isNotEmpty;
          commentList.addAll(list);
        } else {
          value as Failure<List<QueryDocumentSnapshot<Comment>>>;
          log(value.error, name: "COMMENT");
        }
      });
    }
  }

  void addPostView(String id, String authorId) {
    _postRepo.addPostView(id, authorId);
  }

  void fetchComments(String postId) {
    _commentRepo.fetchComments(postId).then((value) {
      if (value.isSuccess) {
        value = value as Success<List<QueryDocumentSnapshot<Comment>>>;
        final list = <Comment>[];

        for (var element in value.data) {
          list.add(element.data());
        }
        list.isNotEmpty ? lastComment.value = value.data.last : null;
        moreCommentsToLoad.value = list.isNotEmpty;

        commentList.value = list;
      } else {
        value = value as Failure<List<QueryDocumentSnapshot<Comment>>>;
        log(value.error, name: "COMMENTS");
      }
    });
  }

  void postComment(Comment comment, postId ,String postAuthorId,) {
    final id = const Uuid().v4();
    comment.id = id;
    _commentRepo.postComment(postId, postAuthorId,comment).then((value) {
      if (value.isSuccess) {
        value = value as Success<Comment>;
        log('comment posted', name: "COMMENT");
      } else {
        value as Failure<Comment>;
        log(value.error, name: "COMMENT");
      }
    });
  }
}
