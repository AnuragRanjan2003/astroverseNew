import 'package:astroverse/components/home_bar.dart';
import 'package:astroverse/controllers/auth_controller.dart';
import 'package:astroverse/res/colors/project_colors.dart';
import 'package:astroverse/res/dims/global.dart';
import 'package:astroverse/res/textStyles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MainScreenPortrait extends StatelessWidget {
  final BoxConstraints cons;

  const MainScreenPortrait({super.key, required this.cons});

  @override
  Widget build(BuildContext context) {
    final AuthController auth = Get.find();
    int selected = 0;
    const tabs = [
      GButton(
        icon: Icons.home_outlined,
      ),
      GButton(icon: Icons.home_outlined),
      GButton(icon: Icons.home_outlined),
    ];
    final double wd = cons.maxWidth;
    const padding = EdgeInsets.only(
        left: GlobalDims.horizontalPadding,
        right: GlobalDims.horizontalPadding,
        top: 5,
        bottom: 5);
    return Scaffold(
      backgroundColor: ProjectColors.background,
      bottomNavigationBar: GNav(
        tabs: tabs,
        selectedIndex: selected,
        onTabChange: (e) {
          selected = e;
          debugPrint("$e");
        },
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: wd,
            child: Column(
              children: [
                Obx(() => HomeBar(
                    user: auth.user.value,
                    padding: padding,
                    color: ProjectColors.background,
                    style: TextStylesLight().body)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
