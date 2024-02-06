import 'package:astroverse/components/challenge_page.dart';
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
import '../../../controllers/challenge_controller.dart';

class DiscoverScreenPortrait extends StatelessWidget {
  final BoxConstraints cons;

  const DiscoverScreenPortrait({super.key, required this.cons});

  @override
  Widget build(BuildContext context) {
    final AuthController auth = Get.find();
    final LocationController loc = Get.find();
    Get.put(ChallengeController());
    var theme = Theme.of(context);
    final ht = cons.maxHeight;
    final wd = cons.maxWidth;

    if (auth.user.value != null && auth.user.value!.geoHash.isEmpty) {
      auth.updateUser({
        "geoHash": GeoHasher().encode(
            loc.location.value!.longitude!, loc.location.value!.latitude!)
      }, auth.user.value!.uid, (_) {});
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: ProjectColors.greyBackground,
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: Container(
          margin: const EdgeInsets.only(bottom: 100),
          child: FloatingActionButton(
            onPressed: () {
              if (auth.user.value != null) {
                if (!auth.user.value!.activated) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("account not activated")));
                  return;
                }
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const CreatePostScreen(),
                ));
              }
            },
            backgroundColor: ProjectColors.primary,
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
                  const Center(
                    child: ChallengePage(),
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
      onlyBottomRadius: true,
      opacity: 0.5,
      margin: const EdgeInsets.only(left: 0, right: 0, top: 0),
      child: Container(
        padding: const EdgeInsets.only(left: 8, top: 5, bottom: 5, right: 8),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20)),
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
                  color: ProjectColors.primary),
              indicatorColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.white,
              tabs: [
                Tab(
                  text: 'discover',
                ),
                Tab(
                  text: 'my Posts',
                ),
                Tab(
                  text: 'challenges',
                ),
              ]),
        ),
      ),
    );
  }
}
