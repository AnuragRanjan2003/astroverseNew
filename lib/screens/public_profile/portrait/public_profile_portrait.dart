import 'dart:developer';

import 'package:astroverse/components/person_items.dart';
import 'package:astroverse/components/person_posts.dart';
import 'package:astroverse/components/see_more_profile_bottom_sheet.dart';
import 'package:astroverse/controllers/auth_controller.dart';
import 'package:astroverse/controllers/public_profile_controller.dart';
import 'package:astroverse/db/plans_db.dart';
import 'package:astroverse/models/extra_info.dart';
import 'package:astroverse/models/user.dart';
import 'package:astroverse/res/colors/project_colors.dart';
import 'package:astroverse/res/img/images.dart';
import 'package:astroverse/res/textStyles/text_styles.dart';
import 'package:astroverse/screens/messaging.dart';
import 'package:astroverse/utils/crypt.dart';
import 'package:astroverse/utils/geo.dart';
import 'package:astroverse/utils/hero_tag.dart';
import 'package:astroverse/utils/num_parser.dart';
import 'package:astroverse/utils/zego_cloud_services.dart';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart' as comet;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class PublicProfilePortrait extends StatelessWidget {
  final BoxConstraints cons;
  final User user;
  static const _imageRadius = 60.00;

  const PublicProfilePortrait(
      {super.key, required this.cons, required this.user});

  @override
  Widget build(BuildContext context) {
    final crypto = Crypt();
    //User user = Get.arguments;
    //log("$user", name: "ASTRO USER");
    final AuthController auth = Get.find();
    log("${auth.user.value!.plan}", name: "USER PLAN");
    final decryptedUserName = crypto.decryptFromBase64String(user.name);

    final PublicProfileController public = Get.find();
    final zegoService = ZegoCloudServices();
    final ht = cons.maxHeight;

    public.getExtraInfo(user.uid);
    public.updateProfileViews(user.uid);
    public.fetchUserPosts(user.uid);
    public.fetchUserServices(user.uid);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        bottomNavigationBar: auth.user.value!.astro == false
            ? BottomAppBar(
                surfaceTintColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Visibility(
                      visible: auth.user.value!.plan >=
                          Plans.plans[1].value + VisibilityPlans.all + 1,
                      child: Expanded(
                          flex: 7,
                          child: zegoService.callButton(
                              user.uid, decryptedUserName)),
                    ),
                    const Spacer(
                      flex: 1,
                    ),
                    Visibility(
                      visible: auth.user.value!.plan >=
                          Plans.plans[0].value + VisibilityPlans.all + 1,
                      child: Expanded(
                        flex: 7,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              comet.User receiver = comet.User(
                                  uid: user.uid,
                                  name: decryptedUserName,
                                  avatar: user.image);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Messaging(receiver: receiver),
                                ),
                              );
                            },
                            child: Container(
                              width: 80, // Set the width of the button
                              height: 80, // Set the height of the button
                              decoration: const BoxDecoration(
                                shape: BoxShape
                                    .circle, // Makes the container circular
                                color: Colors
                                    .lightBlue, // Set the background color of the button
                              ),
                              child: const Center(
                                  child: Icon(
                                Icons.messenger_outlined,
                                color: Colors.white,
                              )),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox.shrink(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildTopBanner(ht, user),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    decryptedUserName,
                    textAlign: TextAlign.center,
                    style: TextStylesLight().bodyBold,
                  ),
                  const SizedBox(
                    height: 15,
                  ),

                  Builder(builder: (context) {
                    return Obx(() => OutlinedButton(
                        onPressed: public.info.value == null
                            ? null
                            : () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => SeemMoreBottomSheet(
                                      user: user,
                                      extraInfo: public.info.value!),
                                ));
                              },
                        child: Text(
                          "See more",
                          style: TextStyle(
                              fontSize: 12,
                              color: public.info.value != null
                                  ? Colors.black
                                  : ProjectColors.disabled,
                              fontWeight: FontWeight.w500),
                        )));
                  }),
                  const SizedBox(
                    height: 15,
                  ),
                  Obx(() {
                    final info = public.info.value;
                    if (info == null) return _buildDatesColumnShimmer();
                   return Row(
                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                     children: [
                       _buildChip(Icons.shopping_bag_outlined, info.servicesSold.toString(),Colors.green ),
                       _buildChip(Icons.data_exploration_outlined, info.posts.toString(),Colors.blue ),
                       _buildChip(Icons.remove_red_eye_outlined, user.profileViews.toString(),Colors.grey ),
                       _buildChip(Icons.star_border, user.featured?"Yes":"No",Colors.pink ),
                     ],
                   );
                  }),
                ],
              ),
            ),
            const TabBar(
              tabs: [
                Tab(text: 'posts',),
                Tab(text: 'services'),
              ],
              indicatorColor: ProjectColors.primary,labelColor: ProjectColors.primary,
            ),
            Expanded(
                child: TabBarView(
              children: [
                Center(child: Obx(() {
                  if (public.postsLoading.isTrue) {
                    return const SizedBox(
                      height: 30,
                      width: 20,
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return PersonPosts(list: public.posts);
                  }
                })),
                Center(child: Obx(() {
                  if (public.serviceLoading.isTrue) {
                    return const SizedBox(
                      height: 30,
                      width: 20,
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return PersonItems(list: public.service);
                  }
                })),
              ],
            ))
          ],
        ),
      ),
    );
  }

  Container _buildDatesColumn(DateTime joiningDate, DateTime lastSeen) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(width: 0.5)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Joined on",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
              ),
              Text(
                DateFormat('dd MMM, yyyy').format(joiningDate),
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Last active on",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
              ),
              Text(
                DateFormat('dd MMM, yyyy').format(lastSeen),
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container _buildDatesColumnShimmer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(width: 0.5)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Joined on",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
              ),
              Shimmer.fromColors(
                baseColor: const Color(0xffd3d3d3),
                highlightColor: const Color(0x0fe6e1e1),
                child: Container(
                  width: 80,
                  height: 20,
                  decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Last active on",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
              ),
              Shimmer.fromColors(
                baseColor: const Color(0xffd3d3d3),
                highlightColor: const Color(0x0fe6e1e1),
                child: Container(
                  width: 80,
                  height: 20,
                  decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopBanner(double ht, User user) {
    return SizedBox(
      height: ht * 0.18 + _imageRadius,
      child: Stack(
        children: [
          Image(
            image: ProjectImages.background,
            width: double.infinity,
            fit: BoxFit.fitWidth,
            height: ht * 0.18,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: _imageRadius,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.all(Radius.circular(_imageRadius)),
                child: Hero(
                  tag: HeroTag.forAstro(user, HeroTag.IMAGE),
                  child: Image(
                    image: NetworkImage(user.image),
                    fit: BoxFit.fill,
                    height: 2 * (_imageRadius - 5),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDataChips(ExtraInfo info, int views, int points) {
    return Wrap(
      direction: Axis.horizontal,
      spacing: 8.0,
      runSpacing: 8.0,
      children: [
        _buildChip(
            Icons.shopping_bag,
            NumberParser().toSocialMediaString(info.servicesSold),
            Colors.green),
        _buildChip(
            Icons.data_exploration,
            NumberParser().toSocialMediaString(info.posts),
            ProjectColors.primary),
        _buildChip(Icons.remove_red_eye,
            NumberParser().toSocialMediaString(views), Colors.blueGrey),
        _buildChip(Icons.monetization_on_outlined,
            NumberParser().toSocialMediaString(points), Colors.orange),
      ],
    );
  }

  Widget _buildDataShimmerChips() {
    return Wrap(
      direction: Axis.horizontal,
      spacing: 8.0,
      runSpacing: 8.0,
      children: [
        _buildChipShimmer(Icons.shopping_bag, Colors.green),
        _buildChipShimmer(Icons.data_exploration, ProjectColors.primary),
        _buildChipShimmer(Icons.remove_red_eye, Colors.blueGrey),
        _buildChipShimmer(Icons.monetization_on_outlined, Colors.orange),
      ],
    );
  }

  Container _buildChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(width: 1, color: Colors.grey)),
      child: IntrinsicWidth(
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: color,
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              text,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }
}

Container _buildChipShimmer(IconData icon, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
    decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(width: 1, color: Colors.grey)),
    child: IntrinsicWidth(
      child: Row(
        children: [
          Icon(
            icon,
            size: 22,
            color: color,
          ),
          const SizedBox(
            width: 8,
          ),
          Shimmer.fromColors(
            baseColor: const Color(0xffd3d3d3),
            highlightColor: const Color(0x0fe6e1e1),
            child: Container(
              width: 30,
              height: 20,
              decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
            ),
          )
        ],
      ),
    ),
  );
}
