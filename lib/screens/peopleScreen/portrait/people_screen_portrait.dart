import 'dart:developer';

import 'package:astroverse/components/astrologer_item.dart';
import 'package:astroverse/components/load_more_button.dart';
import 'package:astroverse/components/message_screen.dart';
import 'package:astroverse/components/search_box.dart';
import 'package:astroverse/controllers/astrologer_controller.dart';
import 'package:astroverse/controllers/auth_controller.dart';
import 'package:astroverse/controllers/location_controller.dart';
import 'package:astroverse/models/user.dart';
import 'package:astroverse/res/colors/project_colors.dart';
import 'package:astroverse/res/img/images.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart' as comet;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

class PeopleScreenPortrait extends StatelessWidget {
  final BoxConstraints cons;

  const PeopleScreenPortrait({super.key, required this.cons});

  @override
  Widget build(BuildContext context) {
    final AuthController auth = Get.find();
    final TextEditingController search = TextEditingController();
    final AstrologerController astro = Get.put(AstrologerController());
    final LocationController location = Get.find();
    if (auth.user.value != null) {
      astro.fetchAstrologers(
          location.location.value!.geoPointFromLocationData()!,
          auth.user.value!.uid);
    }

    search.addListener(() {
      astro.searchText.value = search.value.text;
    });

    astro.list.listen((p0) {
      log("$p0");
    });

    loadMore() {
      astro.fetchMoreAstrologers(
          location.location.value!.geoPointFromLocationData()!,
          auth.user.value!.uid);
    }

    return Scaffold(
      backgroundColor: ProjectColors.greyBackground,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Stack(
          children: [
            Obx(
              () {
                var list = _filteredList(astro.list, astro.searchText.value);
                if (list.isEmpty) {
                  return const MessageScreen(
                      image: ProjectImages.emptyBox, text: 'nothing to show');
                }
                return ListView.separated(
                    itemBuilder: (context, index) {
                      if (index == list.length + 1) {
                        return LoadMoreButton(cons: cons, loadMore: loadMore);
                      } else if (index == 0) {
                        return const SizedBox(
                          height: 70,
                        );
                      } else if (index == list.length + 2) {
                        return const SizedBox(
                          height: 100,
                        );
                      } else {
                        return AstrologerItem(user: list[index - 1]);
                      }
                    },
                    separatorBuilder: (context, index) => const SizedBox(
                          height: 20,
                        ),
                    itemCount: list.length + 3);
              },
            ),
            SearchBox(
                controller: search,
                hint: 'Search for Astrologers',
                width: cons.maxWidth * 0.9),
            Positioned(
              right: 20,
              bottom: 100,
              child: FloatingActionButton(
                onPressed: () {
                  final user = auth.user.value!;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const comet.CometChatConversationsWithMessages()));
                },
                child: const Icon(Icons.history_toggle_off_outlined),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<User> _filteredList(List<User> list, String s) {
  if (s.isEmpty) return list;
  var l = <User>[];
  for (var it in list) {
    if (it.name.contains(s)) l.add(it);
  }
  return l;
}

extension on LocationData {
  GeoPoint? geoPointFromLocationData() {
    if (latitude == null || longitude == null) return null;
    return GeoPoint(latitude!, longitude!);
  }
}
