import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String name;
  final String email;
  String image;
  String uid;
  int plan;

  User(this.name, this.email, this.image, this.plan, this.uid);

  factory User.fromJson(json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
