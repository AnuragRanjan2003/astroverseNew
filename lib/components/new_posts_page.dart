import 'dart:developer';

import 'package:astroverse/components/load_more_button.dart';
import 'package:astroverse/components/post_item.dart';
import 'package:astroverse/controllers/auth_controller.dart';
import 'package:astroverse/controllers/main_controller.dart';
import 'package:astroverse/controllers/new_page_controller.dart';
import 'package:astroverse/res/colors/project_colors.dart';
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
    final NewPageController newPage = Get.put(NewPageController());
    final wd = cons.maxWidth;
    final ScrollController scrollController = ScrollController();

    if (auth.user.value != null) {
      log("not null", name: "USER");
      mainController.startReadingUpVotedPosts(auth.user.value!.uid);
      mainController.fetchPostsByGenreAndPage(
          NewPageController.genresList, auth.user.value!.uid);
    }
    loadMore() {
      mainController.fetchMorePosts(
          newPage.selectedGenres, auth.user.value!.uid);
    }

    const genres = NewPageController.genresList;
    return RefreshIndicator(
      color: ProjectColors.primary,
      onRefresh: () async {
        log('refreshing', name: "REFRESH");
        mainController.refreshPosts(
            newPage.selectedGenres.isEmpty
                ? NewPageController.genresList
                : newPage.selectedGenres,
            auth.user.value!.uid);
      },
      child: Stack(
        children: [
          Obx(
            () {
              final list = filterPostList(
                  mainController.postList, newPage.selectedGenres);
              return ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: scrollController,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return const SizedBox(
                        height: 100,
                      );
                    } else if (index == list.length + 1) {
                      if (mainController.loadingMorePosts.isTrue) {
                        return const CupertinoActivityIndicator();
                      } else if (mainController.morePostsToLoad.isTrue) {
                        return LoadMoreButton(cons: cons, loadMore: loadMore);
                      } else {
                        return const SizedBox(
                          height: 100,
                        );
                      }
                    }

                    return listItem(list[index - 1]);
                  },
                  separatorBuilder: (context, index) => separator(),
                  itemCount: list.length + 2);
            },
          ),
          Positioned(
            top: 70,
            left: 10,
            child: SizedBox(
              width: wd - 20,
              height: 50,
              child: Obx(() => ListView(
                    scrollDirection: Axis.horizontal,
                    children: List.generate(
                        genres.length,
                        (index) => buildFilterChip(
                            mainController, newPage, index, genres)),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFilterChip(MainController main, NewPageController newPage,
      int index, List<String> genres) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: FilterChip(
        backgroundColor: Colors.white,
        checkmarkColor: Colors.white,
        onSelected: (e) {
          if (e == true) {
            newPage.addItem(index);
          } else {
            newPage.removeItem(index);
          }
        },
        label: Text(
          genres[index],
          style: TextStyle(
              fontSize: 12,
              color: newPage.genres[index] ? Colors.white : Colors.black),
        ),
        selected: newPage.genres[index],
        selectedColor: ProjectColors.primary,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30))),
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
    if (g.contains("astro challenge")) {
      return [];
    }
    for (Post it in l1) {
      if (it.genre.any((element) => g.contains(element))) filter.add(it);
    }

    return filter;
  }
}
