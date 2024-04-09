import 'package:astroverse/db/db.dart';
import 'package:astroverse/models/user.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AstrologerRepo {
  final _db = Database();

  Future<Resource<List<QueryDocumentSnapshot<User>>>> fetchAstrologer(
          GeoPoint geoPoint, String currentUid) async =>
      await _db.fetchAstrologers(currentUid, geoPoint);

  Future<Resource<List<QueryDocumentSnapshot<User>>>> fetchMoreAstrologers(
          QueryDocumentSnapshot<User> last, String currentUid) async =>
      await _db.fetchMoreAstrologers(last, currentUid);

  Future<Resource<List<QueryDocumentSnapshot<User>>>>
      fetchAstrologersByLocation(String currentUid, GeoPoint userLocation) =>
          _db.fetchAstrologersByLocation(currentUid, userLocation);

  Future<Resource<List<QueryDocumentSnapshot<User>>>>
      fetchMoreAstrologersByLocation(
    String currentUid,
    GeoPoint userLocation,
    QueryDocumentSnapshot<User>? lastForLocality,
    QueryDocumentSnapshot<User>? lastForCity,
    QueryDocumentSnapshot<User>? lastForState,
    QueryDocumentSnapshot<User>? lastForAll,
    QueryDocumentSnapshot<User>? lastForFeatured,
  ) =>
          _db.fetchMoreAstrologersByLocation(
            lastForLocality,
            lastForCity,
            lastForState,
            lastForAll,
            lastForFeatured,
            currentUid,
            userLocation,
          );
}
