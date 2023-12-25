import 'package:astroverse/models/purchase.dart';
import 'package:astroverse/utils/crypt.dart';
import 'package:astroverse/utils/postable.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

typedef Json = Map<String, dynamic>;

class PurchaseUtils extends Postable<Purchase, Purchase> {
  final _db = FirebaseFirestore.instance;
  final CollectionReference? servicesCollection;
  final DocumentReference? extraInfoDocument;
  static const int _limit = 20;

  final _crypto = Crypt();

  PurchaseUtils(super.ref, super.likeRef, this.servicesCollection,
      this.extraInfoDocument);

  @override
  Future<Resource<int>> dislike(String id) {
    // TODO: implement dislike
    throw UnimplementedError();
  }

  @override
  Future<Resource<List<QueryDocumentSnapshot<Purchase>>>> fetchByGenreAndPage(
      List<String> genre, String uid) async {
    try {
      final QuerySnapshot<Purchase> res = await ref
          .orderBy("boughtOn", descending: true)
          .where("buyerId", isEqualTo: uid)
          .limit(_limit)
          .get();
      final List<QueryDocumentSnapshot<Purchase>> data = res.docs;
      return Success(data);
    } on FirebaseException catch (e) {
      return Failure<List<QueryDocumentSnapshot<Purchase>>>(
          e.message.toString());
    } catch (e) {
      return Failure<List<QueryDocumentSnapshot<Purchase>>>(e.toString());
    }
  }

  Future<Resource<List<QueryDocumentSnapshot<Purchase>>>> fetchSoldItems(
      String uid) async {
    try {
      final QuerySnapshot<Purchase> res = await ref
          .orderBy("boughtOn", descending: true)
          .where("sellerId", isEqualTo: uid)
          .limit(_limit)
          .get();
      final List<QueryDocumentSnapshot<Purchase>> data = res.docs;
      return Success(data);
    } on FirebaseException catch (e) {
      return Failure<List<QueryDocumentSnapshot<Purchase>>>(
          e.message.toString());
    } catch (e) {
      return Failure<List<QueryDocumentSnapshot<Purchase>>>(e.toString());
    }
  }

  @override
  Future<Resource<List<QueryDocumentSnapshot<Purchase>>>> fetchMore(
      QueryDocumentSnapshot<Purchase> lastPost,
      List<String> genre,
      String uid) async {
    try {
      final res = await ref
          .limit(_limit)
          .orderBy("boughtOn", descending: true)
          .where("buyerId", isEqualTo: uid)
          .startAfterDocument(lastPost)
          .get();
      return Success(res.docs);
    } on FirebaseException catch (e) {
      return Failure<List<QueryDocumentSnapshot<Purchase>>>(
          e.message.toString());
    } catch (e) {
      return Failure<List<QueryDocumentSnapshot<Purchase>>>(e.toString());
    }
  }

  Future<Resource<List<QueryDocumentSnapshot<Purchase>>>> fetchMoreSoldItems(
      QueryDocumentSnapshot<Purchase> lastPost,
      List<String> genre,
      String uid) async {
    try {
      final res = await ref
          .limit(_limit)
          .orderBy("boughtOn", descending: true)
          .where("sellerId", isEqualTo: uid)
          .startAfterDocument(lastPost)
          .get();
      return Success(res.docs);
    } on FirebaseException catch (e) {
      return Failure<List<QueryDocumentSnapshot<Purchase>>>(
          e.message.toString());
    } catch (e) {
      return Failure<List<QueryDocumentSnapshot<Purchase>>>(e.toString());
    }
  }

  @override
  Future<Resource<int>> like(String id) {
    // TODO: implement like
    throw UnimplementedError();
  }

  @override
  Stream<QuerySnapshot<Purchase>> likedStream(String uid) {
    // TODO: implement likedStream
    throw UnimplementedError();
  }

  @override
  Future<Resource<Purchase>> savePost(Purchase purchase) async {
    try {
      final batch = _db.batch();
      purchase.secretCode = _crypto.encryptToBase64String(purchase.secretCode);
      batch.set(ref.doc(purchase.purchaseId), purchase);
      batch.set(likeRef!.doc(purchase.purchaseId), purchase);
      batch.update(servicesCollection!.doc(purchase.itemId), {
        "uses": FieldValue.increment(1),
        "lastDate": FieldValue.serverTimestamp()
      });
      batch.update(
          extraInfoDocument!, {"servicesSold": FieldValue.increment(1)});
      await batch.commit();
      return Success<Purchase>(purchase);
    } on FirebaseException catch (e) {
      return Failure<Purchase>(e.message.toString());
    } catch (e) {
      return Failure<Purchase>(e.toString());
    }
  }

  @override
  Future<Resource<Json>> update(Json data, String id) async {
    try {
      final batch = _db.batch();
      batch.update(ref.doc(id), data);
      batch.update(likeRef!.doc(id), data);
      await batch.commit();
      return Success<Json>(data);
    } on FirebaseException catch (e) {
      return Failure<Json>(e.message.toString());
    } catch (e) {
      return Failure<Json>(e.toString());
    }
  }

  Stream<DocumentSnapshot<Purchase>> purchaseStream(String id) {
    return ref.doc(id).snapshots();
  }

  Future<Resource<Json>> cancelPurchaseByUser(String id) async {
    try {
      final data = {'active': false};
      final batch = FirebaseFirestore.instance.batch();
      batch.update(ref.doc(id), data);
      batch.update(likeRef!.doc(id), data);
      await batch.commit();
      return Success<Json>(data);
    } on FirebaseException catch (e) {
      return Failure<Json>(e.message.toString());
    } catch (e) {
      return Failure<Json>(e.toString());
    }
  }
}
