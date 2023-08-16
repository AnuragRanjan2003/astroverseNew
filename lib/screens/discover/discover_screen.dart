import 'package:astroverse/screens/discover/landscape/discover_screen_landscape.dart';
import 'package:astroverse/screens/discover/portrait/discover_portrait_screen.dart';
import 'package:astroverse/utils/responsive.dart';
import 'package:flutter/material.dart';

class DiscoverScreen extends StatelessWidget {
  final Color color;
  const DiscoverScreen({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Responsive(
      portrait: (cons) => DiscoverScreenPortrait(cons: cons, color: color,),
      landscape: (cons) => DiscoverScreenLandscape(cons: cons),
    );
  }
}
