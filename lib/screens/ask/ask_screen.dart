import 'package:astroverse/screens/ask/landscape/ask_screen_landscape.dart';
import 'package:astroverse/screens/ask/portrait/ask_screen_portrait.dart';
import 'package:astroverse/utils/responsive.dart';
import 'package:flutter/material.dart';

class AskScreen extends StatelessWidget {
  const AskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive(
      portrait: (cons) => AskScreenPortrait(cons: cons),
      landscape: (cons) => AskScreenLandScape(cons: cons),
    );
  }
}
