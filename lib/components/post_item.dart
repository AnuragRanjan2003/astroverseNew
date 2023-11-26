import 'dart:developer';

import 'package:astroverse/res/colors/project_colors.dart';
import 'package:astroverse/res/textStyles/text_styles.dart';
import 'package:astroverse/routes/routes.dart';
import 'package:astroverse/utils/hero_tag.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../models/post.dart';

class PostItem extends StatelessWidget {
  final Post post;

  const PostItem({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        log("tapped", name: "POST ITEM");
        Get.toNamed(Routes.postFullScreen, arguments: post);
      },
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding:
        const EdgeInsets.only(left: 18, right: 18, top: 15, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.title,
                      style: TextStylesLight().coloredBodyBold(Colors.black),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text("@${post.authorName}",
                        style: const TextStyle(fontSize: 12)),
                    const SizedBox(
                      height: 5,
                    ),
                    _buildChip(
                        toTimeDelay(post.date),
                        const Icon(
                          Icons.history,
                          size: 15,
                        ),
                        ProjectColors.disabled,
                        ProjectColors.lightBlack)
                  ],
                ),
              ],
            ),
            post.imageUrl.isNotEmpty
                ? const SizedBox(
              height: 15,
            )
                : const SizedBox(
              height: 0,
            ),
            buildContent(post),
            const SizedBox(
              height: 15,
            ),
            Text(
              post.description,
              style: TextStylesLight().small,
              textAlign: TextAlign.start,
              overflow: TextOverflow.visible,
              maxLines: 6,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildDataChip(
                  post.comments.toString(),
                  const Icon(
                    FontAwesomeIcons.comments,
                    size: 14,
                    color: Colors.lightGreen,
                  ),
                ),
                buildDataChip(
                    post.upVotes.toString(),
                    const Icon(
                      FontAwesomeIcons.heart,
                      size: 14,
                      color: Colors.red,
                    )),
                buildDataChip(
                    post.views.toString(),
                    const Icon(
                      FontAwesomeIcons.eye,
                      size: 14,
                      color: ProjectColors.lightBlack,
                    )),
              ],
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }

  Container buildDataChip(String text, Icon icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: ProjectColors.disabled),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          const SizedBox(
            width: 10,
          ),
          Text(
            text,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: ProjectColors.lightBlack,
                fontSize: 12),
          )
        ],
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

  Widget buildContent(Post post) {
    return post.imageUrl.isNotEmpty
        ? AspectRatio(
        aspectRatio: 4 / 3,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          child: Image(
            image: CachedNetworkImageProvider(post.imageUrl),
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ))
        : const SizedBox(
      height: 0,
    );
  }

  Container _buildChip(String text, Icon? icon, Color color, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Wrap(
        direction: Axis.horizontal,
        spacing: 2,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          if (icon != null) icon,
          Text(
            text,
            style: TextStyle(
                fontSize: 10, fontWeight: FontWeight.w600, color: textColor),
          ),
        ],
      ),
    );
  }
}