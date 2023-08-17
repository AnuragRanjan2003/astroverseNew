// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) => Item(
      json['title'] as String,
      json['userID'] as String,
      json['userName'] as String,
      (json['price'] as num).toDouble(),
      json['lat'] as String,
      json['long'] as String,
      json['address'] as String,
      json['id'] as String,
      DateTime.parse(json['date'] as String),
      json['uses'] as String,
      (json['category'] as List<dynamic>).map((e) => e as String).toList(),
      json['disc'] as String,
      json['imageURL'] as String,
      json['type'] as int,
    );

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'title': instance.title,
      'disc': instance.disc,
      'userID': instance.userID,
      'userName': instance.userName,
      'price': instance.price,
      'lat': instance.lat,
      'long': instance.long,
      'category': instance.category,
      'address': instance.address,
      'id': instance.id,
      'date': instance.date.toIso8601String(),
      'uses': instance.uses,
      'type': instance.type,
      'imageURL': instance.imageURL,
    };
