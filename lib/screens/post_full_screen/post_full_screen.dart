import 'package:astroverse/screens/post_full_screen/landscape/post_full_landscape.dart';
import 'package:astroverse/screens/post_full_screen/portrait/post_full_portrait.dart';
import 'package:astroverse/utils/responsive.dart';
import 'package:flutter/material.dart';

class PostFullScreen extends StatelessWidget {
  const PostFullScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive(
        portrait: (cons) => PostFullPortrait(cons: cons),
        landscape: (cons) => PostFullLandscape(cons: cons));
  }
}
