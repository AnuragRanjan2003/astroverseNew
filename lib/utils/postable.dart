import 'package:astroverse/utils/resource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

typedef Json = Map<String, dynamic>;

abstract class Postable<T, T2> {
  final CollectionReference<T> ref;
  final CollectionReference<T2>? likeRef;
  static const limit = 3;

  Postable(this.ref, this.likeRef);

  Future<Resource<T>> savePost(T post);

  Future<Resource<List<QueryDocumentSnapshot<T>>>> fetchByGenreAndPage(
      List<String> genre, String uid);

  Future<Resource<List<QueryDocumentSnapshot<T>>>> fetchMore(
      QueryDocumentSnapshot<T> lastPost, List<String> genre, String uid);

  Future<Resource<int>> like(String id);

  Future<Resource<int>> dislike(String id);

  Stream<QuerySnapshot<T2>> likedStream(String uid);

  static Future<Resource<Json>> update(Json data, String id) async {
    return Failure("unimplemented");
  }
}
