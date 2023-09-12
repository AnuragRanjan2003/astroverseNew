import 'package:json_annotation/json_annotation.dart';

part 'comment.g.dart';

@JsonSerializable()
class Comment {
  final String userName;
  final String userId;
  final String body;
  final int upVotes;
  final int downVotes;
  final String id;
  final String postId;
  final bool astro;

  Comment(this.userName, this.userId, this.body, this.upVotes, this.downVotes,
      this.id, this.postId, this.astro);

  Map<String, dynamic> toJson() => _$CommentToJson(this);

  factory Comment.fromJson(json) => _$CommentFromJson(json);

  @override
  String toString() {
    return 'Comment(userName : $userName , id : $id , body : $body , upVotes : $upVotes , downVotes : $downVotes , userId : $userId , postId : $postId , astro : $astro )';
  }
}
