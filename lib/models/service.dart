import 'package:astroverse/models/post.dart';
import 'package:json_annotation/json_annotation.dart';

part 'service.g.dart';

@JsonSerializable()
class Service extends Post {
  double price;
  int uses;
  String place;
  DateTime lastDate;

  Service({
    required this.price,
    required this.uses,
    required this.lastDate,
    required super.lat,
    required super.lng,
    required super.title,
    required super.description,
    required super.genre,
    required super.date,
    required super.imageUrl,
    required super.authorName,
    required super.authorId,
    required this.place,
  });

  factory Service.fromJson(json) => _$ServiceFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ServiceToJson(this);

  @override
  String toString() {
    return "Service(id : $id ,title : $title ,descr: $description , genre : ${genre.toString()} , date : ${date.toString()} , image : $imageUrl , upVotes : $upVotes , comments : $comments , author : $authorName , authorId : $authorId )\n";
  }
}
