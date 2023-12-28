import 'package:astroverse/components/glass_morph_container.dart';
import 'package:astroverse/components/my_post_page.dart';
import 'package:astroverse/components/new_posts_page.dart';
import 'package:astroverse/controllers/location_controller.dart';
import 'package:astroverse/res/colors/project_colors.dart';
import 'package:astroverse/screens/createPost/create_post_screen.dart';
import 'package:dart_geohash/dart_geohash.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controller.dart';

class DiscoverScreenPortrait extends StatelessWidget {
  final BoxConstraints cons;

  const DiscoverScreenPortrait({super.key, required this.cons});

  @override
  Widget build(BuildContext context) {
    final AuthController auth = Get.find();
    final LocationController loc = Get.find();
    var theme = Theme.of(context);
    final ht = cons.maxHeight;
    final wd = cons.maxWidth;

    if (auth.user.value != null && auth.user.value!.geoHash.isEmpty) {
      auth.updateUser({
        "geoHash": GeoHasher().encode(
            loc.location.value!.longitude!, loc.location.value!.latitude!)
      }, auth.user.value!.uid);
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: ProjectColors.greyBackground,
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        floatingActionButton: Container(
          margin: const EdgeInsets.only(top: 10),
          child: FloatingActionButton(
            onPressed: () {
              // Get.toNamed(Routes.createPostScreen);
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const CreatePostScreen(),
              ));
            },
            backgroundColor: Colors.lightBlue,
            elevation: 0,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: const FaIcon(
              FontAwesomeIcons.penNib,
              color: Colors.white,
              size: 17,
            ),
          ),
        ),
        body: SizedBox(
            width: wd,
            child: Stack(
              children: [
                TabBarView(children: [
                  Center(
                    child: NewPostsPage(
                      cons: cons,
                    ),
                  ),
                  const Center(
                    child: MyPostPage(),
                  ),
                ]),
                buildTabBar(theme),
              ],
            )),
      ),
    );
  }

  Widget buildTabBar(ThemeData theme) {
    return GlassMorphContainer(
      borderRadius: 20,
      blur: 3,
      opacity: 0.5,
      margin: EdgeInsets.only(left: 10, right: cons.maxWidth * 0.30, top: 10),
      child: Container(
        padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 10),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.transparent),
        child: Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              surfaceVariant: Colors.transparent,
            ),
          ),
          child: const TabBar(
              indicatorPadding:
                  EdgeInsets.symmetric(horizontal: 0, vertical: 2),
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: Colors.blue),
              indicatorColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.white,
              tabs: [
                Tab(
                  text: 'new',
                ),
                Tab(
                  text: 'my',
                ),
              ]),
        ),
      ),
    );
  }
}
