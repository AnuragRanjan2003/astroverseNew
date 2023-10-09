import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

@JsonSerializable()
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
  final int downVotes;
  final String authorName;
  final String authorId;

  Post({
    required this.lat,
    required this.lng,
    this.id = "",
    required this.title,
    required this.description,
    required this.genre,
    required this.date,
    required this.imageUrl,
    this.upVotes = 0,
    this.downVotes = 0,
    required this.authorName,
    required this.authorId,
  });

  Map<String, dynamic> toJson() => _$PostToJson(this);

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  @override
  String toString() {
    return "Post(id : $id ,title : $title ,descr: $description , genre : ${genre.toString()} , date : ${date.toString()} , image : $imageUrl , upVotes : $upVotes , downVotes : $downVotes , author : $authorName , authorId : $authorId )";
  }
}
