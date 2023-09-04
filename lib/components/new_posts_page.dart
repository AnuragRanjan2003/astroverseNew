import 'dart:developer';

import 'package:astroverse/controllers/auth_controller.dart';
import 'package:astroverse/controllers/main_controller.dart';
import 'package:astroverse/res/img/images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/post.dart';

class NewPostsPage extends StatelessWidget {
  const NewPostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final MainController mainController = Get.find();
    final AuthController auth = Get.find();
    final ScrollController scrollController = ScrollController();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        log("scroll max", name: "SCROLL NEW POST");
        mainController.fetchMorePosts(["a", "b"]);
      }
    });

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
              return const CupertinoActivityIndicator();
            }
            return listItem(mainController.postList[index]);
          },
          separatorBuilder: (context, index) => separator(),
          itemCount: mainController.postList.length+1)),
    );
  }

  Widget separator() {
    return const SizedBox(
      height: 20,
    );
  }

  Widget listItem(Post post ) {
    return ListTile(
      leading: const Image(
        image: ProjectImages.bank,
      ),
      title: Text(post.title),
      subtitle: Text(post.description),
    );
  }
}
