import 'package:astroverse/screens/profile/landscape/profile_screen_landscape.dart';
import 'package:astroverse/screens/profile/portrait/profile_screen_portrait.dart';
import 'package:astroverse/utils/responsive.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive(
        portrait: (cons) => ProfileScreenPortrait(cons: cons),
        landscape: (cons) => ProfileScreenLandscape(cons: cons));
  }
}
