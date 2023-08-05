import 'package:astroverse/screens/moreProfile/landscape/more_profile_landscape.dart';
import 'package:astroverse/screens/moreProfile/portrait/more_profile_portrait.dart';
import 'package:astroverse/utils/responsive.dart';
import 'package:flutter/material.dart';

class MoreProfileScreen extends StatelessWidget {
  const MoreProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive(
      portrait: (cons) => MoreProfilePortrait(cons: cons),
      landscape: (cons) => MoreProfileLandscape(cons: cons),
    );
  }
}
