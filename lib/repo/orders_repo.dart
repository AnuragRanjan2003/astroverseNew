import 'package:astroverse/db/db.dart';
import 'package:astroverse/models/purchase.dart';
import 'package:astroverse/models/service.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


typedef Json = Map<String,dynamic>;
class OrderRepo {
  final _db = Database();

  Future<Resource<Service>> fetchService(String uid, String serviceId) =>
      _db.fetchService(uid, serviceId);

  Stream<DocumentSnapshot<Purchase>> purchaseStream(
          String currentUid, String purchaseId) =>
      _db.purchaseStream(currentUid, purchaseId);

  Future<Resource<Json>> confirmDelivery(
          String orderId, String buyerId, String sellerId) =>
      _db.updatePurchase(
          {"deliveredOn": FieldValue.serverTimestamp(), "delivered": true},
          orderId,
          buyerId,
          sellerId);

  Future<Resource<Json>> cancelPurchase(String id, String buyerId , String sellerId) =>
      _db.cancelPurchase(id, buyerId , sellerId);
}
