import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/user.dart';

class AstroSelectPlanPortrait extends StatelessWidget {
  final BoxConstraints cons;
  const AstroSelectPlanPortrait({super.key, required this.cons});

  @override
  Widget build(BuildContext context) {
    final User? user = Get.arguments;
    debugPrint(user.toString());
    return const Placeholder();
  }
}