// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      json['userName'] as String,
      json['userId'] as String,
      json['body'] as String,
      json['upVotes'] as int,
      json['downVotes'] as int,
      json['id'] as String,
      json['postId'] as String,
      json['astro'] as bool,
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'userName': instance.userName,
      'userId': instance.userId,
      'body': instance.body,
      'upVotes': instance.upVotes,
      'downVotes': instance.downVotes,
      'id': instance.id,
      'postId': instance.postId,
      'astro': instance.astro,
    };
