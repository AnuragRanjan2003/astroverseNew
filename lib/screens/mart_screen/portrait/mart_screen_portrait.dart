import 'dart:developer';

import 'package:astroverse/components/mart_item.dart';
import 'package:astroverse/controllers/service_controller.dart';
import 'package:astroverse/models/service.dart';
import 'package:astroverse/res/colors/project_colors.dart';
import 'package:astroverse/routes/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controller.dart';

class MartScreenPortrait extends StatelessWidget {
  final BoxConstraints cons;
  static const chipNames = ['item', 'job prediction', 'palm reading'];

  const MartScreenPortrait({super.key, required this.cons});

  @override
  Widget build(BuildContext context) {
    final AuthController auth = Get.find();
    final ServiceController service = Get.find();
    service.fetchServiceByGenreAndPage([], auth.user.value!.uid, (e) {});
    final searchController = TextEditingController(text: "");
    service.selectedItem.listen((p0) {
      log(p0.toString(), name: "on select");
    });

    searchController.addListener(() {
      service.searchText.value = searchController.value.text;
    });

    return Scaffold(
      backgroundColor: ProjectColors.background,
      floatingActionButton: (auth.user.value?.astro == true)
          ? FloatingActionButton(
              onPressed: _postItemScreen,
              backgroundColor: Colors.lightBlue.shade300,
              elevation: 0,
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            )
          : null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  controller: searchController,
                  style: const TextStyle(fontSize: 13),
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search_sharp),
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      hintStyle: TextStyle(fontSize: 13),
                      hintText: "Search in Mart"),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 70,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Obx(() => buildFilterChip(chipNames[0], (e) {
                          e
                              ? service.selectedItem.value = 1
                              : service.selectedItem.value = 0;
                        }, service.selectedItem.value == 1)),
                    const SizedBox(
                      width: 5,
                    ),
                    Obx(() => buildFilterChip(chipNames[1], (e) {
                          e
                              ? service.selectedItem.value = 2
                              : service.selectedItem.value = 0;
                        }, service.selectedItem.value == 2)),
                    const SizedBox(
                      width: 5,
                    ),
                    Obx(() => buildFilterChip(chipNames[2], (e) {
                          e
                              ? service.selectedItem.value = 3
                              : service.selectedItem.value = 0;
                        }, service.selectedItem.value == 3)),
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await service
                        .onRefresh([], auth.user.value!.uid, (p0) => null);
                    return;
                  },
                  child: Obx(() {
                    var list = <Service>[];
                    final st = service.searchText.value;
                    for (var element in service.serviceList) {
                      if ((!element.title.contains(st)) && st.isNotEmpty) {
                        continue;
                      }
                      if (service.selectedItem.value == 0) {
                        list.add(element);
                      } else if (element.genre.contains(
                          chipNames[service.selectedItem.value - 1])) {
                        list.add(element);
                      }
                    }

                    int len = list.length.isEven
                        ? list.length ~/ 2
                        : (list.length + 1) ~/ 2;
                    return ListView.separated(
                      itemCount: len + 1,
                      itemBuilder: (context, index) {
                        if (index == len) {
                          return service.morePostsToLoad.isTrue
                              ? OutlinedButton(
                                  onPressed: () {
                                    service.fetchMoreServices(
                                        auth.user.value!.uid, [], (p0) => null);
                                  },
                                  child: const Text("load more"))
                              : const SizedBox(
                                  height: 0,
                                );
                        }
                        return Row(
                          children: [
                            Expanded(child: MartItem(item: list[2 * index])),
                            (2 * index + 1 < list.length)
                                ? Expanded(
                                    child: MartItem(item: list[2 * index + 1]))
                                : const Expanded(
                                    child: SizedBox(
                                    width: 50,
                                  )),
                          ],
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 30,
                      ),
                    );
                  }),
                ),
              ),
              Obx(() => Visibility(
                  visible: service.loadingMorePosts.isTrue,
                  child: const SizedBox(
                      width: 40,
                      height: 40,
                      child: CupertinoActivityIndicator()))),
            ],
          ),
        ),
      ),
    );
  }

  FilterChip buildFilterChip(
      String label, void Function(bool) onSelect, bool selected) {
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
            fontSize: 12, color: selected ? Colors.white : Colors.black),
      ),
      onSelected: onSelect,
      selected: selected,
      backgroundColor: Colors.white,
      checkmarkColor: Colors.white,
      selectedColor: Colors.lightBlue.shade300,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
    );
  }

  void _postItemScreen() => Get.toNamed(Routes.createServiceScreen);
}
