import 'package:astroverse/controllers/challenge_screen_controller.dart';
import 'package:astroverse/models/challenge.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChallengePortrait extends StatefulWidget {
  final Challenge challenge;
  final BoxConstraints cons;

  const ChallengePortrait(
      {super.key, required this.challenge, required this.cons});

  @override
  State<ChallengePortrait> createState() => _ChallengePortraitState();
}

class _ChallengePortraitState extends State<ChallengePortrait> {
  late ChallengeScreenController controller;

  @override
  void initState() {
    controller = Get.put(ChallengeScreenController());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
                expandedHeight: 100,
                pinned: true,
                title: Text(widget.challenge.title)),
            SliverList(
                delegate: SliverChildListDelegate.fixed([
              Text(widget.challenge.body),
              Text(widget.challenge.publishDate.formatted()),

            ]))
          ],
        ),
      ),
    );
  }
}

extension on DateTime {
  String formatted() {
    return DateFormat("dd MMM , yyyy").format(this);
  }
}
