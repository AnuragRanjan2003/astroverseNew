import 'package:astroverse/components/name_plate.dart';
import 'package:astroverse/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreenPortrait extends StatelessWidget {
  final BoxConstraints cons;
  const ProfileScreenPortrait({super.key, required this.cons});

  @override
  Widget build(BuildContext context) {
    final wd = cons.maxWidth;
    final ht = cons.maxHeight;
    final AuthController auth = Get.find();
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: wd,
            child: Column(
              children: [
                Obx(()=> NamePlate(user: auth.user.value!),)
              ],
            ),
          ),
        ),
      ),

    );
  }
}
