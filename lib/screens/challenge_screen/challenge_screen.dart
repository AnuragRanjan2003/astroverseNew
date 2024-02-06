import 'package:astroverse/models/challenge.dart';
import 'package:astroverse/screens/challenge_screen/landscape/challenge_landscape.dart';
import 'package:astroverse/screens/challenge_screen/portrait/challenge_portrait.dart';
import 'package:astroverse/utils/responsive.dart';
import 'package:flutter/material.dart';

class ChallengeScreen extends StatelessWidget {
  final Challenge challenge;

  const ChallengeScreen({super.key, required this.challenge});

  @override
  Widget build(BuildContext context) {
    return Responsive(
      portrait: (cons) => ChallengePortrait(challenge: challenge, cons: cons),
      landscape: (cons) => ChallengeLandscape(challenge: challenge, cons: cons),
    );
  }
}
