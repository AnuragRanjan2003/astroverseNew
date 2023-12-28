import 'dart:developer';

import 'package:astroverse/components/post_item.dart';
import 'package:astroverse/controllers/auth_controller.dart';
import 'package:astroverse/controllers/main_controller.dart';
import 'package:astroverse/models/post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class MyPostPage extends StatelessWidget {
  const MyPostPage({super.key});

  @override
  Widget build(BuildContext context) {
    final MainController mainController = Get.find();
    final AuthController auth = Get.find();

    final ScrollController scrollController = ScrollController();

    if (auth.user.value != null) {
      log("not null", name: "USER");
      mainController.startReadingUpVotedPosts(auth.user.value!.uid);
      mainController.fetchUserPosts(auth.user.value!.uid);
    }

    return RefreshIndicator(
      color: Colors.lightBlue,
      onRefresh: () async {
        log('refreshing', name: "REFRESH");
        mainController.fetchUserPosts(auth.user.value!.uid);
      },
      child: Stack(
        children: [
          Obx(
            () {
              final list = mainController.myPosts;
              return ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: scrollController,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return const SizedBox(
                        height: 100,
                      );
                    } else if (index == list.length + 1) {
                      if (mainController.myPostLoading.isTrue) {
                        return const CupertinoActivityIndicator();
                      } else {
                        return const SizedBox(
                          height: 0,
                        );
                      }
                    } else if (index == list.length + 2) {
                      return const SizedBox(
                        height: 100,
                      );
                    }

                    return listItem(list[index - 1]);
                  },
                  separatorBuilder: (context, index) => separator(),
                  itemCount: list.length + 3);
            },
          ),
        ],
      ),
    );
  }

  Widget separator() {
    return const SizedBox(
      height: 20,
    );
  }

  Widget listItem(Post post) => PostItem(post: post);

  bool areEqual(List l1, List l2) {
    if (l1.length == l2.length && l1.every((element) => l2.contains(element))) {
      return true;
    }
    return false;
  }

  List<Post> filterPostList(List<Post> l1, List<String> g) {
    List<Post> filter = <Post>[];
    if (g.isEmpty) return l1;
    for (Post it in l1) {
      if (areEqual(it.genre, g)) filter.add(it);
    }

    return filter;
  }
}
