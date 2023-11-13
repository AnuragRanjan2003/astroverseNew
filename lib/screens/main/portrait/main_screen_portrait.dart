import 'dart:ui';

import 'package:astroverse/components/glass_morph_container.dart';
import 'package:astroverse/controllers/auth_controller.dart';
import 'package:astroverse/res/colors/project_colors.dart';
import 'package:astroverse/res/textStyles/text_styles.dart';
import 'package:astroverse/routes/routes.dart';
import 'package:astroverse/screens/mart_screen/mart_screen.dart';
import 'package:astroverse/screens/peopleScreen/portrait/people_screen_portrait.dart';
import 'package:astroverse/screens/profile/profile_screen.dart';
import 'package:astroverse/screens/purchasesScreen/purchases_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shimmer/shimmer.dart';

import '../../discover/discover_screen.dart';

class MainScreenPortrait extends StatelessWidget {
  final BoxConstraints cons;

  const MainScreenPortrait({super.key, required this.cons});

  @override
  Widget build(BuildContext context) {
    var observer =
    FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance);
    final PageController pageController = PageController(initialPage: 0);
    final double wd = cons.maxWidth;
    final double ht = cons.maxHeight;

    final AuthController auth = Get.find();

    final tabs = [
      const GButton(
        icon: FontAwesomeIcons.message,
        iconSize: 20,
        iconColor: ProjectColors.onBackground,
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      ),
      const GButton(
        icon: Icons.shopping_bag_outlined,
        iconColor: ProjectColors.onBackground,
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      ),
      const GButton(
        icon: Icons.person_outline,
        iconColor: ProjectColors.onBackground,
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      ),
      const GButton(
        icon: Icons.people_outline,
        iconColor: ProjectColors.onBackground,
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      ),
      const GButton(
        icon: Icons.shopping_cart_outlined,
        iconColor: ProjectColors.onBackground,
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      ),
    ];

    return Scaffold(
      backgroundColor: ProjectColors.background,
      body: SafeArea(
        child: SizedBox(
            width: wd,
            child: Stack(children: [
              PageView(
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  const DiscoverScreen(),
                  const MartScreen(),
                  const ProfileScreen(),
                  PeopleScreenPortrait(cons: cons),
                  const PurchasesScreen()
                ],
              ),
              Align(alignment:Alignment.bottomCenter,child: buildBottomNav(pageController, auth, tabs))
            ])),
      ),
    );
  }

  Widget buildBottomNav(PageController pageController, AuthController auth, List<GButton> tabs) {
    return GlassMorphContainer(borderRadius: 20, blur: 5, opacity: 0.5,margin: const EdgeInsets.only(left: 12, right: 12, bottom: 20), child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: GNav(
        backgroundColor: Colors.transparent,
        gap: 10,
        onTabChange: (e) {
          pageController.animateToPage(e,
              duration: const Duration(milliseconds: 200),
              curve: Curves.linear);
          auth.page.value = e;
        },
        tabs: tabs,
        activeColor: Colors.lightBlue,
        tabBackgroundColor: Colors.transparent,
      ),
    ),);
  }

  Text nameText(AuthController auth) {
    return Text(
      auth.user.value!.name,
      style: TextStylesLight().body,
    );
  }

  Container nameTextPlaceHolder() {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: const Text(
        "             ",
      ),
    );
  }

  profileImage(AuthController auth) {
    return GestureDetector(
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: Image(
          image: NetworkImage(auth.user.value!.image),
          fit: BoxFit.fill,
        ),
      ),
      onTap: () {
        Get.toNamed(
          Routes.profile,
          arguments: auth.user.value!,
        );
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
        // Get.toNamed(Routes.profile);
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