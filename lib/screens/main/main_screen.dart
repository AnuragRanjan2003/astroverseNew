import 'package:astroverse/screens/main/landscape/main_screen_landscape.dart';
import 'package:astroverse/screens/main/portrait/main_screen_portrait.dart';
import 'package:astroverse/utils/responsive.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive(
        portrait: (cons) => MainScreenPortrait(cons: cons),
        landscape: (cons) => MainScreenLandscape(cons: cons));
  }
}
