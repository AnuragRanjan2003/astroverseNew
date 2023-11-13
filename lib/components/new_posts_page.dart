import 'dart:developer';

import 'package:astroverse/components/post_item.dart';
import 'package:astroverse/controllers/auth_controller.dart';
import 'package:astroverse/controllers/main_controller.dart';
import 'package:astroverse/controllers/new_page_controller.dart';
import 'package:astroverse/res/textStyles/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/post.dart';
import '../res/colors/project_colors.dart';

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
      mainController.fetchPostsByGenreAndPage(NewPageController.genresList, auth.user.value!.uid);
    }

    const genres = NewPageController.genresList;
    return RefreshIndicator(
      color: Colors.lightBlue,
      onRefresh: () async {
        log('refreshing', name: "REFRESH");
        mainController.refreshPosts(newPage.selectedGenres.isEmpty
            ? NewPageController.genresList
            : newPage.selectedGenres,auth.user.value!.uid);
      },
      child: Column(
        children: [
          Obx(() => Row(
            children: List.generate(
                genres.length,
                    (index) => buildFilterChip(
                    mainController, newPage, index, genres)),
          )),
          Expanded(
            child: Obx(
                  () {
                final list = filterPostList(
                    mainController.postList, newPage.selectedGenres);
                return ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: scrollController,
                    itemBuilder: (context, index) {
                      if (index == list.length) {
                        if (mainController.loadingMorePosts.isTrue) {
                          return const CupertinoActivityIndicator();
                        } else if (mainController.morePostsToLoad.isTrue) {
                          return Padding(
                            padding:
                            EdgeInsets.only(left: cons.maxWidth * 0.2,right: cons.maxWidth * 0.2,bottom: 200),
                            child: MaterialButton(
                                color: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10))),
                                onPressed: () {
                                  mainController
                                      .fetchMorePosts(newPage.selectedGenres,auth.user.value!.uid);
                                },
                                child: const Wrap(
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    spacing: 8,
                                    children: [
                                      Text(
                                        "load more",
                                        style: TextStyle(color: ProjectColors.disabled),
                                      ),
                                      Icon(
                                        Icons.refresh,
                                        color: Colors.lightBlue,
                                        size: 18,
                                      )
                                    ])),
                          );
                        } else {
                          return const SizedBox(
                            height: 100,
                          );
                        }
                      }

                      return listItem(list[index]);
                    },
                    separatorBuilder: (context, index) => separator(),
                    itemCount: list.length + 1);
              },
            ),
          ),
        ],
      ),
    );
  }

  FilterChip buildFilterChip(MainController main, NewPageController newPage,
      int index, List<String> genres) {
    return FilterChip(
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
        style: TextStylesLight().coloredSmall(
            newPage.genres[index] ? Colors.white : Colors.black54),
      ),
      selected: newPage.genres[index],
      selectedColor: Colors.lightBlue.shade300,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30))),
    );
  }

  Widget separator() {
    return const SizedBox(height: 20,);
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