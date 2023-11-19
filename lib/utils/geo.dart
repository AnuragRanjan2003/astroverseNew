import 'dart:developer' as d;
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_geohash/dart_geohash.dart';
import 'package:location/location.dart';

class Geo {
  final _geoHasher = GeoHasher();

  String getHash(GeoPoint point) {
    return _geoHasher.encode(point.latitude, point.longitude);
  }

  GeoPoint getGeoPoint(String geoHash) {
    final res = _geoHasher.decode(geoHash);
    return GeoPoint(res[0], res[1]);
  }

  GeoRange computeBoundingHashes(GeoPoint center, double radius) {
    final dev = 180 * radius * cos(center.latitude * pi / 180) / (pi * 6400000);

    final large = GeoPoint(center.latitude + (dev), center.longitude + (dev));
    final small = GeoPoint(center.latitude - (dev), center.longitude - (dev));
    return GeoRange(larger: getHash(large), smaller: getHash(small));
  }

  Query<T> createGeoQuery<T>(
      CollectionReference<T> reference, double radius, GeoPoint centre) {
    GeoRange bounds = computeBoundingHashes(centre, radius);
    d.log(' bounds : larger : ${bounds.larger} smaller: ${bounds.smaller}',
        name: "BOUNDS");
    return reference
        .where("geoHash", isGreaterThanOrEqualTo: bounds.smaller)
        .where("geoHash", isLessThanOrEqualTo: bounds.larger);
  }
}

class Ranges {
  static const locality = 0;
  static const localityRadius = 5000.00; // in meters
  static const city = 1;
  static const cityRadius = 20000.00;
  static const all = 2;

}

class VisibilityPlans{
  static const locality = 0;
  static const localityRadius = 5000.00; // in meters
  static const city = 1;
  static const cityRadius = 20000.00;
  static const all = 2;
}

class GeoRange {
  final String smaller;
  final String larger;

  GeoRange({required this.smaller, required this.larger});
}

extension on LocationData {
  GeoPoint? geoPointFromLocationData() {
    if (latitude == null || longitude == null) return null;
    return GeoPoint(latitude!, longitude!);
  }
}
