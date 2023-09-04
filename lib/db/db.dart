import 'package:astroverse/models/item.dart';
import 'package:astroverse/models/post.dart';
import 'package:astroverse/models/user.dart' as models;
import 'package:astroverse/res/strings/backend_strings.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:astroverse/utils/safe_call.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Database {
  static const int _limit = 5;
  final _userCollection = FirebaseFirestore.instance
      .collection(BackEndStrings.userCollection)
      .withConverter<models.User>(
        fromFirestore: (snapshot, options) =>
            models.User.fromJson(snapshot.data()),
        toFirestore: (user, options) => user.toJson(),
      );

  final _itemCollection = FirebaseFirestore.instance
      .collection(BackEndStrings.itemsCollection)
      .withConverter<Item>(
        fromFirestore: (snapshot, options) => Item.fromJson(snapshot.data()!),
        toFirestore: (item, options) => item.toJson(),
      );

  final _postCollection = FirebaseFirestore.instance
      .collection(BackEndStrings.postCollection)
      .withConverter<Post>(
        fromFirestore: (snapshot, options) => Post.fromJson(snapshot.data()!),
        toFirestore: (value, options) => value.toJson(),
      );

  Future<Resource<void>> saveUserData(models.User user) async =>
      await SafeCall().fireStoreCall<void>(
          () async => await _userCollection.doc(user.uid).set(user));

  Future<Resource<void>> saveItemData(Item item) async =>
      await SafeCall().fireStoreCall<void>(
          () async => await _itemCollection.doc(item.id).set(item));

  Stream<DocumentSnapshot<models.User>> getUserStream(String id) =>
      _userCollection.doc(id).snapshots();

  getMoreItems(DocumentSnapshot ds, List<String> cat) =>
      _itemCollection.startAfterDocument(ds).limit(20).where(
        "category",
        whereIn: [cat],
      );

  Future<bool> checkForUserData(String uid) async {
    final res =
        await _userCollection.where('uid', isEqualTo: uid).count().get();
    if (res.count == 0) return false;
    return true;
  }

  Future<Resource<Post>> savePost(Post post) async {
    try {
      post.id = const Uuid().v4();
      await _postCollection.doc(post.id).set(post);
      return Success(post);
    } on FirebaseException catch (e) {
      return Failure<Post>(e.message.toString());
    } catch (e) {
      return Failure<Post>(e.toString());
    }
  }

  Future<Resource<List<QueryDocumentSnapshot<Post>>>> fetchPostsByGenreAndPage(
      List<String> genre) async {
    try {
      QuerySnapshot<Post> res = await _postCollection
          .limit(_limit)
          .where("genre", arrayContainsAny: genre)
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
          .where("genre", arrayContainsAny: genre)
          .startAfterDocument(lastPost)
          .get();
      return Success(res.docs);
    } on FirebaseException catch (e) {
      return Failure<List<QueryDocumentSnapshot<Post>>>(e.message.toString());
    } catch (e) {
      return Failure<List<QueryDocumentSnapshot<Post>>>(e.toString());
    }
  }
}
