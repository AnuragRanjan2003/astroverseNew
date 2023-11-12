// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Service _$ServiceFromJson(Map json) => Service(
      price: (json['price'] as num).toDouble(),
      uses: json['uses'] as int,
      lastDate: json['lastDate'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      title: json['title'] as String,
      description: json['description'] as String,
      genre: (json['genre'] as List<dynamic>).map((e) => e as String).toList(),
      date: DateTime.parse(json['date'] as String),
      imageUrl: json['imageUrl'] as String,
      authorName: json['authorName'] as String,
      authorId: json['authorId'] as String,
      place: json['place'] as String,
    )
      ..id = json['id'] as String
      ..upVotes = json['upVotes'] as int;

Map<String, dynamic> _$ServiceToJson(Service instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'genre': instance.genre,
      'date': instance.date.toIso8601String(),
      'imageUrl': instance.imageUrl,
      'upVotes': instance.upVotes,
      'lat': instance.lat,
      'lng': instance.lng,
      'authorName': instance.authorName,
      'authorId': instance.authorId,
      'price': instance.price,
      'uses': instance.uses,
      'place': instance.place,
      'lastDate': instance.lastDate,
    };
