import 'package:astroverse/screens/astroSelectPlan/landscape/astro_select_plan_landscape.dart';
import 'package:astroverse/screens/astroSelectPlan/portrait/astro_select_plan_portrait.dart';
import 'package:astroverse/utils/responsive.dart';
import 'package:flutter/material.dart';

class AstroSelectPlan extends StatelessWidget {
  const AstroSelectPlan({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive(
      portrait: (cons) => AstroSelectPlanPortrait(cons: cons),
      landscape: (cons) => AstroSelectPlanLandscape(cons: cons),
    );
  }
}
