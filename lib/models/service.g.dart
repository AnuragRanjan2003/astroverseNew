// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Service _$ServiceFromJson(Map json) => Service(
      price: (json['price'] as num).toDouble(),
      uses: json['uses'] as int,
      lastDate: Service._dateFromTimeStamp(json['lastDate'] as Timestamp),
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      title: json['title'] as String,
      range: (json['range'] as num).toInt(),
      geoHash: json['geoHash'] as String,
      description: json['description'] as String,
      genre: (json['genre'] as List<dynamic>).map((e) => e as String).toList(),
      date: Service._dateFromTimeStamp(json['date'] as Timestamp),
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
      'imageUrl': instance.imageUrl,
      'upVotes': instance.upVotes,
      'lat': instance.lat,
      'lng': instance.lng,
      'authorName': instance.authorName,
      'authorId': instance.authorId,
      'price': instance.price,
      'uses': instance.uses,
      'place': instance.place,
      'lastDate': Service._dateAsIs(instance.lastDate),
      'date': Service._dateAsIs(instance.date),
      'geoHash': instance.geoHash,
      'range': instance.range,
    };
