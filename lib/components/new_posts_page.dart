import 'dart:developer';

import 'package:astroverse/components/post_item.dart';
import 'package:astroverse/controllers/auth_controller.dart';
import 'package:astroverse/controllers/main_controller.dart';
import 'package:astroverse/res/textStyles/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/post.dart';

class NewPostsPage extends StatelessWidget {
  final BoxConstraints cons;

  const NewPostsPage({super.key, required this.cons});

  @override
  Widget build(BuildContext context) {
    final MainController mainController = Get.find();
    final AuthController auth = Get.find();
    final wd = cons.maxWidth;
    final ScrollController scrollController = ScrollController();
    if (auth.user.value != null) {
      log("not null" ,name:"USER");
      mainController.startReadingUpVotedPosts(auth.user.value!.uid);
    }

    return RefreshIndicator(
      color: Colors.lightBlue,
      onRefresh: () async {
        log('refreshing', name: "REFRESH");
        mainController.refreshPosts();
      },
      child: Obx(() => ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: scrollController,
          itemBuilder: (context, index) {
            if (index == mainController.postList.length) {
              if (mainController.loadingMorePosts.isTrue) {
                return const CupertinoActivityIndicator();
              } else if (mainController.morePostsToLoad.isTrue) {
                return Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 0.25 * wd, vertical: 10),
                  child: OutlinedButton(
                      onPressed: () {
                        mainController.fetchMorePosts(["a", "b"]);
                      },
                      child: Text(
                        "load more",
                        style: TextStylesLight().small,
                      )),
                );
              } else {
                return const SizedBox(
                  height: 0,
                );
              }
            }
            return listItem(mainController.postList[index]);
          },
          separatorBuilder: (context, index) => separator(),
          itemCount: mainController.postList.length + 1)),
    );
  }

  Widget separator() {
    return const Row(
      children: [
        SizedBox(
          width: 8,
        ),
        Expanded(
          child: Divider(
            thickness: 1,
            height: 1,
          ),
        ),
        SizedBox(
          width: 8,
        )
      ],
    );
  }

  Widget listItem(Post post) => PostItem(post: post);
}
