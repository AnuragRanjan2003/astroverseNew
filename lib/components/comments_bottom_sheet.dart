import 'dart:developer';

import 'package:astroverse/components/comment_item.dart';
import 'package:astroverse/controllers/full_post_page_controller.dart';
import 'package:astroverse/models/comment.dart';
import 'package:astroverse/models/post.dart';
import 'package:astroverse/models/user.dart';
import 'package:astroverse/res/img/images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommentsBottomSheet extends StatelessWidget {
  final User user;
  final Post post;

  const CommentsBottomSheet(
      {super.key, required this.user, required this.post});

  @override
  Widget build(BuildContext context) {
    final FullPostPageController postPageController = Get.find();
    final commentController = TextEditingController();
    final replyController = TextEditingController();
    final pageController = PageController(initialPage: 0);

    postPageController.fetchComments(post.id);

    return Container(
      width: Get.width,
      constraints: BoxConstraints(maxHeight: Get.height * 0.7),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: PageView.builder(
          pageSnapping: true,
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          itemBuilder: (context, i) {
            if (i == 1) {
              return Column(
                children: [
                  AppBar(
                    title: const Text(
                      "Replies",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Obx(() {
                    final list = postPageController.replies;
                    if(postPageController.repliesLoading.isTrue) return const CircularProgressIndicator();
                    return Expanded(
                        child: list.isNotEmpty
                            ? ListView.separated(
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                  height: 20,
                                ),
                                itemBuilder: (context, index) {
                                  if (index == list.length) {
                                    return TextButton(
                                        onPressed: postPageController
                                                .moreCommentsToLoad.isTrue
                                            ? () {
                                                postPageController
                                                    .fetchMoreComments(post.id);
                                              }
                                            : null,
                                        child: const Text("load more"));
                                  }
                                  return CommentItem(
                                    item: list[index],
                                    onClick: () {
                                      postPageController.commentId.value =
                                          list[index].id;
                                      pageController.animateToPage(1,
                                          duration:
                                              const Duration(milliseconds: 300),
                                          curve: Curves.linear);
                                    },
                                    replyButton: false,
                                  );
                                },
                                itemCount: list.length + 1,
                              )
                            : const Center(
                                child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image(
                                    image: ProjectImages.emptyBox,
                                    height: 100,
                                    width: 100,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text('nothing to show'),
                                ],
                              )));
                  }),
                  SizedBox(
                    height: 60,
                    child: Row(
                      children: [
                        CircleAvatar(
                          foregroundImage: NetworkImage(user.image),
                          radius: 20,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                            child: TextField(
                          controller: replyController,
                          decoration: const InputDecoration(
                              fillColor: Color(0x64dad9d9),
                              filled: true,
                              border: OutlineInputBorder()),
                        )),
                        IconButton(
                          onPressed: () {
                            _postReply(
                                post.id,
                                postPageController.commentId.value,
                                replyController.value.text,
                                user,
                                postPageController);
                            replyController.clear();
                          },
                          icon: const Icon(Icons.send),
                        )
                      ],
                    ),
                  )
                ],
              );
            }
            return Column(
              children: [
                AppBar(
                  title: const Text(
                    "Comments",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Obx(() {
                  final list = postPageController.commentList;
                  return Expanded(
                      child: list.isNotEmpty
                          ? ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                height: 20,
                              ),
                              itemBuilder: (context, index) {
                                if (index == list.length) {
                                  return TextButton(
                                      onPressed: postPageController
                                              .moreCommentsToLoad.isTrue
                                          ? () {
                                              postPageController
                                                  .fetchMoreComments(post.id);
                                            }
                                          : null,
                                      child: const Text("load more"));
                                }
                                return CommentItem(
                                  item: list[index],
                                  onClick: () {
                                    postPageController.commentId.value = list[index].id;
                                    postPageController.getReplies(post.id, list[index].id);
                                    pageController.animateToPage(1,
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.linear);
                                  },
                                );
                              },
                              itemCount: list.length + 1,
                            )
                          : const Center(
                              child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image(
                                  image: ProjectImages.emptyBox,
                                  height: 100,
                                  width: 100,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('nothing to show'),
                              ],
                            )));
                }),
                Visibility(
                  visible: post.authorId != user.uid,
                  child: SizedBox(
                    height: 60,
                    child: Row(
                      children: [
                        CircleAvatar(
                          foregroundImage: NetworkImage(user.image),
                          radius: 20,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                            child: TextField(
                          controller: commentController,
                          decoration: const InputDecoration(
                              fillColor: Color(0x64dad9d9),
                              filled: true,
                              border: OutlineInputBorder()),
                        )),
                        IconButton(
                          onPressed: () {
                            _postComment(
                                post.id,
                                post.authorId,
                                commentController.value.text,
                                user,
                                postPageController);
                            commentController.clear();
                          },
                          icon: const Icon(Icons.send),
                        )
                      ],
                    ),
                  ),
                )
              ],
            );
          }),
    );
  }

  _postComment(String postId, String postAuthorId, String text, User user,
      FullPostPageController c) {
    log("commenting", name: "COMMENT");
    final comment = Comment(
      user.name,
      user.uid,
      text,
      '',
      postId,
      user.astro,
      DateTime.now(),
    );
    c.postComment(comment, postId, postAuthorId);
    c.commentList.add(comment);
  }

  _postReply(String postId , String commentId ,String text , User user ,FullPostPageController c){
    if(commentId.isEmpty) return;
    final comment = Comment(
      user.name,
      user.uid,
      text,
      '',
      postId,
      user.astro,
      DateTime.now(),
    );
    c.postReply(postId, commentId, comment);
    c.replies.add(comment);
  }
}
