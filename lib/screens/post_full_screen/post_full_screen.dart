import 'package:astroverse/models/post.dart';
import 'package:astroverse/screens/post_full_screen/landscape/post_full_landscape.dart';
import 'package:astroverse/screens/post_full_screen/portrait/post_full_portrait.dart';
import 'package:astroverse/utils/responsive.dart';
import 'package:flutter/material.dart';

class PostFullScreen extends StatelessWidget {
  final Post post;
  const PostFullScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Responsive(
        portrait: (cons) => PostFullPortrait(cons: cons , post : post),
        landscape: (cons) => PostFullLandscape(cons: cons , post : post));
  }
}
