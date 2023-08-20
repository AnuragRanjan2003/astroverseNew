import 'package:astroverse/controllers/auth_controller.dart';
import 'package:astroverse/res/colors/project_colors.dart';
import 'package:astroverse/res/textStyles/text_styles.dart';
import 'package:astroverse/routes/routes.dart';
import 'package:astroverse/screens/mart_screen/mart_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shimmer/shimmer.dart';

import '../../discover/discover_screen.dart';

class MainScreenPortrait extends StatelessWidget {
  final BoxConstraints cons;

  const MainScreenPortrait({super.key, required this.cons});

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController(initialPage: 0);
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
      appBar: AppBar(
        leadingWidth: 50,
        backgroundColor: ProjectColors.background,
        leading: Obx(() {
          if (auth.userLoading.isFalse) {
            return profileImage(auth);
          } else {
            return loadingShimmer(profileImagePlaceholder());
          }
        }),
        title: Obx(() {
          if (auth.userLoading.isFalse) {
            return nameText(auth);
          } else {
            return loadingShimmer(nameTextPlaceHolder());
          }
        }),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        color: Colors.transparent,
        child: GNav(
          backgroundColor: Colors.transparent,
          gap: 10,
          onTabChange: (e) {
            pageController.animateToPage(e,
                duration: const Duration(milliseconds: 200),
                curve: Curves.linear);
          },
          tabs: tabs,
          activeColor: Colors.lightBlue,
          tabBackgroundColor: Colors.white,
        ),
      ),
      body: SafeArea(
        child: SizedBox(
            width: wd,
            height: ht * 0.9,
            child: PageView(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                DiscoverScreen(color: ProjectColors.background),
                MartScreen(),
                DiscoverScreen(
                  color: Colors.green,
                ),
              ],
            )),
      ),
    );
  }

  Text nameText(AuthController auth) {
    return Text(
      auth.user.value!.name,
      style: TextStylesLight().body,
    );
  }

  Container nameTextPlaceHolder() {
    return Container(
      decoration: const BoxDecoration(color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(20))),
      child: const Text(
        "             ",
      ),
    );
  }

  IconButton profileImage(AuthController auth) {
    return IconButton(
      iconSize: 40,
      icon: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: Image(
          image: NetworkImage(auth.user.value!.image),
          fit: BoxFit.fill,
        ),
      ),
      onPressed: () {
        Get.toNamed(Routes.profile);
      },
    );
  }

  IconButton profileImagePlaceholder() {
    return IconButton(
      iconSize: 40,
      icon: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          child: Container(
            color: Colors.white,
          )),
      onPressed: () {
        Get.toNamed(Routes.profile);
      },
    );
  }

  Widget loadingShimmer(Widget child) {
    return Shimmer.fromColors(
        baseColor: Colors.grey.shade200,
        highlightColor: Colors.grey.shade100,
        child: child);
  }
}
