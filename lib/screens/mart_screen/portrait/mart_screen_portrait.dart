import 'dart:developer';

import 'package:astroverse/components/load_more_button.dart';
import 'package:astroverse/components/mart_item.dart';
import 'package:astroverse/components/search_box.dart';
import 'package:astroverse/controllers/location_controller.dart';
import 'package:astroverse/controllers/service_controller.dart';
import 'package:astroverse/models/service.dart';
import 'package:astroverse/res/colors/project_colors.dart';
import 'package:astroverse/routes/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

import '../../../controllers/auth_controller.dart';

class MartScreenPortrait extends StatelessWidget {
  final BoxConstraints cons;
  static const chipNames = [
    'item',
    'job prediction',
    'palm reading',
    'marriage prediction'
  ];

  const MartScreenPortrait({super.key, required this.cons});

  @override
  Widget build(BuildContext context) {
    final AuthController auth = Get.find();
    final ServiceController service = Get.find();
    final LocationController location = Get.find();

    service.selectedItem.listen((p0) {
      log(p0.toString(), name: "on select");
    });

    service.currPage.value = 0;

    service.searchController.addListener(() {
      service.searchText.value = service.searchController.value.text;
    });

    loadMore() => service.fetchMoreServicesByLocation(auth.user.value!.uid,
        location.location.value!.geoPointFromLocationData()!, (p0) => null);

    if (auth.bankDetails.value == null) {
      auth.startBankDetailsStream(auth.user.value!.uid);
    }

    if (auth.user.value != null) {
      service.fetchMyServices(auth.user.value!.uid);
      service.fetchServiceByLocation(
        auth.user.value!.uid,
        (e) {},
        location.location.value!.geoPointFromLocationData()!,
      );
    }

    final pageController = PageController(initialPage: 0);
    pageController.addListener(() {
      service.currPage.value = pageController.page!.toInt();
    });

    return Scaffold(
      backgroundColor: ProjectColors.greyBackground,
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: (auth.user.value?.astro == true)
          ? Container(
              margin: const EdgeInsets.only(bottom: 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    heroTag: 'hero1+fab',
                    onPressed: () {
                      if (auth.user.value == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("user data not found")));
                        return;
                      }
                      if (auth.bankDetails.value == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("bank details not available")));
                        return;
                      }
                      if (service.currPage.value == 0) {
                        pageController.animateToPage(1,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.linear);
                      } else {
                        pageController.animateToPage(0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.linear);
                      }
                    },
                    backgroundColor: Colors.lightBlue.shade300,
                    elevation: 0,
                    child: const Icon(
                      Icons.switch_access_shortcut,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  FloatingActionButton(
                    heroTag: 'hero2+fab',
                    onPressed: () {
                      if (auth.user.value == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("user data not found")));
                        return;
                      }
                      if (auth.bankDetails.value == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("bank details not available")));
                        return;
                      }
                      return _postItemScreen();
                    },
                    backgroundColor: Colors.lightBlue.shade300,
                    elevation: 0,
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: PageView(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await service.onRefresh(
                          auth.user.value!.uid,
                          (p0) => null,
                          location.location.value!.geoPointFromLocationData()!);
                      return;
                    },
                    child: Stack(
                      children: [
                        Obx(() {
                          var list = <Service>[];
                          final st = service.searchText.value;
                          for (var element in service.serviceList) {
                            if ((!element.title.contains(st)) &&
                                st.isNotEmpty) {
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
                            itemCount: len + 2,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return const SizedBox(
                                  height: 100,
                                );
                              }
                              if (index == len + 1) {
                                return service.morePostsToLoad.isTrue
                                    ? LoadMoreButton(
                                        cons: cons, loadMore: loadMore)
                                    : const SizedBox(
                                        height: 0,
                                      );
                              }
                              return Row(
                                children: [
                                  Expanded(
                                      child: MartItem(
                                          item: list[2 * (index - 1)])),
                                  (2 * (index - 1) + 1 < list.length)
                                      ? Expanded(
                                          child: MartItem(
                                              item: list[2 * (index - 1) + 1]))
                                      : const Expanded(
                                          child: SizedBox(
                                          width: 50,
                                        )),
                                ],
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              height: 30,
                            ),
                          );
                        }),
                        Column(
                          children: [
                            SearchBox(
                              controller: service.searchController,
                              bottom: SizedBox(
                                height: 50,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    Obx(() =>
                                        buildFilterChip(chipNames[0], (e) {
                                          e
                                              ? service.selectedItem.value = 1
                                              : service.selectedItem.value = 0;
                                        }, service.selectedItem.value == 1)),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Obx(() =>
                                        buildFilterChip(chipNames[1], (e) {
                                          e
                                              ? service.selectedItem.value = 2
                                              : service.selectedItem.value = 0;
                                        }, service.selectedItem.value == 2)),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Obx(() =>
                                        buildFilterChip(chipNames[2], (e) {
                                          e
                                              ? service.selectedItem.value = 3
                                              : service.selectedItem.value = 0;
                                        }, service.selectedItem.value == 3)),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Obx(() =>
                                        buildFilterChip(chipNames[3], (e) {
                                          e
                                              ? service.selectedItem.value = 4
                                              : service.selectedItem.value = 0;
                                        }, service.selectedItem.value == 4)),
                                  ],
                                ),
                              ),
                              hint: 'Search in Mart',
                              width: cons.maxWidth * 0.9,
                              bottomSpacing: 5,
                            )
                          ],
                        )
                      ],
                    ),
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
            RefreshIndicator(
              onRefresh: () async {
                service.fetchMyServices(auth.user.value!.uid);
                return;
              },
              child: Obx(() {
                var list = service.myServices;
                return ListView.separated(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final s = list[index];
                    return ListTile(
                      leading: const Icon(Icons.shopping_bag_outlined),
                      title: Text(s.name),
                      onTap: (){
                        Get.toNamed(Routes.myMartItemScreen ,arguments: s);
                      },
                      subtitle: Text(DateFormat.yMMMd().format(DateTime.parse(s.date)),
                    ));
                  },
                  separatorBuilder: (context, index) => const Divider(),
                );
              }),
            ),
          ],
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

extension on LocationData {
  GeoPoint? geoPointFromLocationData() {
    if (latitude == null || longitude == null) return null;
    return GeoPoint(latitude!, longitude!);
  }
}
