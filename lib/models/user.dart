import 'package:firebase_auth/firebase_auth.dart' as fbase;
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String name;
  final String email;
  String image;
  String uid;
  int plan;
  final bool astro;
  String phNo;

  User(this.name, this.email, this.image, this.plan, this.uid, this.astro,
      this.phNo);

  factory User.fromJson(json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);


  @override
  String toString() {
    return "User($name , $email , $image , $uid , $plan , $astro , $phNo)";
  }
}
