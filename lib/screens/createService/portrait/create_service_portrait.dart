import 'dart:developer';
import 'dart:io';

import 'package:astroverse/controllers/auth_controller.dart';
import 'package:astroverse/controllers/location_controller.dart';
import 'package:astroverse/controllers/service_controller.dart';
import 'package:astroverse/models/service.dart';
import 'package:astroverse/res/colors/project_colors.dart';
import 'package:astroverse/res/img/images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CreateServicePortrait extends StatelessWidget {
  final BoxConstraints cons;
  static const _list = {
    'palm reading': 0,
    'item': 1,
    'job prediction': 2,
    'marriage prediction': 3
  };

  const CreateServicePortrait({super.key, required this.cons});

  @override
  Widget build(BuildContext context) {
    final ServiceController service = Get.find();
    final LocationController loc = Get.find();
    final AuthController auth = Get.find();
    final body = TextEditingController();
    final title = TextEditingController();
    final place = TextEditingController();
    final price =
        TextEditingController(text: service.price.value.toInt().toString());

    price.addListener(() {
      service.price.value =
          price.value.text.isNotEmpty ? double.parse(price.value.text) : 0.00;
      service.formValid.value = validate(
          title, body, price, service.image.value, service.selectedItem.value);
    });

    place.addListener(() {
      service.formValid.value = validate(
          title, body, price, service.image.value, service.selectedItem.value);
    });

    title.addListener(() {
      service.formValid.value = validate(
          title, body, price, service.image.value, service.selectedItem.value);
    });
    return WillPopScope(
      onWillPop: () async {
        service.price.value = 0.00;
        service.formValid.value = false;
        service.image.value = null;
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            height: cons.maxHeight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Create\na Gig',style: TextStyle(fontSize: 30,color: ProjectColors.lightBlack , fontWeight: FontWeight.bold),),
                const SizedBox(height: 8,),
                Expanded(
                  child: SingleChildScrollView(
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              child: image,
                            ),
                            onTap: () async {
                              service.selectImage();
                            },
                          );
                        }),
                        const SizedBox(
                          height: 30,
                        ),
                        const Text(
                          "Let's set a title",
                          style: TextStyle(
                              color: ProjectColors.lightBlack,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: title,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                          decoration: const InputDecoration(
                              labelText: 'title', border: OutlineInputBorder()),
                          maxLines: 1,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "What kind of product is it?",
                          style: TextStyle(
                              color: ProjectColors.lightBlack,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        DropdownMenu(
                            width: 190,
                            initialSelection: _list.keys.first,
                            inputDecorationTheme: const InputDecorationTheme(
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)))),
                            dropdownMenuEntries: List.generate(
                                _list.length,
                                (i) => DropdownMenuEntry(
                                    value: _list.keys.toList()[i],
                                    label: _list.keys.toList()[i])),
                            onSelected: (e) {
                              if (e == null) {
                                service.selectedItem.value = 0;
                              } else {
                                service.selectedItem.value = _list[e]!;
                              }
                              log(service.selectedItem.value.toString(),
                                  name: 'DROPDOWN');
                            }),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Describe your product",
                          style: TextStyle(
                              color: ProjectColors.lightBlack,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: body,
                          style: const TextStyle(fontWeight: FontWeight.w400),
                          decoration: const InputDecoration(
                              labelText: 'body', border: OutlineInputBorder()),
                          maxLines: 4,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Obx(() => Visibility(
                              visible: service.selectedItem.value == 1,
                              child: const Text(
                                "Where will you sell this product",
                                style: TextStyle(
                                    color: ProjectColors.lightBlack,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        Obx(() => Visibility(
                            visible: service.selectedItem.value == 1,
                            child: TextField(
                              controller: place,
                              decoration: const InputDecoration(
                                  labelText: 'Address',
                                  border: OutlineInputBorder()),
                              maxLines: 2,
                            ))),
                        Obx(() => Visibility(
                            visible: service.selectedItem.value == 1,
                            child: const SizedBox(
                              height: 30,
                            ))),
                        const Text(
                          "Set a Price",
                          style: TextStyle(
                              color: ProjectColors.lightBlack,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: price,
                          decoration: const InputDecoration(
                            labelText: 'price',
                            border: OutlineInputBorder(),
                            prefixText: '  ₹  ',
                            prefixStyle: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          maxLines: 1,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, wordSpacing: 10),
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() => MaterialButton(
                          disabledColor: Colors.grey.shade500,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 60, vertical: 12),
                          onPressed: service.formValid.isTrue
                              ? () {
                                  var location = loc.location.value!;
                                  var user = auth.user.value!;
                                  log(' post is valid : ${validate(title, body, price, service.image.value, service.selectedItem.value)}',
                                      name: "SERVICE");
                                  if (!validate(
                                      title,
                                      body,
                                      price,
                                      service.image.value,
                                      service.selectedItem.value)) return;
                                  final res = Service(
                                      price: double.parse(price.value.text),
                                      uses: 0,
                                      lastDate: DateTime(1900).toString(),
                                      lat: location.latitude!,
                                      lng: location.longitude!,
                                      title: title.value.text,
                                      description: body.value.text,
                                      genre: [
                                        _list.keys.toList()[
                                            service.selectedItem.value]
                                      ],
                                      date: DateTime.now(),
                                      place: place.value.text,
                                      imageUrl: '',
                                      authorName: user.name,
                                      authorId: user.uid);
                                  service.postService(res);
                                }
                              : null,
                          color: ProjectColors.lightBlack,
                          child: const Text(
                            'Done',
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        )),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 35, vertical: 12),
                      child: Obx(() => Text("₹ ${service.price.value.toInt()}",
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 16))),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

bool validate(TextEditingController title, TextEditingController body,
    TextEditingController price, XFile? image, int i) {
  final t = title.value.text;
  final b = body.value.text;

  if (t.isEmpty || b.isEmpty) return false;
  if (i == 1 && image == null) return false;
  return true;
}
