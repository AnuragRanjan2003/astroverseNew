import 'package:astroverse/controllers/phone_auth_controller.dart';
import 'package:astroverse/screens/phoneAuth/landscape/phone_auth_landscape.dart';
import 'package:astroverse/screens/phoneAuth/portrait/phone_auth_portrait.dart';
import 'package:astroverse/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhoneAuthScreen extends StatelessWidget {
  const PhoneAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => PhoneAuthController());
    return Responsive(
      portrait: (p0) => PhoneAuthPortrait(cons: p0),
      landscape: (p0) => PhoneAuthLandscape(cons: p0),
    );
  }
}
