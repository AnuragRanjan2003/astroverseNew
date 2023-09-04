import 'package:astroverse/db/db.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/post.dart';

class PostRepo {
  final _db = Database();

  Future<Resource<Post>> savePost(Post post) async => await _db.savePost(post);

  Future<Resource<List<QueryDocumentSnapshot<Post>>>> fetchPostsByGenreAndPage(
          List<String> genre) async =>
      await _db.fetchPostsByGenreAndPage(genre);

  Future<Resource<List<QueryDocumentSnapshot<Post>>>> fetchMorePost(
          QueryDocumentSnapshot<Post> lastPost, List<String> genre) async =>
      await _db.fetchMorePosts(lastPost, genre);
}
