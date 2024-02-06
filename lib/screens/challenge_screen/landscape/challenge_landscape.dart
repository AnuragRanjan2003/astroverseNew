import 'package:flutter/material.dart';

import '../../../models/challenge.dart';

class ChallengeLandscape extends StatefulWidget {
  final Challenge challenge;
  final BoxConstraints cons;
  const ChallengeLandscape({super.key,required this.challenge, required this.cons});

  @override
  State<ChallengeLandscape> createState() => _ChallengeLandscapeState();
}

class _ChallengeLandscapeState extends State<ChallengeLandscape> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
