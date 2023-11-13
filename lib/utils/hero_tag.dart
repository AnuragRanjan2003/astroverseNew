import 'dart:core';

import 'package:astroverse/models/post.dart';
import 'package:astroverse/models/user.dart';

class HeroTag {
  static const IMAGE  = 'image';
  static String forPost(Post post, String field) => '$field+${post.id}';
  static String forAstro(User astro, String field) => '$field+${astro.uid}';
}

class PostFields {
  static const image = "image";
  static const description = "description";
  static const dataBar = "dataBar";
  static const userBar = "userBar";
}

class Astro{
  static const image = "image";
}
