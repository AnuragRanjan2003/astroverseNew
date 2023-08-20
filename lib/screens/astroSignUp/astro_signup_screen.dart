import 'package:astroverse/screens/astroSignUp/landscape/astro_signup_landscape.dart';
import 'package:astroverse/screens/astroSignUp/portrait/astro_signup_portrait.dart';
import 'package:astroverse/utils/responsive.dart';
import 'package:flutter/material.dart';

class AstroSignUpScreen extends StatelessWidget {
  const AstroSignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive(
        portrait: (cons) => AstroSignUpPortrait(cons: cons),
        landscape: (cons) => AstroSignUpLandscape(cons: cons));
  }
}
