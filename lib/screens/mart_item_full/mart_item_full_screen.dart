import 'package:astroverse/screens/mart_item_full/landscape/mart_item_full_landscape.dart';
import 'package:astroverse/screens/mart_item_full/portrait/mart_item_full_portrait.dart';
import 'package:astroverse/utils/responsive.dart';
import 'package:flutter/material.dart';

class MartItemFullScreen extends StatelessWidget {
  const MartItemFullScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive(
      portrait: (p0) => MartItemFullPortrait(cons: p0),
      landscape: (p0) => MartItemFullLandscape(cons: p0),
    );
  }
}
