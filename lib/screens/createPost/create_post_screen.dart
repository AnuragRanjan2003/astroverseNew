import 'package:astroverse/screens/createPost/landscape/create-post_landscape.dart';
import 'package:astroverse/screens/createPost/portrait/create_post_portrait.dart';
import 'package:astroverse/utils/responsive.dart';
import 'package:flutter/material.dart';

class CreatePostScreen extends StatelessWidget {
  const CreatePostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive(
      portrait: (p0) => CreatePostPortrait(cons: p0),
      landscape: (p0) => CreatePostLandscape(cons: p0),
    );
  }
}
