import 'package:astroverse/screens/askLocationScreen/portrait/ask_location_screen.dart';
import 'package:astroverse/screens/astroSignUp/portrait/astro_signup_portrait.dart';
import 'package:flutter/material.dart';

import '../../utils/responsive.dart';

class AskLocationScreen extends StatelessWidget {
  final Parcel parcel;

  const AskLocationScreen({
    super.key,
    required this.parcel,
  });

  @override
  Widget build(BuildContext context) {
    return Responsive(
      portrait: (p0) => AskLocationPortrait(
        cons: p0,
        parcel: parcel,
      ),
      landscape: (p0) => AskLocationPortrait(
        cons: p0,
        parcel: parcel,
      ),
    );
  }
}
