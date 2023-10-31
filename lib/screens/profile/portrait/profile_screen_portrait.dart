import 'package:astroverse/components/name_plate.dart';
import 'package:astroverse/controllers/auth_controller.dart';
import 'package:astroverse/models/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class ProfileScreenPortrait extends StatelessWidget {
  final BoxConstraints cons;
  final User? user;
  const ProfileScreenPortrait({super.key, required this.cons, this.user});

  @override
  Widget build(BuildContext context) {
    final wd = cons.maxWidth;
    final ht = cons.maxHeight;
    final AuthController auth = Get.find();
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: SizedBox(
            width: wd,
            height: ht * 0.97,
            child: Column(
              children: [
                Obx(() {
                  if (auth.user.value != null) {
                    return NamePlate(
                      user: auth.user.value!,
                      onEdit: () {},
                      onLogOut: () {
                        auth.logOut();
                      },
                    );
                  } else {
                    return loadingShimmer(Center(
                      child: Container(
                        color: Colors.white,
                        width: wd,
                        height: ht * 0.95,
                      ),
                    ));
                  }
                })
              ],
            ),
          ),
        ),
      ),
    );
  }

  loadingShimmer(Widget child) {
    return Shimmer.fromColors(
        baseColor: Colors.grey.shade200,
        highlightColor: Colors.grey.shade400,
        child: child);
  }
}
