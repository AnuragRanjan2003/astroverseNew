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
              const SizedBox(
                height: 8,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: 3,
                  itemBuilder: (context, index) => MartItem(item: dummy),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _postItemScreen() => Get.toNamed(Routes.createServiceScreen);
}
