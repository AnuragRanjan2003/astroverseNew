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
    final double wd = cons.maxWidth;
    final double ht = cons.maxHeight;
    final AuthController auth = Get.find();
    final tabs = [
      GButton(
        icon: Icons.home_outlined,
        text: "Discover",
        iconColor: ProjectColors.onBackground,
        textStyle: TextStylesLight().coloredSmallThick(Colors.lightBlue),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      ),
      GButton(
        icon: Icons.shopping_cart_outlined,
        text: "Mart",
        iconColor: ProjectColors.onBackground,
        textStyle: TextStylesLight().coloredSmallThick(Colors.lightBlue),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      ),
      GButton(
        icon: Icons.home_outlined,
        text: "Home",
        iconColor: ProjectColors.onBackground,
        textStyle: TextStylesLight().coloredSmallThick(Colors.lightBlue),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      ),
    ];
    return Scaffold(
      backgroundColor: ProjectColors.background,
      extendBody: true,
      appBar: AppBar(
        leadingWidth: 40,
        backgroundColor: Colors.lightBlue.withAlpha(40),
        leading: GestureDetector(
          onTap: (){ debugPrint("profile");},
          child: Obx(() => Image(
                image: NetworkImage(auth.user.value!.image),
                width: 30,
                height: 30,
              )),
        ),
        title: Obx(() => Text(
              auth.user.value!.name,
              style: TextStylesLight().body,
            )),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: GNav(
          backgroundColor: ProjectColors.background.withAlpha(0),
          gap: 10,
          tabs: tabs,
          activeColor: Colors.lightBlue,
          tabBackgroundColor: Colors.lightBlue .withAlpha(70),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: wd,
            child: Column(
              children: [],
            ),
          ),
        ),
      ),
    );
  }
}
