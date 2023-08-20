import 'package:astroverse/controllers/auth_controller.dart';
import 'package:astroverse/screens/profile/landscape/profile_screen_landscape.dart';
import 'package:astroverse/screens/profile/portrait/profile_screen_portrait.dart';
import 'package:astroverse/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());
    return Responsive(
        portrait: (cons) => ProfileScreenPortrait(cons: cons),
        landscape: (cons) => ProfileScreenLandscape(cons: cons));
  }
}
