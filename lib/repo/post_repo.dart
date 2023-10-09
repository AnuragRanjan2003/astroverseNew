

import 'dart:io';

import 'package:astroverse/db/db.dart';
import 'package:astroverse/db/storage.dart';
import 'package:astroverse/models/post_save.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/post.dart';

class PostRepo {
  final _db = Database();
  final _storage = Storage();

  Future<Resource<Post>> savePost(Post post) async => await _db.savePost(post);

  Future<Resource<String>> storePostImage(File file , String id) async => await _storage.storePostImage(file, id);

  Future<Resource<List<QueryDocumentSnapshot<Post>>>> fetchPostsByGenreAndPage(
          List<String> genre) async =>
      await _db.fetchPostsByGenreAndPage(genre);

  Future<Resource<List<QueryDocumentSnapshot<Post>>>> fetchMorePost(
          QueryDocumentSnapshot<Post> lastPost, List<String> genre) async =>
      await _db.fetchMorePosts(lastPost, genre);

  Future<Resource<int>> increaseVote(String id, String uid) async =>
      await _db.increaseVote(id, uid);

  Future<Resource<int>> decreaseVote(String id , String uid) async =>
      await _db.decreaseVote(id,uid);

     Stream<QuerySnapshot<PostSave>> upVotedPostStream(String uid ) =>
      _db.upVotedPostsStream(uid );
}
