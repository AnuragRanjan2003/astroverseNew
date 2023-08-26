import 'package:astroverse/screens/otpScreen/landscape/otp_screen_landscape.dart';
import 'package:astroverse/screens/otpScreen/portrait/otp_screen_portrait.dart';
import 'package:astroverse/utils/responsive.dart';
import 'package:flutter/material.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive(
      portrait: (p0) => OtpScreenPortrait(cons: p0),
      landscape: (p0) => OtpScreenLandscape(cons: p0),
    );
  }
}
