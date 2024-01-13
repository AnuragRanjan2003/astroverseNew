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
    "Connect with your favourite Astrologers ",
    "Astrology, Locally Crafted",
    "Navigate the Stars, Wherever You Are",
    "Social Stars Align"
  ];
  static const onBoardingSubtitle = [
    "Explore a online marketplace where users and astrologers converge for insightful astrology services and products.",
    "Unleash the power of astrology in your community – discover local astrologers and products, fostering a sense of cosmic connection right where you are.",
    "Experience astrology tailored to your location, providing you with personalized insights and access to services within your social proximity.",
    " Join a community where social connections meet celestial wisdom, bridging the gap between astrology enthusiasts and local practitioners."
  ];
  static const onBoardingImages = [
    "lib/assets/svg/connect.svg",
    "lib/assets/svg/local.svg",
    "lib/assets/svg/stars.svg",
    "lib/assets/svg/social.svg"
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
