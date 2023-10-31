import 'package:astroverse/screens/public_profile/landscape/public_profile_landscape.dart';
import 'package:astroverse/screens/public_profile/portrait/public_profile_portrait.dart';
import 'package:astroverse/utils/responsive.dart';
import 'package:flutter/material.dart';

class PublicProfileScreen extends StatelessWidget {
  const PublicProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive(
      portrait: (p0) => PublicProfilePortrait(cons: p0),
      landscape: (p0) => PublicProfileLandscape(cons: p0),
    );
  }
}
