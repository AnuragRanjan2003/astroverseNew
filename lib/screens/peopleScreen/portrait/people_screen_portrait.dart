import 'dart:developer';

import 'package:astroverse/components/astrologer_item.dart';
import 'package:astroverse/components/message_screen.dart';
import 'package:astroverse/controllers/astrologer_controller.dart';
import 'package:astroverse/controllers/auth_controller.dart';
import 'package:astroverse/models/user.dart';
import 'package:astroverse/res/colors/project_colors.dart';
import 'package:astroverse/res/img/images.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PeopleScreenPortrait extends StatelessWidget {
  final BoxConstraints cons;

  const PeopleScreenPortrait({super.key, required this.cons});

  @override
  Widget build(BuildContext context) {
    final AuthController auth = Get.find();
    final TextEditingController search = TextEditingController();
    final AstrologerController astro = Get.put(AstrologerController());
    if(auth.user.value!=null){
      astro.fetchAstrologers(const GeoPoint(0, 0),auth.user.value!.uid);
    }


    search.addListener(() {
      astro.searchText.value = search.value.text;
    });

    astro.list.listen((p0) {
      log("$p0");
    });
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 12),
              child: TextField(
                controller: search,
                style: const TextStyle(fontSize: 13),
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search_sharp),
                    hintStyle: TextStyle(fontSize: 13),
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    hintText: "Search for Astrologers"),
              ),
            ),
            Expanded(child: Obx(
              () {
                var list = _filteredList(astro.list, astro.searchText.value);
                if(list.isEmpty) return const MessageScreen(image:ProjectImages.emptyBox,text: 'nothing to show');
                return ListView.separated(
                    itemBuilder: (context, index) => index != list.length
                        ? AstrologerItem(user: list[index])
                        : astro.moreUsers.value
                            ? OutlinedButton(
                                onPressed: () {
                                  astro.fetchMoreAstrologers(
                                      const GeoPoint(0, 0),auth.user.value!.uid);
                                },
                                child: const Text(
                                  'load more',
                                  style: TextStyle(
                                      color: ProjectColors.lightBlack),
                                ))
                            : const SizedBox.shrink(),
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: list.length + 1);
              },
            )),
          ],
        ),
      )),
    );
  }
}

List<User> _filteredList(List<User> list, String s) {
  if(s.isEmpty) return list;
  var l = <User>[];
  for (var it in list) {
    if (it.name.contains(s)) l.add(it);
  }
  return l;
}
