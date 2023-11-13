import 'package:astroverse/models/user.dart';
import 'package:astroverse/res/colors/project_colors.dart';
import 'package:astroverse/routes/routes.dart';
import 'package:astroverse/utils/hero_tag.dart';
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
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                child: Hero(
                  tag: HeroTag.forAstro(user, HeroTag.IMAGE),
                  child: Image(
                    image: NetworkImage(user.image),
                    height: 50,
                    width: 50,
                    fit: BoxFit.fill,
                  ),
                ),
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
                      _dataWidget(
                          Icons.data_exploration_outlined,
                          NumberParser().toSocialMediaString(user.points),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(color: ProjectColors.disabled)),
      child: Wrap(
        spacing: 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Icon(
            icon,
            size: 17,
            color: color,
          ),
          Text(
            text,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          )
        ],
      ),
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
