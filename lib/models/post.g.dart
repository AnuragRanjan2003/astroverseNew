// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post(
      id: json['id'] as String? ?? "",
      title: json['title'] as String,
      description: json['description'] as String,
      genre: (json['genre'] as List<dynamic>).map((e) => e as String).toList(),
      date: DateTime.parse(json['date'] as String),
      imageUrl: json['imageUrl'] as String,
      upVotes: json['upVotes'] as int,
      downVotes: json['downVotes'] as int,
      authorName: json['authorName'] as String,
      authorId: json['authorId'] as String,
    );

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'genre': instance.genre,
      'date': instance.date.toIso8601String(),
      'imageUrl': instance.imageUrl,
      'upVotes': instance.upVotes,
      'downVotes': instance.downVotes,
      'authorName': instance.authorName,
      'authorId': instance.authorId,
    };
