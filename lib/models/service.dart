import 'package:astroverse/models/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_geohash/dart_geohash.dart';
import 'package:json_annotation/json_annotation.dart';

part 'service.g.dart';

//lastDate: Service._dateFromTimeStamp(json['lastDate'] as Timestamp),
// date: Service._dateFromTimeStamp(json['date'] as Timestamp),
//@JsonSerializable(anyMap: true)
class Service extends Post {
  double price;
  int uses;
  String place;
  DateTime lastDate;
  DateTime date;
  String geoHash;
  final int range;

  Service({
    required this.price,
    required this.uses,
    @JsonKey(fromJson: _dateFromTimeStamp, toJson: _dateAsIs)
    required this.lastDate,
    required super.lat,
    required super.lng,
    required super.title,
    required this.geoHash,
    required this.range,
    required super.description,
    required super.genre,
    @JsonKey(fromJson: _dateFromTimeStamp, toJson: _dateAsIs)
    required this.date,
    required super.imageUrl,
    required super.authorName,
    required super.authorId,
    required this.place,
  }) : super(date: date);

  factory Service.fromJson(json) => _$ServiceFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ServiceToJson(this);

  @override
  String toString() {
    return "Service(id : $id ,title : $title ,descr: $description , genre : ${genre.toString()} , date : ${date.toString()} , image : $imageUrl , upVotes : $upVotes , comments : $comments , author : $authorName , authorId : $authorId )\n";
  }

  static DateTime _dateFromTimeStamp(Timestamp timestamp) =>
      DateTime.parse(timestamp.toDate().toString());

  static DateTime _dateAsIs(DateTime dateTime) => dateTime;

  static String _genGeoHashNullSafe(double lat, double long , dynamic hash) {
    if(hash!=null) return hash as String;
    return GeoHasher().encode(lat, long);
  }
}
