import 'package:astroverse/screens/post_full_screen/landscape/post_full_landscape.dart';
import 'package:astroverse/screens/purchaseFullScreen/portrait/purchase_full_portrait.dart';
import 'package:astroverse/utils/responsive.dart';
import 'package:flutter/material.dart';

class PurchaseFullScreen extends StatelessWidget {
  const PurchaseFullScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive(
      portrait: (p0) => PurchaseFullPortrait(cons: p0),
      landscape: (p0) => PostFullLandscape(cons: p0),
    );
  }
}
