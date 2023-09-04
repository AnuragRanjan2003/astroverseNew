import 'dart:developer';

import 'package:astroverse/components/new_posts_page.dart';
import 'package:astroverse/controllers/main_controller.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controller.dart';
import '../../../models/post.dart';

class DiscoverScreenPortrait extends StatelessWidget {
  final BoxConstraints cons;
  final Color color;

  const DiscoverScreenPortrait(
      {super.key, required this.cons, required this.color});

  @override
  Widget build(BuildContext context) {
    final AuthController auth = Get.find();
    final MainController main = Get.find();
    final ht = cons.maxHeight;
    final wd = cons.maxWidth;
    int index = 4;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: color,
        floatingActionButton: Obx(() {
          if (auth.user.value?.astro == true) {
            return FloatingActionButton(
              onPressed: () {
                _testPost(main, index);
                index++;
              },
              backgroundColor: Colors.lightBlue.shade300,
              elevation: 0,
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            );
          }
          return const SizedBox(
            height: 0,
          );
        }),
        body: Container(
            width: wd,
            child: Column(
              children: [
                const TabBar(
                  indicatorColor: Colors.lightBlue,
                  labelColor: Colors.lightBlue,
                  tabs: [
                    Tab(
                      text: "new",
                    ),
                    Tab(
                      text: "following",
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(children: [
                    Center(
                      child: NewPostsPage(
                        cons: cons,
                      ),
                    ),
                    const Center(
                      child: Text("following"),
                    ),
                  ]),
                ),
              ],
            )),
      ),
    );
  }

  _testPost(MainController controller, int index) {
    final post = Post(
      id: "12123234",
      title: "$index",
      description: "asdasdsdadsasd",
      genre: ["a", "b"],
      date: DateTime.timestamp(),
      imageUrl:
          "https://images.unsplash.com/photo-1693054092499-c471393da690?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80",
      upVotes: 20,
      downVotes: 10,
      authorName: "abc",
      authorId: "123",
    );

    controller.savePost(post, (p0) {
      if (p0.isSuccess) {
        log((p0 as Success<Post>).data.toString(), name: "POST");
      }
    });
  }
}
