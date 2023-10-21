import 'package:json_annotation/json_annotation.dart';

part 'comment.g.dart';

@JsonSerializable()
class Comment {
  final String userName;
  final String userId;
  final String body;
  DateTime date;
  String id;
  final String postId;
  final bool astro;

  Comment(
    this.userName,
    this.userId,
    this.body,
    this.id,
    this.postId,
    this.astro,
    this.date,
  );

  Map<String, dynamic> toJson() => _$CommentToJson(this);

  factory Comment.fromJson(json) => _$CommentFromJson(json);

  @override
  String toString() {
    return 'Comment(userName : $userName , id : $id , body : $body , userId : $userId , postId : $postId , astro : $astro , date : $date )';
  }
}
