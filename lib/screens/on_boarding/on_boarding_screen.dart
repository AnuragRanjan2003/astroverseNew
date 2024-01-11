import 'dart:developer';

import 'package:astroverse/res/colors/project_colors.dart';
import 'package:astroverse/screens/ask/ask_screen.dart';
import 'package:astroverse/screens/on_boarding/on_boarding_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  static const onBoardingTitle = [
    "Connect and Share",
    "Expert Connections at Your Fingertips",
    "Your Personal Marketplace",
    "Welcome Aboard!\nLet's Dive In"
  ];
  static const onBoardingSubtitle = [
    " Dive into the vibrant community of Astro-Sapphire.\nShare your thoughts, experiences, and creativity.",
    "Unlock a world of knowledge and guidance with Astro-Sapphire.\nConnect seamlessly with astrologers and mentors through calls and chats.",
    "Explore a curated marketplace within Astro-Sapphire where you can buy and sell unique merchandise.\nStart browsing, buying, and selling today!",
    "Whether you're here for social connections, expert advice, shopping, or all of the above, we're thrilled to have you."
  ];
  static const onBoardingImages = [
    "lib/assets/svg/social.svg",
    "lib/assets/svg/call.svg",
    "lib/assets/svg/shop.svg",
    "lib/assets/svg/get_started.svg"
  ];

  late int currentPage;
  late bool buttonActive;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    currentPage = 0;
    buttonActive = true;
    pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    pageController.dispose();
    buttonActive = true;
    currentPage = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "onboarding+fab",
        onPressed: buttonActive
            ? () async {
                if (currentPage < onBoardingTitle.length - 1) {
                  currentPage++;
                  pageController.animateToPage(currentPage,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease);
                } else {
                  log("DONE", name: "CURRENT PAGE");
                  _handleDone().then((value) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const AskScreen(),
                    ));
                  });
                  setState(() {
                    buttonActive = false;
                  });
                }
                log("$currentPage", name: "CURRENT PAGE");
              }
            : null,
        label: Row(
          children: [
            Text(
              currentPage == onBoardingTitle.length - 1 ? "Done" : "Next",
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(
              width: 8,
            ),
            currentPage == onBoardingTitle.length - 1
                ? const SizedBox.shrink()
                : const Icon(
                    Icons.arrow_forward_outlined,
                    color: Colors.white,
                    size: 18,
                  )
          ],
        ),
        backgroundColor: buttonActive?ProjectColors.primary:ProjectColors.disabled,
      ),
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: PageView.builder(
              onPageChanged: (e) {
                setState(() {
                  currentPage = e;
                });
              },
              controller: pageController,
              itemCount: onBoardingTitle.length,
              itemBuilder: (context, index) => OnBoardingPage(
                onBoardingImage: onBoardingImages[index],
                onBoardingTitle: onBoardingTitle[index],
                onBoardingSubtitle: onBoardingSubtitle[index],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 20,
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(onBoardingTitle.length,
                    (index) => indicatorDot(currentPage == index))),
          ),
        ],
      )),
    );
  }

  AnimatedContainer indicatorDot(bool isActive) {
    return AnimatedContainer(
      height: isActive ? 16 : 6,
      width: 6,
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: const BoxDecoration(
          color: ProjectColors.primary,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      duration: const Duration(
        milliseconds: 300,
      ),
    );
  }

  Future _handleDone() async {
    final pref = await SharedPreferences.getInstance();
    // TODO(change to false)
    return await pref.setBool("first_time", false);
  }
}
