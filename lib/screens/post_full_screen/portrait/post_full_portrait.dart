import 'package:astroverse/controllers/main_controller.dart';
import 'package:astroverse/res/dims/global.dart';
import 'package:astroverse/res/textStyles/text_styles.dart';
import 'package:astroverse/utils/hero_tag.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controller.dart';
import '../../../models/post.dart';

class PostFullPortrait extends StatelessWidget {
  final BoxConstraints cons;

  const PostFullPortrait({super.key, required this.cons});

  @override
  Widget build(BuildContext context) {
    final MainController main = Get.find();
    final AuthController auth = Get.find();
    final Post post = Get.arguments;
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: GlobalDims.horizontalPadding, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Hero(
                tag: HeroTag().forPost(post, PostFields.userBar),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '@${post.authorName}',
                      style: TextStylesLight().coloredSmallThick(Colors.black),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      toTimeDelay(post.date),
                      style: TextStylesLight().small,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                post.title,
                style: TextStylesLight().title,
              ),
              const SizedBox(
                height: 10,
              ),
              Hero(
                tag: HeroTag().forPost(post, PostFields.image),
                child: buildContent(post),
              ),
              const SizedBox(
                height: 10,
              ),
              Hero(
                tag: HeroTag().forPost(post, PostFields.description),
                child: Text(
                  post.description,
                  style: TextStylesLight().small,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.visible,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      IconButton(
                        onPressed: (){},
                        icon: const FaIcon(
                          FontAwesomeIcons.comments,
                          size: 20,
                        ),
                      ),
                      Text(post.upVotes.toString(),
                          style: TextStylesLight().small)
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          main.increaseVote(post.id, auth.user.value!.uid , () {
                          },);
                        },
                        icon: const FaIcon(
                          FontAwesomeIcons.heart,
                          size: 20,
                        ),
                      ),
                      Text(post.upVotes.toString(),
                          style: TextStylesLight().small)
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const FaIcon(
                          FontAwesomeIcons.thumbsDown,
                          size: 20,
                        ),
                      ),
                      Text(
                        post.downVotes.toString(),
                        style: TextStylesLight().small,
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  const Expanded(
                    child: Divider(
                      height: 1,
                      thickness: 1,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    "comments",
                    style: TextStylesLight().small,
                  ),
                ],
              ),
              Expanded(child: Container())
            ],
          ),
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
                image: NetworkImage(post.imageUrl),
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ))
        : const SizedBox(
            height: 0,
          );
  }
}
