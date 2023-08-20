import 'package:astroverse/screens/astroLogIn/landscape/astro_login_landscape.dart';
import 'package:astroverse/screens/astroLogIn/portrait/astro_login_portrait.dart';

import 'package:astroverse/utils/responsive.dart';
import 'package:flutter/material.dart';

class AstroLogInScreen extends StatelessWidget {
  const AstroLogInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive(
        portrait: (cons) => AstroLogInPortrait(cons: cons),
        landscape: (cons) => AstroLogInLandscape(cons: cons));
  }
}
