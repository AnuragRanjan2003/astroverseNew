import 'dart:io';

import 'package:astroverse/db/db.dart';
import 'package:astroverse/db/storage.dart';
import 'package:astroverse/models/purchase.dart';
import 'package:astroverse/models/save_service.dart';
import 'package:astroverse/models/service.dart';
import 'package:astroverse/models/transaction.dart' as t;
import 'package:astroverse/models/user.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

typedef Json = Map<String, dynamic>;

class ServiceRepo {
  final _db = Database();
  final _storage = Storage();

  Future<Resource<Service>> saveService(
          Service post, String uid, int coinsCost) async =>
      await _db.saveService(post, uid, coinsCost);

  Future<Resource<Json>> updateService(
          Json data, String serviceId, String uid) async =>
      await _db.updateService(data, serviceId, uid);

  Future<Resource<String>> storeServiceImage(File file, String id) async =>
      await _storage.storeServiceImage(file, id);

  Future<Resource<List<QueryDocumentSnapshot<Service>>>>
      fetchPostsByGenreAndPage(List<String> genre, String uid) async =>
          await _db.fetchServiceByGenreAndPage(genre, uid);

  Future<Resource<List<QueryDocumentSnapshot<Service>>>> fetchMorePost(
          QueryDocumentSnapshot<Service> lastPost,
          List<String> genre,
          String uid) async =>
      await _db.fetchMoreService(lastPost, genre, uid);

  Future<Resource<int>> increaseVote(String id, String uid) async =>
      await _db.increaseServiceVote(uid, id);

  Future<Resource<int>> decreaseVote(String id, String uid) async =>
      await _db.decreaseServiceVote(uid, id);

  Stream<QuerySnapshot<SaveService>> upVotedPostStream(String uid) =>
      _db.upVotedServicesStream(uid);

  Future<Resource<void>> addTransaction(t.Transaction item) async =>
      await _db.addTransaction(item);

  Future<Resource<Purchase>> postPurchase(Purchase p) async =>
      await _db.postPurchase(p);

  Future<Resource<DocumentSnapshot<User>>> fetchProviderData(
          String providerUid) async =>
      await _db.getUserData(providerUid);

  Future<Resource<List<QueryDocumentSnapshot<Service>>>> fetchByLocation(
          String uid, GeoPoint userLocation) async =>
      await _db.fetchServiceByLocation(uid, userLocation);

  Future<Resource<Json>> giveUserCoins(int coins, String uid) =>
      _db.updateUser({"coins": FieldValue.increment(coins)}, uid);

  Future<Resource<Json>> deductCoinsFromUser(int coins, String uid) =>
      _db.updateUser({"coins": FieldValue.increment(-coins)}, uid);

  Future<Resource<List<QueryDocumentSnapshot<SaveService>>>> fetchMyServices(
          String uid) =>
      _db.fetchMyServices(uid);

  Future<Resource<Service>> fetchService(String serviceId) =>
      _db.fetchService('abc', serviceId);

  Future<Resource<String>> deleteService(SaveService ss ,String userId) => _db.deleteService(ss , userId);

  fetchMoreByLocation(
          String uid,
          GeoPoint userLocation,
          QueryDocumentSnapshot<Service>? lastPostForLocality,
          QueryDocumentSnapshot<Service>? lastPostForCity) =>
      _db.fetchMoreServicesByLocation(
          uid, userLocation, lastPostForLocality, lastPostForCity);
}
