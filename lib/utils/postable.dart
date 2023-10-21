import 'package:astroverse/utils/resource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/post.dart';
import '../models/post_save.dart';

abstract class Postable<T,T2> {
  final CollectionReference<T> ref;
  final CollectionReference<T2>? likeRef;
  static const limit = 3;

  Postable(this.ref, this.likeRef);


  Future<Resource<T>> savePost(T post);

  Future<Resource<List<QueryDocumentSnapshot<T>>>> fetchByGenreAndPage(
      List<String> genre);

  Future<Resource<List<QueryDocumentSnapshot<T>>>> fetchMore(
      QueryDocumentSnapshot<T> lastPost, List<String> genre);

  Future<Resource<int>> like(String id);

  Future<Resource<int>> dislike(String id);

  Stream<QuerySnapshot<T2>> likedStream(
      String uid);
}
