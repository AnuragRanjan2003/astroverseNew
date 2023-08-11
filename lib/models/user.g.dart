// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      json['name'] as String,
      json['email'] as String,
      json['image'] as String,
      json['plan'] as int,
      json['uid'] as String,
      json['astro'] as bool,
      json['phNo'] as String,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'image': instance.image,
      'uid': instance.uid,
      'plan': instance.plan,
      'astro': instance.astro,
      'phNo': instance.phNo,
    };
