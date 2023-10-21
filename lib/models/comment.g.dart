// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      json['userName'] as String,
      json['userId'] as String,
      json['body'] as String,
      json['id'] as String,
      json['postId'] as String,
      json['astro'] as bool,
      DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'userName': instance.userName,
      'userId': instance.userId,
      'body': instance.body,
      'date': instance.date.toIso8601String(),
      'id': instance.id,
      'postId': instance.postId,
      'astro': instance.astro,
    };
