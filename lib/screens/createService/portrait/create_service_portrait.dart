import 'dart:io';

import 'package:astroverse/controllers/auth_controller.dart';
import 'package:astroverse/controllers/location_controller.dart';
import 'package:astroverse/controllers/service_controller.dart';
import 'package:astroverse/models/service.dart';
import 'package:astroverse/res/img/images.dart';
import 'package:astroverse/res/textStyles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateServicePortrait extends StatelessWidget {
  final BoxConstraints cons;
  static const _list = ['item 1', 'item 2', 'item 3'];

  const CreateServicePortrait({super.key, required this.cons});

  @override
  Widget build(BuildContext context) {
    final ServiceController service = Get.find();
    final LocationController loc = Get.find();
    final AuthController auth = Get.find();
    final body = TextEditingController();
    final title = TextEditingController();
    final place = TextEditingController();
    final price = TextEditingController(text: '0');
    final category = TextEditingController();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 0 , bottom: 10),
            height: cons.maxHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  var image = const Image(
                    image: ProjectImages.planet,
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                  );
                  if (service.image.value != null) {
                    image = Image.file(
                      File(service.image.value!.path),
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    );
                  }
                  return GestureDetector(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      child: image,
                    ),
                    onTap: () async {
                      service.selectImage();
                    },
                  );
                }),
                TextField(
                  controller: title,
                  decoration: const InputDecoration(
                      labelText: 'title', border: OutlineInputBorder()),
                  maxLines: 1,
                ),
                DropdownMenu(
                    controller: category,
                    enableSearch: true,
                    width: 190,
                    inputDecorationTheme: const InputDecorationTheme(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)))),
                    label: const Text('category'),
                    dropdownMenuEntries: List.generate(
                        _list.length,
                        (i) =>
                            DropdownMenuEntry(value: _list[i], label: _list[i])),
                    onSelected: (e) {
                      service.isItem.value = e == _list[0];
                    }),
                TextField(
                  controller: body,
                  decoration: const InputDecoration(
                      labelText: 'body', border: OutlineInputBorder()),
                  maxLines: 4,
                ),
                Obx(() => Visibility(
                    visible: service.isItem.isFalse,
                    child: TextField(
                      controller: place,
                      decoration: const InputDecoration(
                          labelText: 'Address', border: OutlineInputBorder()),
                      maxLines: 2,
                    ))),
                TextField(
                  controller: price,
                  decoration: const InputDecoration(
                      labelText: 'price',
                      border: OutlineInputBorder(),
                      prefixText: '₹'),
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                ),
                MaterialButton(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  onPressed: () {
                    var location = loc.location.value!;
                    var user = auth.user.value!;
                    final res = Service(
                        price: double.parse(price.value.text),
                        uses: 0,
                        lastDate: DateTime(0),
                        lat: location.latitude!,
                        lng: location.longitude!,
                        title: "",
                        description: body.value.text,
                        genre: [category.value.text],
                        date: DateTime.now(),
                        place: place.value.text,
                        imageUrl: '',
                        authorName: user.name,
                        authorId: user.uid);
                    service.postService(res);
                  },
                  color: Colors.black,
                  child: Text(
                    'Post',
                    style: TextStyleDark().onButton,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
