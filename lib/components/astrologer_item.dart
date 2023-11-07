import 'package:astroverse/models/user.dart';
import 'package:astroverse/res/colors/project_colors.dart';
import 'package:astroverse/routes/routes.dart';
import 'package:astroverse/utils/num_parser.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AstrologerItem extends StatelessWidget {
  final User user;

  const AstrologerItem({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.publicProfile, arguments: user);
      },
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Row(
            children: [
              CircleAvatar(
                foregroundImage: NetworkImage(user.image),
                radius: 24,
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: ProjectColors.lightBlack),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      _dataWidget(
                          Icons.remove_red_eye,
                          NumberParser().toSocialMediaString(user.profileViews),
                          Colors.orange),
                      const SizedBox(
                        width: 20,
                      ),
                      _dataWidget(Icons.data_exploration_outlined, NumberParser().toSocialMediaString(user.points),
                          Colors.blueAccent),
                    ],
                  )
                ],
              ),
            ],
          )),
    );
  }

  Widget _dataWidget(IconData icon, String text, Color color) {
    return Wrap(
      spacing: 4,
      children: [
        Icon(
          icon,
          size: 17,
          color: color,
        ),
        Text(
          text,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        )
      ],
    );
  }

  Widget _featuredChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: const BorderRadius.all(Radius.circular(30))),
      child: const Text(
        'featured',
        style: TextStyle(fontSize: 12),
      ),
    );
  }
}
