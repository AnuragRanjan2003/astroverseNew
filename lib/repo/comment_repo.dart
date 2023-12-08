import 'package:astroverse/db/db.dart';
import 'package:astroverse/models/comment.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentRepo {
  final _db = Database();

  Future<Resource<List<QueryDocumentSnapshot<Comment>>>> fetchComments(
          String postId) async =>
      await _db.fetchComments(postId);

  Future<Resource<List<QueryDocumentSnapshot<Comment>>>> fetchMoreComments(
          String postId, QueryDocumentSnapshot<Comment> lastPost) async =>
      await _db.fetchMoreComments(postId, lastPost);

  Future<Resource<Comment>> postComment(
          String postId, String postAuthorId, Comment comment) async =>
      await _db.postComment(postId, postAuthorId, comment);

  Future<Resource<Comment>> postReply(
          Comment c, String postId, String commentId) =>
      _db.postReply(postId, commentId, c);

  Future<Resource<List<Comment>>> fetchReplies(
          String postId, String commentId) =>
      _db.fetchReplies(postId, commentId);
}
