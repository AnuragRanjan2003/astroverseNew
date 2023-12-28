import 'package:astroverse/utils/crypt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(anyMap: true)
class User {
  String name;
  String email;
  String image;
  String uid;
  int plan;
  String geoHash;
  final bool astro;
  @JsonKey(fromJson: _fromJsonGeoPoint, toJson: _toJsonGeoPoint)
  GeoPoint? location;
  int coins;
  int profileViews;
  String phNo;
  bool featured;

  User(
    this.name,
    this.email,
    this.image,
    this.plan,
    this.uid,
    this.astro,
    this.phNo,
    this.geoHash,
    this.featured, {
    this.location,
    this.coins = 0,
    this.profileViews = 0,
  });

  factory User.fromJson(json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  static GeoPoint? _fromJsonGeoPoint(GeoPoint? geoPoint) {
    return geoPoint;
  }

  static _decrypt(String encoded) {
    return Crypt().decryptFromBase64String(encoded);
  }

  static GeoPoint? _toJsonGeoPoint(GeoPoint? geoPoint) {
    return geoPoint;
  }

  @override
  String toString() {
    return "User(name :$name , email :$email , image : $image ,uid : $uid ,plan: $plan ,astro: $astro ,phno: $phNo ,coins: $coins )";
  }
}
