import 'package:astroverse/screens/emailverfication/landscape/email_verification_landscape.dart';
import 'package:astroverse/screens/emailverfication/portrait/email_verification_portrait.dart';
import 'package:astroverse/utils/responsive.dart';
import 'package:flutter/material.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive(
        portrait: (cons) => EmailVerificationPortrait(cons: cons),
        landscape: (cons) => EmailVerificationLandscape(cons: cons));
  }
}
