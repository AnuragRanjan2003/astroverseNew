import 'dart:core';

import 'package:astroverse/models/post.dart';

class HeroTag {
  String forPost(Post post, String field) => '$field+${post.id}';
}

class PostFields {
  static const image = "image";
  static const description = "description";
  static const dataBar = "dataBar";
  static const userBar = "userBar";
}
