import 'package:astroverse/screens/purchasesScreen/landscape/purchases_landscape.dart';
import 'package:astroverse/screens/purchasesScreen/portrait/purchases_portrait.dart';
import 'package:astroverse/utils/responsive.dart';
import 'package:flutter/material.dart';

class PurchasesScreen extends StatelessWidget {
  const PurchasesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive(
      portrait: (p0) => PurchasesPortrait(cons: p0),
      landscape: (p0) => PurchasesLandscape(cons: p0),
    );
  }
}
