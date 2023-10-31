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
                    Hero(
                      tag: HeroTag().forPost(post, PostFields.userBar),
                      child: Text(
                        post.title,
                        style: TextStylesLight().coloredBodyBold(Colors.black),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Text(
                      "@${post.authorName}",
                      style: TextStylesLight()
                          .coloredSmall(ProjectColors.onBackground),
                    ),
                    Text(
                      toTimeDelay(post.date),
                      style: TextStylesLight().small,
                    ),
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
            Hero(
                tag: HeroTag().forPost(post, PostFields.image),
                child: buildContent(post)),
            const SizedBox(
              height: 15,
            ),
            Hero(
              tag: HeroTag().forPost(post, PostFields.description),
              child: Text(
                post.description,
                style: TextStylesLight().small,
                textAlign: TextAlign.start,
                overflow: TextOverflow.visible,
                maxLines: 6,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        FontAwesomeIcons.comments,
                        size: 20,
                        color: ProjectColors.onBackground,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(post.comments.toString())
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        FontAwesomeIcons.heart,
                        size: 20,
                        color: ProjectColors.onBackground,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(post.upVotes.toString())
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        FontAwesomeIcons.eye,
                        size: 20,
                        color: ProjectColors.onBackground,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(post.views.toString())
                    ],
                  ),
                ),
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
}
