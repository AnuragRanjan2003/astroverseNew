import 'package:astroverse/components/glass_morph_container.dart';
import 'package:astroverse/components/load_more_button.dart';
import 'package:astroverse/components/purchase_item.dart';
import 'package:astroverse/components/search_box.dart';
import 'package:astroverse/controllers/auth_controller.dart';
import 'package:astroverse/controllers/purchase_controller.dart';
import 'package:astroverse/res/colors/project_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PurchasesPortrait extends StatelessWidget {
  final BoxConstraints cons;
  static const _searchWidth = 0.95;

  const PurchasesPortrait({super.key, required this.cons});

  @override
  Widget build(BuildContext context) {
    final scroll = ScrollController();
    final scrollForSold = ScrollController();
    final PurchaseController purchase = Get.put(PurchaseController());
    final AuthController auth = Get.find();
    final user = auth.user.value!;
    purchase.fetchPurchases(user.uid);
    purchase.fetchSoldItems(user.uid);
    var theme = Theme.of(context);

    purchase.searchController.addListener(() {
      purchase.searchText.value = purchase.searchController.value.text;
    });

    purchase.searchControllerForSold.addListener(() {
      purchase.searchTextForSold.value =
          purchase.searchControllerForSold.value.text;
    });

    return DefaultTabController(
        length: 2,
        child: Scaffold(
            backgroundColor: ProjectColors.greyBackground,
            body: Stack(
              children: [
                TabBarView(
                  children: [
                    Center(
                      child: buildBought(
                          purchase, scroll, auth, purchase.searchController),
                    ),
                    Center(
                        child: buildSold(
                      purchase,
                      scrollForSold,
                      auth,
                      purchase.searchControllerForSold,
                    ))
                  ],
                ),
                GlassMorphContainer(
                  borderRadius: 20,
                  blur: 10,
                  opacity: 0.5,
                  margin: EdgeInsets.only(
                      left: 10, right: cons.maxWidth * 0.4, top: 10),
                  child: buildTabBar(theme),
                )
              ],
            )));
  }

  Container buildTabBar(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.only(left: 8, top: 5, bottom: 5, right: 8),
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
            indicatorPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 2),
            indicator: BoxDecoration(
                color: ProjectColors.primary,
                borderRadius: BorderRadius.all(Radius.circular(15))),
            indicatorColor: Colors.transparent,
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Colors.white,
            tabs: [
              Tab(
                text: 'bought',
              ),
              Tab(
                text: 'sold',
              ),
            ]),
      ),
    );
  }

  Stack buildBought(PurchaseController purchase, ScrollController scroll,
      AuthController auth, TextEditingController searchText) {
    return Stack(children: [
      Obx(() {
        final list = [];
        final search = purchase.searchText.value;
        for (var element in purchase.purchaseList) {
          if (element.itemName.contains(search) || search == "") {
            list.add(element);
          }
        }
        return Padding(
          padding: const EdgeInsets.only(left: 5, right: 5, top: 10),
          child: ListView.separated(
            controller: scroll,
            itemBuilder: (context, index) {
              if (index == 0) {
                return const SizedBox(
                  height: 130,
                );
              } else if (index == list.length + 1) {
                return Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: cons.maxWidth * 0.2),
                  child: MaterialButton(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      onPressed: () {
                        purchase.fetchMorePurchases(auth.user.value!.uid);
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
                              color: ProjectColors.primary,
                              size: 18,
                            )
                          ])),
                );
              } else if (index == list.length + 2) {
                return const SizedBox(
                  height: 200,
                );
              } else {
                return PurchaseItem(purchase: list[index - 1]);
              }
            },
            itemCount: list.length + 3,
            separatorBuilder: (context, index) => const SizedBox(
              height: 10,
            ),
          ),
        );
      }),
      Positioned(
        top: 70,
        child: SearchBox(
          controller: searchText,
          hint: 'Search for "Prediction"',
          width: cons.maxWidth * _searchWidth,
        ),
      )
    ]);
  }

  Stack buildSold(PurchaseController purchase, ScrollController scroll,
      AuthController auth, TextEditingController searchText) {
    loadMore() =>
      purchase.fetchMoreSoldItems(auth.user.value!.uid);


    return Stack(children: [
      Obx(() {
        final list = [];
        final search = purchase.searchTextForSold.value;
        for (var element in purchase.soldList) {
          if (element.itemName.contains(search) || search == "") {
            list.add(element);
          }
        }
        return Padding(
          padding: const EdgeInsets.only(left: 5, right: 5, top: 10),
          child: ListView.separated(
            controller: scroll,
            itemBuilder: (context, index) {
              if (index == 0) {
                return const SizedBox(
                  height: 130,
                );
              } else if (index == list.length + 1) {
                return LoadMoreButton(cons: cons, loadMore: loadMore);
              } else {
                return PurchaseItem(purchase: list[index - 1]);
              }
            },
            itemCount: list.length + 2,
            separatorBuilder: (context, index) => const SizedBox(
              height: 10,
            ),
          ),
        );
      }),
      Positioned(
        top: 70,
        child: SearchBox(
            controller: searchText,
            hint: 'Search for "Prediction"',
            width: cons.maxWidth * _searchWidth),
      )
    ]);
  }
}


