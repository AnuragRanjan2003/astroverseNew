import 'dart:developer';

import 'package:astroverse/models/save_service.dart';
import 'package:astroverse/models/service.dart';
import 'package:astroverse/utils/geo.dart';
import 'package:astroverse/utils/postable.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_geohash/dart_geohash.dart';

import '../res/strings/backend_strings.dart';

final _serviceCollection = FirebaseFirestore.instance
    .collection(BackEndStrings.serviceCollection)
    .withConverter<Service>(
      fromFirestore: (snapshot, options) => Service.fromJson(snapshot.data()),
      toFirestore: (item, options) => item.toJson(),
    );

CollectionReference<SaveService> _userServiceCollection(String uid) =>
    FirebaseFirestore.instance
        .collection(BackEndStrings.userCollection)
        .doc(uid)
        .collection(BackEndStrings.userServiceCollection)
        .withConverter<SaveService>(
          fromFirestore: (snapshot, options) =>
              SaveService.fromJson(snapshot.data()),
          toFirestore: (value, options) => value.toJson(),
        );

const _limit = 20;

class ServiceUtils extends Postable<Service, SaveService> {
  String uid;

  ServiceUtils(this.uid)
      : super(_serviceCollection, _userServiceCollection(uid));

  @override
  Future<Resource<int>> dislike(String id) async {
    try {
      await ref.doc(id).update({"upVotes": FieldValue.increment(-1)});
      await likeRef?.doc(id).delete();
      return Success(1);
    } on FirebaseException catch (e) {
      return Failure<int>(e.message.toString());
    } catch (e) {
      return Failure<int>(e.toString());
    }
  }

  @override
  Future<Resource<List<QueryDocumentSnapshot<Service>>>> fetchByGenreAndPage(
      List<String> genre, String uid) async {
    try {
      QuerySnapshot<Service> res = await ref
          .limit(_limit)
          .where("authorId", isNotEqualTo: uid)
          .orderBy("authorId")
          .orderBy("date", descending: true)
          .get();
      final data = res.docs;
      return Success(data);
    } on FirebaseException catch (e) {
      return Failure<List<QueryDocumentSnapshot<Service>>>(
          e.message.toString());
    } catch (e) {
      return Failure<List<QueryDocumentSnapshot<Service>>>(e.toString());
    }
  }

  Future<Resource<List<QueryDocumentSnapshot<Service>>>> fetchByLocation(
      String uid, GeoPoint userLocation) async {
    try {
      final List<QueryDocumentSnapshot<Service>> data = [];

      Query<Service> queryLocality = Geo()
          .createGeoQuery(ref, Ranges.localityRadius, userLocation)
          .where("range", isEqualTo: Ranges.locality)
          .orderBy("geoHash")
          .orderBy("date", descending: true)
          .limit(_limit);

      Query<Service> queryCity = Geo()
          .createGeoQuery(ref, Ranges.cityRadius, userLocation)
          .where("range", isEqualTo: Ranges.city)
          .orderBy("geoHash")
          .orderBy("date", descending: true)
          .limit(_limit);

      Query<Service> queryState = Geo()
          .createGeoQuery(ref, Ranges.stateRadius, userLocation)
          .where("range", isEqualTo: Ranges.state)
          .orderBy("geoHash")
          .orderBy("data", descending: true)
          .limit(_limit);

      Query<Service> queryAll = ref
          .where("range", isEqualTo: Ranges.all)
          .orderBy("geoHash")
          .orderBy("data", descending: true)
          .limit(_limit);

      Query<Service> queryFeatured = ref
          .where("featured", isEqualTo: true)
          .orderBy("geoHash")
          .orderBy("data", descending: true)
          .limit(_limit);

      final res = await Future.wait([
        queryLocality.get(),
        queryCity.get(),
        queryState.get(),
        queryAll.get(),
        queryFeatured.get(),
      ]);

      data.addIfNotUser(uid, res[0].docs);
      data.addIfNotUser(uid, res[1].docs);
      data.addIfNotUser(uid, res[2].docs);
      data.addIfNotUser(uid, res[3].docs);
      data.addIfNotUser(uid, res[4].docs);
      return Success(data);
    } on FirebaseException catch (e) {
      return Failure<List<QueryDocumentSnapshot<Service>>>(
          e.message.toString());
    } catch (e) {
      return Failure<List<QueryDocumentSnapshot<Service>>>(e.toString());
    }
  }

  Future<Resource<List<QueryDocumentSnapshot<Service>>>> fetchMoreByLocation(
      QueryDocumentSnapshot<Service>? lastPostForLocality,
      QueryDocumentSnapshot<Service>? lastPostForCity,
      QueryDocumentSnapshot<Service>? lastPostForState,
      QueryDocumentSnapshot<Service>? lastPostForAll,
      QueryDocumentSnapshot<Service>? lastPostForFeatured,
      GeoPoint userLocation,
      String uid) async {
    try {
      final List<QueryDocumentSnapshot<Service>> data = [];

      Query<Service> queryLocality = Geo()
          .createGeoQuery(ref, Ranges.localityRadius, userLocation)
          .where("range", isEqualTo: Ranges.locality)
          .orderBy("geoHash")
          .orderBy("date", descending: true)
          .limit(_limit);

      Query<Service> queryCity = Geo()
          .createGeoQuery(ref, Ranges.cityRadius, userLocation)
          .where("range", isEqualTo: Ranges.city)
          .orderBy("geoHash")
          .orderBy("date", descending: true)
          .limit(_limit);

      Query<Service> queryState = Geo()
          .createGeoQuery(ref, Ranges.stateRadius, userLocation)
          .where("range", isEqualTo: Ranges.state)
          .orderBy("geoHash")
          .orderBy("data", descending: true)
          .limit(_limit);

      Query<Service> queryAll = ref
          .where("range", isEqualTo: Ranges.state)
          .orderBy("geoHash")
          .orderBy("data", descending: true)
          .limit(_limit);

      Query<Service> queryFeatured = ref
          .where("featured", isEqualTo: true)
          .orderBy("geoHash")
          .orderBy("data", descending: true)
          .limit(_limit);

      if (lastPostForLocality != null) {
        queryLocality = queryLocality.startAfterDocument(lastPostForLocality);
      }

      if (lastPostForCity != null) {
        queryCity = queryCity..startAfterDocument(lastPostForCity);
      }

      if (lastPostForState != null) {
        queryState = queryState.startAfterDocument(lastPostForState);
      }

      if (lastPostForAll != null) {
        queryAll = queryCity.startAfterDocument(lastPostForAll);
      }
      if (lastPostForFeatured != null) {
        queryFeatured = queryFeatured.startAfterDocument(lastPostForFeatured);
      }
      final res = await Future.wait([
        queryLocality.get(),
        queryCity.get(),
        queryState.get(),
        queryAll.get(),
        queryFeatured.get()
      ]);

      data.addOthersPost(uid, res[0].docs);
      data.addOthersPost(uid, res[1].docs);
      data.addOthersPost(uid, res[2].docs);
      data.addOthersPost(uid, res[3].docs);
      data.addOthersPost(uid, res[4].docs);

      return Success(data);
    } on FirebaseException catch (e) {
      return Failure<List<QueryDocumentSnapshot<Service>>>(
          e.message.toString());
    } catch (e) {
      return Failure<List<QueryDocumentSnapshot<Service>>>(e.toString());
    }
  }

  @override
  Future<Resource<int>> like(String id) async {
    try {
      await ref.doc(id).update({"upVotes": FieldValue.increment(1)});
      //await likeRef?.doc(id).set(SaveService(id, DateTime.now().toString(),));
      return Success(1);
    } on FirebaseException catch (e) {
      return Failure<int>(e.message.toString());
    } catch (e) {
      return Failure<int>(e.toString());
    }
  }

  @override
  Future<Resource<List<QueryDocumentSnapshot<Service>>>> fetchMore(
      QueryDocumentSnapshot<Service> lastPost,
      List<String> genre,
      String uid) async {
    try {
      final res = await ref
          .limit(_limit)
          .where("authorId", isNotEqualTo: uid)
          .orderBy("authorId")
          .orderBy("date", descending: true)
          .startAfterDocument(lastPost)
          .get();
      return Success(res.docs);
    } on FirebaseException catch (e) {
      return Failure<List<QueryDocumentSnapshot<Service>>>(
          e.message.toString());
    } catch (e) {
      return Failure<List<QueryDocumentSnapshot<Service>>>(e.toString());
    }
  }

  @override
  Stream<QuerySnapshot<SaveService>> likedStream(String uid) =>
      likeRef!.snapshots();

  Future<Resource<Service>> fetchService(String serviceId) async {
    try {
      final res = await ref.doc(serviceId).get();
      if (res.exists && res.data() != null) {
        log("service : ${res.data()}");
        return Success<Service>(res.data()!);
      } else {
        return Failure<Service>(Errors.docNotFound);
      }
    } on FirebaseException catch (e) {
      return Failure<Service>(e.message.toString());
    } catch (e) {
      return Failure<Service>(e.toString());
    }
  }

  @override
  Future<Resource<Service>> savePost(Service post) async {
    final point = GeoHasher().encode(post.lng, post.lat);
    post.geoHash = point;
    try {
      final batch = FirebaseFirestore.instance.batch();
      batch.set(ref.doc(post.id), post);
      final savePost =
          SaveService(post.id, post.date.toIso8601String(), post.title);

      batch.set(_userServiceCollection(uid).doc(post.id), savePost);

      await batch.commit();

      return Success(post);
    } on FirebaseException catch (e) {
      return Failure<Service>(e.message.toString());
    } catch (e) {
      return Failure<Service>(e.toString());
    }
  }

  Future<Resource<Service>> savePostWithCoinCost(
      Service post, int coinCost) async {
    final point = GeoHasher().encode(post.lng, post.lat);
    post.geoHash = point;
    try {
      final DocumentReference<Map<String, dynamic>> userDocument =
          FirebaseFirestore.instance
              .collection(BackEndStrings.userCollection)
              .doc(post.authorId);
      final batch = FirebaseFirestore.instance.batch();

      final savePost =
          SaveService(post.id, post.date.toIso8601String(), post.title);

      batch.set(ref.doc(post.id), post);
      batch.set(_userServiceCollection(post.authorId).doc(post.id), savePost);
      batch.update(userDocument, {"coins": FieldValue.increment(-coinCost)});

      await batch.commit();
      return Success(post);
    } on FirebaseException catch (e) {
      return Failure<Service>(e.message.toString());
    } catch (e) {
      return Failure<Service>(e.toString());
    }
  }

  Future<Resource<String>> deleteService(SaveService ss) async {
    try {
      final batch = FirebaseFirestore.instance.batch();
      batch.delete(ref.doc(ss.id));
      batch.delete(_userServiceCollection(uid).doc(ss.id));
      batch.set(
          FirebaseFirestore.instance
              .collection(BackEndStrings.deletedCollection)
              .doc(ss.id),
          ss);
      await batch.commit();
      return Success("deleted");
    } on FirebaseException catch (e) {
      return Failure(e.message.toString());
    } catch (e) {
      return Failure(e.toString());
    }
  }

  Future<Resource<List<QueryDocumentSnapshot<SaveService>>>>
      fetchMyServices() async {
    try {
      final res = await likeRef!.orderBy("date", descending: true).get();
      return Success(res.docs);
    } on FirebaseException catch (e) {
      return Failure(e.message.toString());
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Resource<Json>> update(Json data, String id) async {
    try {
      await ref.doc(id).update(data);
      return Success<Json>(data);
    } on FirebaseException catch (e) {
      return Failure<Json>(e.message.toString());
    } catch (e) {
      return Failure<Json>(e.toString());
    }
  }
}

extension on List<QueryDocumentSnapshot<Service>> {
  addIfNotUser(String userId, Iterable<QueryDocumentSnapshot<Service>> itr) {
    for (var it in itr) {
      if (it.data().authorId != userId) add(it);
    }
  }
}

extension on List<QueryDocumentSnapshot<Service>> {
  addOthersPost(String userId, Iterable<QueryDocumentSnapshot<Service>> itr) {
    for (var it in itr) {
      if (it.data().authorId != userId) add(it);
    }
  }
}
