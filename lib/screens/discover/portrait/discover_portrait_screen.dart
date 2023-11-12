import 'package:astroverse/components/new_posts_page.dart';
import 'package:astroverse/controllers/main_controller.dart';
import 'package:astroverse/res/colors/project_colors.dart';
import 'package:astroverse/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controller.dart';

class DiscoverScreenPortrait extends StatelessWidget {
  final BoxConstraints cons;

  const DiscoverScreenPortrait(
      {super.key, required this.cons});

  @override
  Widget build(BuildContext context) {
    final AuthController auth = Get.find();
    final MainController main = Get.find();
    var theme = Theme.of(context);
    final ht = cons.maxHeight;
    final wd = cons.maxWidth;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: ProjectColors.greyBackground,
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        floatingActionButton: Obx(() {
          if (auth.user.value?.astro == true) {
            return Container(
              margin: const EdgeInsets.only(top: 10),
              child: FloatingActionButton(
                onPressed: () {
                  Get.toNamed(Routes.createPostScreen);
                },
                backgroundColor: Colors.lightBlue.shade300,
                elevation: 0,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: const FaIcon(
                  FontAwesomeIcons.penNib,
                  color: Colors.white,
                  size: 17,
                ),
              ),
            );
          }
          return const SizedBox(
            height: 0,
          );
        }),
        body: SizedBox(
            width: wd,
            child: Column(
              children: [
                buildTabBar(theme),
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

  Container buildTabBar(ThemeData theme) {
    return Container(
      margin: EdgeInsets.only(
          left: 10, right: cons.maxWidth * 0.30, top: 10),
      padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5,right: 10),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.white),
      child: Theme(
        data: theme.copyWith(
          colorScheme: theme.colorScheme.copyWith(
            surfaceVariant: Colors.transparent,
          ),
        ),
        child: const TabBar(
            indicatorPadding: EdgeInsets.symmetric(horizontal: 10),
            indicator: BoxDecoration(),
            indicatorColor: Colors.transparent,
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: Colors.lightBlue,
            tabs: [
              Tab(
                text: 'new',
              ),
              Tab(
                text: 'following',
              ),
            ]),
      ),
    );
  }
}