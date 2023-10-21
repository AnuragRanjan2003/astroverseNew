import 'package:json_annotation/json_annotation.dart';

part 'save_comment.g.dart';

@JsonSerializable()
class SaveComment {
  final String id;

  final String date;

  SaveComment({required this.id, required this.date});

  Map<String, dynamic> toJson() => _$SaveCommentToJson(this);

  factory SaveComment.fromJson(json) => _$SaveCommentFromJson(json);
}
