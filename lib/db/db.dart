import 'package:astroverse/models/post.dart';
import 'package:astroverse/models/post_save.dart';
import 'package:astroverse/models/save_service.dart';
import 'package:astroverse/models/service.dart';
import 'package:astroverse/models/user.dart' as models;
import 'package:astroverse/res/strings/backend_strings.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:astroverse/utils/safe_call.dart';
import 'package:astroverse/utils/service_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  static const int _limit = 2;
  final _userCollection = FirebaseFirestore.instance
      .collection(BackEndStrings.userCollection)
      .withConverter<models.User>(
        fromFirestore: (snapshot, options) =>
            models.User.fromJson(snapshot.data()),
        toFirestore: (user, options) => user.toJson(),
      );

  final _postCollection = FirebaseFirestore.instance
      .collection(BackEndStrings.postCollection)
      .withConverter<Post>(
        fromFirestore: (snapshot, options) => Post.fromJson(snapshot.data()!),
        toFirestore: (value, options) => value.toJson(),
      );

  CollectionReference<PostSave> _upVotedCollection(String uid) =>
      FirebaseFirestore.instance
          .collection(BackEndStrings.userCollection)
          .doc(uid)
          .collection(BackEndStrings.upvoteCollection)
          .withConverter<PostSave>(
            fromFirestore: (snapshot, options) =>
                PostSave.fromJson(snapshot.data()),
            toFirestore: (value, options) => value.toJson(),
          );

  Future<Resource<void>> saveUserData(models.User user) async =>
      await SafeCall().fireStoreCall<void>(
          () async => await _userCollection.doc(user.uid).set(user));

  Stream<DocumentSnapshot<models.User>> getUserStream(String id) =>
      _userCollection.doc(id).snapshots();

  Future<Resource<DocumentSnapshot<models.User>>> getUserData(
          String uid) async =>
      await SafeCall().fireStoreCall<DocumentSnapshot<models.User>>(
          () async => await _userCollection.doc(uid).get());

  Future<bool> checkForUserData(String uid) async {
    final res =
        await _userCollection.where('uid', isEqualTo: uid).count().get();
    if (res.count == 0) return false;
    return true;
  }

  Future<Resource<Post>> savePost(Post post) async {
    try {
      await _postCollection.doc(post.id).set(post);
      return Success(post);
    } on FirebaseException catch (e) {
      return Failure<Post>(e.message.toString());
    } catch (e) {
      return Failure<Post>(e.toString());
    }
  }

  Future<Resource<Service>> saveService(Service s, String id) async =>
      await ServiceUtils(id).savePost(s);

  Future<Resource<List<QueryDocumentSnapshot<Service>>>>
      fetchServiceByGenreAndPage(List<String> genre , String uid) async =>
          await ServiceUtils(uid).fetchByGenreAndPage(genre);

  Future<Resource<List<QueryDocumentSnapshot<Service>>>> fetchMoreService(
          QueryDocumentSnapshot<Service> lastPost,
          List<String> genre,
          String uid) async =>
      await ServiceUtils(uid).fetchMore(lastPost, genre);

  Future<Resource<int>> increaseServiceVote(String uid, String id) async =>
      await ServiceUtils(uid).like(id);

  Future<Resource<int>> decreaseServiceVote(String uid, String id) async =>
      await ServiceUtils(uid).dislike(id);

  Future<Resource<List<QueryDocumentSnapshot<Post>>>> fetchPostsByGenreAndPage(
      List<String> genre) async {
    try {
      QuerySnapshot<Post> res = await _postCollection
          .limit(_limit)
          .orderBy("date", descending: true)
          .get();
      final data = res.docs;
      return Success(data);
    } on FirebaseException catch (e) {
      return Failure<List<QueryDocumentSnapshot<Post>>>(e.message.toString());
    } catch (e) {
      return Failure<List<QueryDocumentSnapshot<Post>>>(e.toString());
    }
  }

  Future<Resource<List<QueryDocumentSnapshot<Post>>>> fetchMorePosts(
      QueryDocumentSnapshot<Post> lastPost, List<String> genre) async {
    try {
      final res = await _postCollection
          .limit(_limit)
          .orderBy("date", descending: true)
          .startAfterDocument(lastPost)
          .get();
      return Success(res.docs);
    } on FirebaseException catch (e) {
      return Failure<List<QueryDocumentSnapshot<Post>>>(e.message.toString());
    } catch (e) {
      return Failure<List<QueryDocumentSnapshot<Post>>>(e.toString());
    }
  }

  Future<Resource<int>> increaseVote(String id, String uid) async {
    try {
      final res = await _postCollection
          .doc(id)
          .update({"upVotes": FieldValue.increment(1)});
      await _upVotedCollection(uid)
          .doc(id)
          .set(PostSave(id, DateTime.now().toString()));
      return Success(1);
    } on FirebaseException catch (e) {
      return Failure<int>(e.message.toString());
    } catch (e) {
      return Failure<int>(e.toString());
    }
  }

  Future<Resource<int>> decreaseVote(String id, String uid) async {
    try {
      final res = await _postCollection
          .doc(id)
          .update({"upVotes": FieldValue.increment(-1)});
      await _upVotedCollection(uid).doc(id).delete();
      return Success(1);
    } on FirebaseException catch (e) {
      return Failure<int>(e.message.toString());
    } catch (e) {
      return Failure<int>(e.toString());
    }
  }

  Stream<QuerySnapshot<PostSave>> upVotedPostsStream(String uid) {
    return FirebaseFirestore.instance
        .collection(BackEndStrings.userCollection)
        .doc(uid)
        .collection(BackEndStrings.upvoteCollection)
        .withConverter<PostSave>(
          fromFirestore: (snapshot, options) =>
              PostSave.fromJson(snapshot.data()),
          toFirestore: (value, options) => value.toJson(),
        )
        .snapshots();
  }

  Stream<QuerySnapshot<SaveService>> upVotedServicesStream(String uid) =>
      ServiceUtils(uid).likedStream(uid);
}
