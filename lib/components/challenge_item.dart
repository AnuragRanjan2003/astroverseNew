import 'package:astroverse/models/challenge.dart';
import 'package:flutter/material.dart';

class ChallengeItem extends StatelessWidget {
  final Challenge challenge;
  final Function(Challenge) onTap;

  const ChallengeItem(
      {super.key, required this.challenge, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(challenge);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(challenge.title),
            Text(challenge.body),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(challenge.totalVotes.toString()),
                Text(challenge.votesFor.toString()),
                Text(challenge.votesAgainst.toString()),
              ],
            )
          ],
        ),
      ),
    );
  }
}
