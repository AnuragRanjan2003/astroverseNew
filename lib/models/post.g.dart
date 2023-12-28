// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map json) => Post(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      id: json['id'] as String? ?? "",
      title: json['title'] as String,
      description: json['description'] as String,
      genre: (json['genre'] as List<dynamic>).map((e) => e as String).toList(),
      date: DateTime.parse(json['date'] as String),
      imageUrl: json['imageUrl'] as String,
      upVotes: json['upVotes'] as int? ?? 0,
      comments: json['comments'] as int? ?? 0,
      views: json['views'] as int? ?? 0,
      authorName: json['authorName'] as String,
      authorId: json['authorId'] as String,
      featured: json['featured'] as bool,
    );

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'genre': instance.genre,
      'date': instance.date.toIso8601String(),
      'imageUrl': instance.imageUrl,
      'upVotes': instance.upVotes,
      'lat': instance.lat,
      'lng': instance.lng,
      'comments': instance.comments,
      'views': instance.views,
      'authorName': instance.authorName,
      'authorId': instance.authorId,
      'featured': instance.featured,
    };
