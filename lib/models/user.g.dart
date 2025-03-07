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
      json['uid'] as String,
      json['astro'] as bool,
      json['phNo'] as String,
      json['geoHash'] as String,
      json['featured'] as bool,
      location: User._fromJsonGeoPoint(json['location'] as GeoPoint?),
      coins: json['coins'] as int? ?? 0,
      profileViews: json['profileViews'] as int? ?? 0,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'image': instance.image,
      'uid': instance.uid,
      'plan': instance.plan,
      'geoHash': instance.geoHash,
      'astro': instance.astro,
      'location': User._toJsonGeoPoint(instance.location),
      'points': instance.coins,
      'profileViews': instance.profileViews,
      'phNo': instance.phNo,
      'coins': instance.coins,
      'featured': instance.featured,
    };
