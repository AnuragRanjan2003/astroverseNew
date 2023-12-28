import 'package:astroverse/models/comment.dart';
import 'package:astroverse/models/post.dart';
import 'package:astroverse/models/save_comment.dart';
import 'package:astroverse/res/strings/backend_strings.dart';
import 'package:astroverse/utils/crypt.dart';
import 'package:astroverse/utils/postable.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

CollectionReference<Comment> getCommentCollection(String postId) =>
    FirebaseFirestore.instance
        .collection(BackEndStrings.postCollection)
        .doc(postId)
        .collection(BackEndStrings.comments)
        .withConverter<Comment>(
          fromFirestore: (snapshot, options) =>
              Comment.fromJson(snapshot.data()!),
          toFirestore: (value, options) => value.toJson(),
        );
final _postCollection = FirebaseFirestore.instance
    .collection(BackEndStrings.postCollection)
    .withConverter<Post>(
      fromFirestore: (snapshot, options) => Post.fromJson(snapshot.data()!),
      toFirestore: (value, options) => value.toJson(),
    );
CollectionReference<Post> _userPostCollection(String uid) => FirebaseFirestore
    .instance
    .collection(BackEndStrings.userCollection)
    .doc(uid)
    .collection(BackEndStrings.postCollection)
    .withConverter<Post>(
  fromFirestore: (snapshot, options) => Post.fromJson(snapshot.data()!),
  toFirestore: (value, options) => value.toJson(),
);

class CommentUtils extends Postable<Comment, SaveComment> {
  final String postId;
  final String postAuthorId;

  CommentUtils(this.postId, this.postAuthorId) : super(getCommentCollection(postId), null);

  static const _limit = 3;

  @override
  Future<Resource<int>> dislike(String id) async {
    return Failure<int>("no such method");
  }

  @override
  Future<Resource<List<QueryDocumentSnapshot<Comment>>>> fetchByGenreAndPage(
      List<String> genre, String uid) async {
    try {
      QuerySnapshot<Comment> res =
          await ref.limit(_limit).orderBy("date", descending: true).get();
      final data = res.docs;
      return Success(data);
    } on FirebaseException catch (e) {
      return Failure<List<QueryDocumentSnapshot<Comment>>>(
          e.message.toString());
    } catch (e) {
      return Failure<List<QueryDocumentSnapshot<Comment>>>(e.toString());
    }
  }

  @override
  Future<Resource<List<QueryDocumentSnapshot<Comment>>>> fetchMore(
      QueryDocumentSnapshot<Comment> lastPost,
      List<String> genre,
      String uid) async {
    try {
      final res = await ref
          .limit(_limit)
          .orderBy("date", descending: true)
          .startAfterDocument(lastPost)
          .get();
      return Success(res.docs);
    } on FirebaseException catch (e) {
      return Failure<List<QueryDocumentSnapshot<Comment>>>(
          e.message.toString());
    } catch (e) {
      return Failure<List<QueryDocumentSnapshot<Comment>>>(e.toString());
    }
  }

  @override
  Future<Resource<int>> like(String id) async {
    return Failure("no such method");
  }

  @override
  Stream<QuerySnapshot<SaveComment>> likedStream(String uid) {
    throw UnimplementedError();
  }

  @override
  Future<Resource<Comment>> savePost(Comment comment) async {
    try {
      final batch = FirebaseFirestore.instance.batch();
      batch.set(ref.doc(comment.id), comment);
      batch.update(
          _postCollection.doc(postId), {"comments": FieldValue.increment(1)});
      batch.update(_userPostCollection(postAuthorId).doc(postId), {"comments": FieldValue.increment(1)});

      await batch.commit();
      return Success(comment);
    } on FirebaseException catch (e) {
      return Failure<Comment>(e.message.toString());
    } catch (e) {
      return Failure<Comment>(e.toString());
    }
  }

  @override
  Future<Resource<Json>> update(Map<String, dynamic> data, String id) async {
    try {
      await ref.doc(id).update(data);
      return Success(data);
    } on FirebaseException catch (e) {
      return Failure<Json>(e.message.toString());
    } catch (e) {
      return Failure<Json>(e.toString());
    }
  }
}
