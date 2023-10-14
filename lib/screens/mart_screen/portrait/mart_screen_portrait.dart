import 'package:astroverse/components/mart_item.dart';
import 'package:astroverse/controllers/service_controller.dart';
import 'package:astroverse/res/colors/project_colors.dart';
import 'package:astroverse/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controller.dart';
import '../../../models/service.dart';

class MartScreenPortrait extends StatelessWidget {
  final BoxConstraints cons;

  const MartScreenPortrait({super.key, required this.cons});

  @override
  Widget build(BuildContext context) {
    final AuthController auth = Get.find();
    final ServiceController service = Get.find();
    service.fetchServiceByGenreAndPage([], auth.user.value!.uid);
    final gridController = ScrollController();
    final dummy = Service(
        price: 100,
        uses: 0,
        lastDate: DateTime.parse("2020-10-09T20:54:17.008199"),
        lat: 0.0,
        lng: 0.0,
        place: "",
        title: "try",
        description: "try ,try",
        genre: [],
        date: DateTime.now(),
        imageUrl: "",
        authorName: "12345",
        authorId: "12345");
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
              const TextField(
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search_sharp),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    hintText: "Search"),
              ),
              Row(
                children: [
                  buildFilterChip('item 1'),
                  const SizedBox(
                    width: 5,
                  ),
                  buildFilterChip('item 2'),
                  const SizedBox(
                    width: 5,
                  ),
                  buildFilterChip('item 3'),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Expanded(
                child: Obx(() {
                  final list = service.serviceList.value;
                  return GridView.builder(
                    itemCount: list.length,
                    controller: gridController,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio: 0.9/2,
                      crossAxisCount: 2),
                    itemBuilder: (context, index) => MartItem(item: list[index]),

                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  FilterChip buildFilterChip(String label) {
    return FilterChip(
      label: Text(label),
      onSelected: (_) {},
      backgroundColor: Colors.white,
      checkmarkColor: Colors.white,
      selectedColor: Colors.lightBlue.shade300,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30))),
    );
  }

  void _postItemScreen() => Get.toNamed(Routes.createServiceScreen);
}
