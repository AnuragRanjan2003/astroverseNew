import 'package:astroverse/models/challenge.dart';
import 'package:astroverse/res/colors/project_colors.dart';
import 'package:astroverse/utils/num_parser.dart';
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
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              challenge.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10,),
            Text(
              challenge.body,
              style: const TextStyle(
                  fontSize: 13,
                  color: ProjectColors.disabled,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _dataItem(Icons.history, toTimeDelay(challenge.publishDate)),
                  _dataItem(
                    Icons.how_to_vote,
                    NumberParser().toSocialMediaString(challenge.optionsVotes.reduce((value, element) => value+element)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String toTimeDelay(DateTime date) {
    final now = DateTime.now();
    final delay = now.difference(date);
    final days = delay.inDays;
    String str = "";
    if (days == 0) {
      str = "today";
    } else if (days == 1) {
      str = "yesterday";
    } else {
      str = "$days days ago";
    }
    return str;
  }

  Widget _dataItem(IconData icon, String data) {
    return Row(
      children: [
        Icon(
          icon,
          color: ProjectColors.disabled,
          size: 18,
        ),
        const SizedBox(
          width: 8,
        ),
        Text(data,
            style: const TextStyle(
              fontSize: 12,
              color: ProjectColors.disabled,
              fontWeight: FontWeight.w500,
            ))
      ],
    );
  }


}
