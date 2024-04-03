// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map json) => User(
      json['name'] as String,
      json['email'] as String,
      json['image'] as String,
      json['plan'] as int,
      json['activated'] == null ? false : json['activated'] as bool,
      json['uid'] as String,
      json['astro'] as bool,
      json['phNo'] as String,
      json['geoHash'] as String,
      json["qualifications"] != null ? json["qualifications"] as String : "",
      json["postedToday"] != null ? (json["postedToday"] as num).toInt() : 0,
      json["lastPosted"] != null
          ? (json["lastPosted"] as Timestamp).toDate()
          : DateTime.now(),
      json["servicesPostedToday"] != null
          ? (json["servicesPostedToday"] as num).toInt()
          : 0,
      json["lastServicePosted"] != null
          ? (json["lastServicePosted"] as Timestamp).toDate()
          : DateTime.now(),
      json['featured'] as bool,
      location: User._fromJsonGeoPoint(json['location'] as GeoPoint?),
      coins: json['coins'] as int? ?? 0,
      profileViews: json['profileViews'] as int? ?? 0,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'image': instance.image,
      'activated': instance.activated,
      'uid': instance.uid,
      'plan': instance.plan,
      'geoHash': instance.geoHash,
      'astro': instance.astro,
      'location': User._toJsonGeoPoint(instance.location),
      'points': instance.coins,
      'profileViews': instance.profileViews,
      'phNo': instance.phNo,
      'coins': instance.coins,
      "qualifications": instance.qualifications,
      'featured': instance.featured,
      "lastPosted": instance.lastPosted,
      "lastServicePosted": instance.lastServicePosted,
      "postedToday": instance.postedToday,
      "servicesPostedToday": instance.servicesPostedToday,
    };
