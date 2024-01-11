import 'package:astroverse/res/colors/project_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({
    super.key,
    required this.onBoardingImage,
    required this.onBoardingTitle,
    required this.onBoardingSubtitle,
  });

  final String onBoardingImage;
  final String onBoardingTitle;
  final String onBoardingSubtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Spacer(),
        SvgPicture.asset(
          onBoardingImage,
          height: 270,
        ),
        const Spacer(),
        Text(
          onBoardingTitle,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(fontWeight: FontWeight.w500 ,fontSize: 22),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            onBoardingSubtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12,color: ProjectColors.disabled),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
