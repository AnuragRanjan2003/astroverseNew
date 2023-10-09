import 'package:astroverse/controllers/service_controller.dart';
import 'package:astroverse/screens/mart_screen/landscape/mart_screen_landscape.dart';
import 'package:astroverse/screens/mart_screen/portrait/mart_screen_portrait.dart';
import 'package:astroverse/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MartScreen extends StatelessWidget {
  const MartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ServiceController());
    return Responsive(
      portrait: (cons) => MartScreenPortrait(cons: cons),
      landscape: (cons) => MartScreenLandscape(cons: cons),
    );
  }
}
