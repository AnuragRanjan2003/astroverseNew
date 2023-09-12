import 'package:astroverse/res/colors/project_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controller.dart';

class MartScreenPortrait extends StatelessWidget {
  final BoxConstraints cons;

  const MartScreenPortrait({super.key, required this.cons});

  @override
  Widget build(BuildContext context) {
    final AuthController auth = Get.find();
    return Scaffold(
      backgroundColor: ProjectColors.background,
      floatingActionButton: (auth.user.value?.astro == true)
          ? FloatingActionButton(
              onPressed: _postItemScreen,
              backgroundColor: Colors.lightBlue.shade300,
              elevation: 0,
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            )
          : null,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
              child: const Column(
            children: [],
          )),
        ),
      ),
    );
  }

  _postItemScreen() {
    debugPrint("add item");
    return;
    // TODO(go to add item screen)
    //Get.toNamed();
  }
}
