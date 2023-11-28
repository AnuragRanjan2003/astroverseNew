import 'package:astroverse/models/save_service.dart';
import 'package:astroverse/models/service.dart';
import 'package:astroverse/utils/crypt.dart';
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

CollectionReference<SaveService> _usedServiceCollection(String uid) =>
    FirebaseFirestore.instance
        .collection(BackEndStrings.userCollection)
        .doc(uid)
        .collection(BackEndStrings.usedServiceCollection)
        .withConverter<SaveService>(
          fromFirestore: (snapshot, options) =>
              SaveService.fromJson(snapshot.data()),
          toFirestore: (value, options) => value.toJson(),
        );

const _limit = 20;

class ServiceUtils extends Postable<Service, SaveService> {
  String uid;

  ServiceUtils(this.uid)
      : super(_serviceCollection, _usedServiceCollection(uid));

  final _crypto = Crypt();

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
      final List<QueryDocumentSnapshot<Service>> data = [];
      final res1 = await queryLocality.get();
      final res2 = await queryCity.get();
      data.addIfNotUser(uid, res1.docs);
      data.addIfNotUser(uid, res2.docs);
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
      GeoPoint userLocation,
      String uid) async {
    try {
      final List<QueryDocumentSnapshot<Service>> data = [];
      if (lastPostForLocality != null) {
        Query<Service> queryLocality = Geo()
            .createGeoQuery(ref, Ranges.localityRadius, userLocation)
            .where("range", isEqualTo: Ranges.locality)
            .orderBy("geoHash")
            .orderBy("date", descending: true)
            .startAfterDocument(lastPostForLocality)
            .limit(_limit);
        final res1 = await queryLocality.get();
        data.addIfNotUser(uid, res1.docs);
      }
      if (lastPostForCity != null) {
        Query<Service> queryCity = Geo()
            .createGeoQuery(ref, Ranges.cityRadius, userLocation)
            .where("range", isEqualTo: Ranges.city)
            .orderBy("geoHash")
            .orderBy("date", descending: true)
            .startAfterDocument(lastPostForCity)
            .limit(_limit);
        final res2 = await queryCity.get();
        data.addIfNotUser(uid, res2.docs);
      }
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
      await likeRef?.doc(id).set(SaveService(id, DateTime.now().toString()));
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
        return Success<Service>(res.data()!);
      } else {
        return Failure<Service>("null returned");
      }
    } on FirebaseException catch (e) {
      return Failure<Service>(e.message.toString());
    } catch (e) {
      return Failure<Service>(e.toString());
    }
  }

  @override
  Future<Resource<Service>> savePost(Service post) async {
    final point = GeoHasher().encode(post.lat, post.lng);
    post.geoHash = point;
    post.authorName = _crypto.encryptToBase64String(post.authorName);
    try {
      await ref.doc(post.id).set(post);
      return Success(post);
    } on FirebaseException catch (e) {
      return Failure<Service>(e.message.toString());
    } catch (e) {
      return Failure<Service>(e.toString());
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
