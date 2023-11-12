import 'package:astroverse/db/db.dart';
import 'package:astroverse/models/purchase.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

typedef Json = Map<String, dynamic>;

class PurchaseRepo {
  final _db = Database();

  Future<Resource<Purchase>> postPurchase(Purchase purchase) async =>
      await _db.postPurchase(purchase);

  Future<Resource<Json>> updatePurchase(
          Json data, String id, String buyerId, String sellerId) async =>
      await _db.updatePurchase(data, id, buyerId, sellerId);

  Future<Resource<List<QueryDocumentSnapshot<Purchase>>>> fetchPurchases(
          String buyerId) async =>
      await _db.fetchPurchases(buyerId);


  Future<Resource<List<QueryDocumentSnapshot<Purchase>>>> fetchMorePurchases(
          QueryDocumentSnapshot<Purchase> lastPurchase, String buyerId) async =>
      await _db.fetchMorePurchases(lastPurchase, buyerId);
}
