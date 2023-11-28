import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

@JsonSerializable(anyMap: true)
class Post {
  String id; // no need to provide id ,  will be automatically generated
  final String title;
  final String description;
  final List<String> genre;
  final DateTime date;
  String imageUrl;
  int upVotes;
  final double lat;
  final double lng;
  final int comments;
  final int views;
  String authorName;
  final String authorId;

  Post({
    required this.lat,
    required this.lng,
    this.id = "",
    required this.title,
    required this.description,
    required this.genre,
    @JsonKey(fromJson: _dateFromTimeStamp, toJson: _dateAsIs)
    required this.date,
    required this.imageUrl,
    this.upVotes = 0,
    this.comments = 0,
    this.views = 0,
    required this.authorName,
    required this.authorId,
  });

  Map<String, dynamic> toJson() => _$PostToJson(this);

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  @override
  String toString() {
    return "Post(id : $id ,title : $title ,descr: $description , genre : ${genre.toString()} , date : ${date.toString()} , image : $imageUrl , upVotes : $upVotes , comments : $comments , views : $views , author : $authorName , authorId : $authorId )";
  }
  static DateTime _dateFromTimeStamp(Timestamp timestamp) =>
      DateTime.parse(timestamp.toDate().toString());

  static DateTime _dateAsIs(DateTime dateTime) => dateTime;

}
