import 'package:astroverse/components/challenge_item.dart';
import 'package:astroverse/controllers/challenge_controller.dart';
import 'package:astroverse/screens/challenge_screen/challenge_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChallengePage extends StatefulWidget {
  const ChallengePage({super.key});

  @override
  State<ChallengePage> createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  late ChallengeController controller;

  @override
  void initState() {
    controller = Get.find();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: Padding(
        padding: const EdgeInsets.only(top: 70, left: 10, right: 10),
        child: Obx(() => _renderChallenges(controller)),
      ),
      onRefresh: () async {
        controller.getChallenges();
      },
    );
  }
}

Widget _renderChallenges(ChallengeController controller) {
  if (controller.isLoading.isTrue) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  } else {
    return ListView.separated(
        itemBuilder: (context, index) => index == controller.list.length
            ? const SizedBox(height: 100)
            : ChallengeItem(
                challenge: controller.list[index],
                onTap: (ch) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ChallengeScreen(challenge: ch),
                  ));
                }),
        separatorBuilder: (context, index) => const SizedBox(
              height: 30,
            ),
        itemCount: controller.list.length + 1);
  }
}
