import 'dart:developer';

import 'package:astroverse/models/comment.dart';
import 'package:astroverse/models/extra_info.dart';
import 'package:astroverse/models/post.dart';
import 'package:astroverse/models/post_save.dart';
import 'package:astroverse/models/purchase.dart';
import 'package:astroverse/models/save_service.dart';
import 'package:astroverse/models/service.dart';
import 'package:astroverse/models/transaction.dart' as t;
import 'package:astroverse/models/user.dart' as models;
import 'package:astroverse/res/strings/backend_strings.dart';
import 'package:astroverse/utils/comment_utils.dart';
import 'package:astroverse/utils/purchase_utils.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:astroverse/utils/safe_call.dart';
import 'package:astroverse/utils/service_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

typedef SetInfo = String;
typedef Json = Map<String, dynamic>;

class Database {
  static const int _limit = 20;
  final _fireStore = FirebaseFirestore.instance;
  final _userCollection = FirebaseFirestore.instance
      .collection(BackEndStrings.userCollection)
      .withConverter<models.User>(
        fromFirestore: (snapshot, options) =>
            models.User.fromJson(snapshot.data()),
        toFirestore: (user, options) => user.toJson(),
      );

  final _serviceCollection = FirebaseFirestore.instance
      .collection(BackEndStrings.serviceCollection)
      .withConverter<Service>(
    fromFirestore: (snapshot, options) => Service.fromJson(snapshot.data()),
    toFirestore: (item, options) => item.toJson(),
  );

  final _postCollection = FirebaseFirestore.instance
      .collection(BackEndStrings.postCollection)
      .withConverter<Post>(
        fromFirestore: (snapshot, options) => Post.fromJson(snapshot.data()!),
        toFirestore: (value, options) => value.toJson(),
      );

  CollectionReference<Post> _userPostCollection(String uid) => FirebaseFirestore.instance
      .collection(BackEndStrings.userCollection)
      .doc(uid)
      .collection(BackEndStrings.postCollection)
      .withConverter<Post>(
    fromFirestore: (snapshot, options) => Post.fromJson(snapshot.data()!),
    toFirestore: (value, options) => value.toJson(),
  );

  final _transactionCollection = FirebaseFirestore.instance
      .collection(BackEndStrings.transactionCollection)
      .withConverter<t.Transaction>(
        fromFirestore: (snapshot, options) =>
            t.Transaction.fromJson(snapshot.data()),
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

  CollectionReference<Purchase> _purchasesCollection(String uid) =>
      FirebaseFirestore.instance
          .collection(BackEndStrings.userCollection)
          .doc(uid)
          .collection(BackEndStrings.purchasesCollection)
          .withConverter<Purchase>(
            fromFirestore: (snapshot, options) =>
                Purchase.fromJson(snapshot.data()!),
            toFirestore: (value, options) => value.toJson(),
          );

  CollectionReference<models.User> _followingCollection(String uid) =>
      FirebaseFirestore.instance
          .collection(BackEndStrings.userCollection)
          .doc(uid)
          .collection(BackEndStrings.followingCollection)
          .withConverter<models.User>(
            fromFirestore: (snapshot, options) =>
                models.User.fromJson(snapshot.data()),
            toFirestore: (value, options) => value.toJson(),
          );

  DocumentReference<ExtraInfo> _extraInfoDocument(String uid) =>
      FirebaseFirestore.instance
          .collection(BackEndStrings.userCollection)
          .doc(uid)
          .collection(BackEndStrings.metaDataCollection)
          .doc('extraInfo')
          .withConverter<ExtraInfo>(
            fromFirestore: (snapshot, options) =>
                ExtraInfo.fromJson(snapshot.data()),
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
      final batch = _fireStore.batch();
      batch.set(_postCollection.doc(post.id), post);
      batch.set(_userPostCollection(post.authorId).doc(post.id), post);
      await batch.commit();
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
      fetchServiceByGenreAndPage(List<String> genre, String uid) async =>
          await ServiceUtils(uid).fetchByGenreAndPage(genre, uid);

  Future<Resource<List<QueryDocumentSnapshot<Service>>>> fetchMoreService(
          QueryDocumentSnapshot<Service> lastPost,
          List<String> genre,
          String uid) async =>
      await ServiceUtils(uid).fetchMore(lastPost, genre, uid);

  Future<Resource<int>> increaseServiceVote(String uid, String id) async =>
      await ServiceUtils(uid).like(id);

  Future<Resource<int>> decreaseServiceVote(String uid, String id) async =>
      await ServiceUtils(uid).dislike(id);

  Future<Resource<List<QueryDocumentSnapshot<Post>>>> fetchPostsByGenreAndPage(
      List<String> genre, String uid) async {
    try {
      QuerySnapshot<Post> res = await _postCollection
          .limit(_limit)
          .where("authorId", isNotEqualTo: uid)
          .orderBy("authorId")
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
      QueryDocumentSnapshot<Post> lastPost,
      List<String> genre,
      String uid) async {
    try {
      final res = await _postCollection
          .limit(_limit)
          .where("authorId", isNotEqualTo: uid)
          .orderBy("authorId")
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

  Future<Resource<int>> increaseVote(String id, String uid,String authorId) async {
    try {
      final batch = _fireStore.batch();
      batch.update(_postCollection.doc(id), {"upVotes": FieldValue.increment(1)});
      batch.set(_upVotedCollection(uid).doc(id), PostSave(id, DateTime.now().toString()));
      final document = _userPostCollection(authorId).doc(id);
      batch.update(document, {"upVotes": FieldValue.increment(1)});
      await batch.commit();
      return Success(1);
    } on FirebaseException catch (e) {
      return Failure<int>(e.message.toString());
    } catch (e) {
      return Failure<int>(e.toString());
    }
  }

  Future<Resource<int>> decreaseVote(String id, String uid , String authorId) async {
    try {
      final batch = _fireStore.batch();
      batch.update(_postCollection.doc(id), {"upVotes": FieldValue.increment(-1)});
      batch.delete(_upVotedCollection(uid).doc(id));
      final document = _userPostCollection(authorId).doc(id);
      batch.update(document, {"upVotes": FieldValue.increment(-1)});
      await batch.commit();
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

  Future<Resource<List<QueryDocumentSnapshot<Comment>>>> fetchComments(
          String postId) async =>
      await CommentUtils(postId).fetchByGenreAndPage([], "");

  Future<Resource<List<QueryDocumentSnapshot<Comment>>>> fetchMoreComments(
          String postId, QueryDocumentSnapshot<Comment> lastPost) async =>
      await CommentUtils(postId).fetchMore(lastPost, [], "");

  Future<Resource<Comment>> postComment(String postId, Comment post) async {
    await _postCollection
        .doc(postId)
        .update({"comments": FieldValue.increment(1)});
    return await CommentUtils(postId).savePost(post);
  }

  Future<void> addPostView(String id) async {
    try {
      await _postCollection.doc(id).update({'views': FieldValue.increment(1)});
    } catch (e) {
      log(e.toString(), name: "VIEWS");
    }
  }

  Future<Resource<void>> addTransaction(t.Transaction item) async =>
      await SafeCall().fireStoreCall<void>(
          () async => await _transactionCollection.doc(item.id).set(item));

  Future<Resource<void>> addFollowing(
          String uid, models.User astrologer) async =>
      await SafeCall().fireStoreCall<void>(() async =>
          await _followingCollection(uid).doc(astrologer.uid).set(astrologer));

  Future<Resource<List<QueryDocumentSnapshot<models.User>>>> fetchAstrologers(
      String currentUid, GeoPoint place) async {
    try {
      QuerySnapshot<models.User> res = await _userCollection
          .limit(_limit)
          .where('astro', isEqualTo: true)
          .where('uid', isNotEqualTo: currentUid)
          .get();
      final data = res.docs;
      return Success(data);
    } on FirebaseException catch (e) {
      return Failure<List<QueryDocumentSnapshot<models.User>>>(
          e.message.toString());
    } catch (e) {
      return Failure<List<QueryDocumentSnapshot<models.User>>>(e.toString());
    }
  }

  Future<Resource<List<QueryDocumentSnapshot<models.User>>>>
      fetchMoreAstrologers(
          QueryDocumentSnapshot<models.User> last, String currentUid) async {
    try {
      final QuerySnapshot<models.User> res = await _userCollection
          .limit(_limit)
          .where('astro', isEqualTo: true)
          .where('uid', isNotEqualTo: currentUid)
          .startAfterDocument(last)
          .get();
      return Success(res.docs);
    } on FirebaseException catch (e) {
      return Failure<List<QueryDocumentSnapshot<models.User>>>(
          e.message.toString());
    } catch (e) {
      return Failure<List<QueryDocumentSnapshot<models.User>>>(e.toString());
    }
  }

  Future<Resource<ExtraInfo>> getExtraInfo(String uid) async {
    try {
      final res = await _extraInfoDocument(uid).get();
      if (res.data() != null) return Success<ExtraInfo>(res.data()!);
      return Failure<ExtraInfo>("null returned");
    } on FirebaseException catch (e) {
      return Failure<ExtraInfo>(e.message.toString());
    } catch (e) {
      return Failure<ExtraInfo>(e.toString());
    }
  }

  Future<Resource<SetInfo>> setExtraInfo(ExtraInfo info, String uid) async {
    try {
      await _extraInfoDocument(uid).set(info, SetOptions(merge: true));
      return Success<SetInfo>("set data");
    } on FirebaseException catch (e) {
      return Failure<SetInfo>(e.message.toString());
    } catch (e) {
      return Failure<SetInfo>(e.toString());
    }
  }

  Future<Resource<SetInfo>> updateExtraInfo(String uid, Json data) async {
    try {
      await _extraInfoDocument(uid).update(data);
      return Success<SetInfo>("done");
    } on FirebaseException catch (e) {
      return Failure<SetInfo>(e.message.toString());
    } catch (e) {
      return Failure<SetInfo>(e.toString());
    }
  }

  Future<Resource<Json>> updateUser(Json data, String uid) async {
    try {
      await _userCollection.doc(uid).update(data);
      return Success<Json>(data);
    } on FirebaseException catch (e) {
      return Failure<Json>(e.message.toString());
    } catch (e) {
      return Failure<Json>(e.toString());
    }
  }

  Future<Resource<Purchase>> postPurchase(Purchase purchase) async {
    return await PurchaseUtils(_purchasesCollection(purchase.buyerId),
            _purchasesCollection(purchase.sellerId),_serviceCollection,_extraInfoDocument(purchase.sellerId))
        .savePost(purchase);
  }

  Future<Resource<Json>> updatePurchase(
          Json data, String id, String buyerId, String sellerId) async =>
      await PurchaseUtils(
              _purchasesCollection(sellerId), _purchasesCollection(buyerId),null,null)
          .update(data, id);

  Future<Resource<List<QueryDocumentSnapshot<Purchase>>>> fetchPurchases(
          String buyerUid) async =>
      await PurchaseUtils(
              _purchasesCollection(buyerUid), _purchasesCollection(buyerUid),null,null)
          .fetchByGenreAndPage([], buyerUid);

  Future<Resource<List<QueryDocumentSnapshot<Purchase>>>> fetchMorePurchases(
          QueryDocumentSnapshot<Purchase> lastPost, String buyerUid) async =>
      await PurchaseUtils(_purchasesCollection(buyerUid), null,null,null)
          .fetchMore(lastPost, [], buyerUid);

  Future<Resource<List<QueryDocumentSnapshot<Purchase>>>> fetchSoldItems(
          String uid) async =>
      await PurchaseUtils(_purchasesCollection(uid), _purchasesCollection(uid),null,null)
          .fetchSoldItems(uid);

  Future<Resource<List<QueryDocumentSnapshot<Purchase>>>> fetchMoreSoldItems(
          QueryDocumentSnapshot<Purchase> lastPost, String uid) async =>
      await PurchaseUtils(_purchasesCollection(uid), null,null,null)
          .fetchMore(lastPost, [], uid);

  Future<Resource<Json>> updateService(Json data, String serviceId , String uid) async => await ServiceUtils(uid).update(data, serviceId);
}
