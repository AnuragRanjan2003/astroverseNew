import 'package:astroverse/controllers/public_profile_controller.dart';
import 'package:astroverse/models/user.dart';
import 'package:astroverse/screens/public_profile/landscape/public_profile_landscape.dart';
import 'package:astroverse/screens/public_profile/portrait/public_profile_portrait.dart';
import 'package:astroverse/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PublicProfileScreen extends StatelessWidget {
  final User user;
  const PublicProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PublicProfileController());
    return Responsive(
      portrait: (p0) => PublicProfilePortrait(cons: p0 , user: user),
      landscape: (p0) => PublicProfileLandscape(cons: p0 , user : user),
    );
  }
}
