import 'package:astroverse/controllers/auth_controller.dart';
import 'package:astroverse/models/user.dart';
import 'package:astroverse/res/colors/project_colors.dart';
import 'package:astroverse/res/textStyles/text_styles.dart';
import 'package:astroverse/routes/routes.dart';
import 'package:astroverse/screens/mart_screen/mart_screen.dart';
import 'package:astroverse/screens/peopleScreen/portrait/people_screen_portrait.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
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
    var observer =
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance);
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
        icon: Icons.people_outline,
        text: "Astrologers",
        iconColor: ProjectColors.onBackground,
        textStyle: TextStylesLight().coloredSmallThick(Colors.lightBlue),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      ),
    ];

    final receiver =
        User("abcde", '', '', 1, 'qR0IiDisDnPxziZhyZtPrNJPPfC3', false, '', '');

    return Scaffold(
      backgroundColor: ProjectColors.background,
      appBar: _customAppBar(auth, "Explore"),
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
            auth.page.value = e;
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
              children: [
                const DiscoverScreen(color: ProjectColors.background),
                const MartScreen(),
                PeopleScreenPortrait(cons: cons)
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
          Routes.publicProfile,
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

  _customAppBar(AuthController auth, String page) {
    return PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: Container(
            padding: const EdgeInsets.only(top: 35, right: 30, left: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      child: const Icon(
                        Icons.notifications,
                        color: Colors.black54,
                      ),
                      onTap: () {},
                    ),
                    GestureDetector(
                      child: CircleAvatar(
                        radius: 20,
                        child: Obx(() {
                          if (auth.user.value == null) {
                            return profileImagePlaceholder();
                          }
                          return profileImage(auth);
                        }),
                      ),
                      onTap: () {
                        //Get.toNamed(Routes.publicProfile);
                      },
                    )
                  ],
                ),
                Obx(() => Text(
                      _pageName(auth.page.value),
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold),
                    ))
              ],
            )));
  }

  String _pageName(int i) {
    if (i == 0) {
      return "Discover";
    } else if (i == 1) {
      return "Mart";
    }
    return "Astrologers";
  }

  Widget loadingShimmer(Widget child) {
    return Shimmer.fromColors(
        baseColor: Colors.grey.shade200,
        highlightColor: Colors.grey.shade100,
        child: child);
  }
}
