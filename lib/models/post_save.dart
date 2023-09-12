import 'package:json_annotation/json_annotation.dart';

part 'post_save.g.dart';

@JsonSerializable()
class PostSave {
  String id;
  String date;

  PostSave(this.id, this.date);

  factory PostSave.fromJson(json) => _$PostSaveFromJson(json);

  Map<String, dynamic> toJson() => _$PostSaveToJson(this);

  @override
  String toString() {
    return 'PostSave( id : $id , date : $date )';
  }
}
