import 'dart:developer';

import 'package:astroverse/components/comments_bottom_sheet.dart';
import 'package:astroverse/controllers/full_post_page_controller.dart';
import 'package:astroverse/controllers/main_controller.dart';
import 'package:astroverse/models/post_save.dart';
import 'package:astroverse/res/dims/global.dart';
import 'package:astroverse/res/textStyles/text_styles.dart';
import 'package:astroverse/utils/crypt.dart';
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
    final crypto = Crypt();
    final MainController main = Get.find();
    final AuthController auth = Get.find();
    final FullPostPageController controller = Get.put(FullPostPageController());
    final Post post = Get.arguments;
    log(post.authorId, name: "UID");

    if (auth.user.value != null && auth.user.value!.uid != post.authorId) {
      controller.addPostView(post.id, post.authorId);
    }

    controller.getAuthor(post.authorId);
    controller.fetchComments(post.id);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        title: Row(
          children: [
            Obx(() {
              if (controller.author.value == null) {
                return ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  child: Container(
                    width: 30,
                    height: 30,
                    color: Colors.grey.shade300,
                  ),
                );
              }
              return ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  child: Image(
                    image: NetworkImage(controller.author.value!.image),
                    width: 30,
                    height: 30,
                  ));
            }),
            const SizedBox(
              width: 5,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '@${crypto.decryptFromBase64String(post.authorName)}',
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
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: Get.height * 0.9,
          padding: const EdgeInsets.symmetric(
              horizontal: GlobalDims.horizontalPadding, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                tag: HeroTag.forPost(post, PostFields.image),
                child: buildContent(post),
              ),
              const SizedBox(
                height: 10,
              ),
              Hero(
                tag: HeroTag.forPost(post, PostFields.description),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const FaIcon(
                          FontAwesomeIcons.comments,
                          size: 25,
                        ),
                      ),
                      Text(post.comments.toString(),
                          style: TextStylesLight().small)
                    ],
                  ),
                  Column(
                    children: [
                      Obx(
                        () => IconButton(
                          onPressed: post.authorId != auth.user.value!.uid
                              ? () {
                                  if (!isUpVoted(main.upVotedPosts, post.id)) {
                                    main.postList.firstWhere(
                                        (element) => element.id == post.id);
                                    main.increaseVote(
                                      post.id,
                                      auth.user.value!.uid,
                                      post.authorId,
                                      () {},
                                    );
                                  } else {
                                    main.decrementVote(
                                      post.id,
                                      auth.user.value!.uid,
                                      post.authorId,
                                      () {},
                                    );
                                  }
                                }
                              : null,
                          icon: isUpVoted(main.upVotedPosts, post.id)
                              ? const FaIcon(
                                  FontAwesomeIcons.solidHeart,
                                  color: Colors.red,
                                  size: 25,
                                )
                              : const FaIcon(
                                  FontAwesomeIcons.heart,
                                  size: 25,
                                ),
                        ),
                      ),
                      Text(post.upVotes.toString(),
                          style: TextStylesLight().small),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const FaIcon(
                          FontAwesomeIcons.eye,
                          size: 25,
                        ),
                      ),
                      Text(
                        post.views.toString(),
                        style: TextStylesLight().small,
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
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
              GestureDetector(
                onTap: () {
                  Get.bottomSheet(
                    isScrollControlled: true,
                    CommentsBottomSheet(
                      user: auth.user.value!,
                      post: post,
                    ),
                  );
                },
                child: buildCommentWidget(),
              ),
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

  bool isUpVoted(List<PostSave> list, String id) {
    return list.any((element) => element.id == id);
  }

  Widget buildCommentWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: const BoxDecoration(
            color: Color(0x64dad9d9),
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Comments",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text('click to see the comment section')
          ],
        ),
      ),
    );
  }
}
