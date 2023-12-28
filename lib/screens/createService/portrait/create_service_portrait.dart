import 'dart:developer';
import 'dart:io';

import 'package:astroverse/controllers/auth_controller.dart';
import 'package:astroverse/controllers/location_controller.dart';
import 'package:astroverse/controllers/service_controller.dart';
import 'package:astroverse/models/service.dart';
import 'package:astroverse/res/colors/project_colors.dart';
import 'package:astroverse/res/img/images.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toggle_switch/toggle_switch.dart';

class CreateServicePortrait extends StatelessWidget {
  final BoxConstraints cons;
  static const _list = {
    'palm reading': 0,
    'item': 1,
    'job prediction': 2,
    'marriage prediction': 3
  };
  static const _listIcons = {
    'palm reading': Icon(Icons.back_hand_outlined),
    'item': Icon(Icons.card_giftcard),
    'job prediction': Icon(Icons.work_history_outlined),
    'marriage prediction': Icon(Icons.people_outline)
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
          title,
          body,
          price,
          place,
          service.image.value,
          service.selectedItem.value,
          service.selectedMode.value);
    });

    place.addListener(() {
      service.formValid.value = validate(
          title,
          body,
          price,
          place,
          service.image.value,
          service.selectedItem.value,
          service.selectedMode.value);
    });

    title.addListener(() {
      service.formValid.value = validate(
          title,
          body,
          price,
          place,
          service.image.value,
          service.selectedItem.value,
          service.selectedMode.value);
    });
    final cost = _getPriceForRange(service.selectedRange.value);
    final userCoins = auth.user.value!.coins;
    if (userCoins < cost) {
      service.formValid.value &= false;
    } else {
      service.formValid.value &= true;
    }
    return WillPopScope(
      onWillPop: () async {
        service.resetServiceCreationValues();
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
                const Text(
                  'Create\na Gig',
                  style: TextStyle(
                      fontSize: 30,
                      color: ProjectColors.lightBlack,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 8,
                ),
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
                              service.selectImage((e) {
                                service.formValid.value &= e != null;
                              });
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
                          height: 30,
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
                                    leadingIcon: _listIcons.values.toList()[i],
                                    value: _list.keys.toList()[i],
                                    label: _list.keys.toList()[i])),
                            onSelected: (e) {
                              if (e == null) {
                              } else {
                                service.selectedItem.value = _list[e]!;
                                if(_list[e]==1) service.selectedRange.value = 0;
                              }
                              log(service.selectedItem.value.toString(),
                                  name: 'DROPDOWN');
                            }),
                        const SizedBox(
                          height: 30,
                        ),
                        const Text(
                          "Preferred mode of delivery",
                          style: TextStyle(
                              color: ProjectColors.lightBlack,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ToggleSwitch(
                          initialLabelIndex: 0,
                          labels: const ["in-person", "chat", "call"],
                          totalSwitches: 3,
                          minWidth: 100,
                          inactiveBgColor: ProjectColors.greyBackground,
                          centerText: true,
                          cornerRadius: 15,
                          customTextStyles: const [
                            TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 10),
                            TextStyle(fontWeight: FontWeight.w600),
                            TextStyle(fontWeight: FontWeight.w600),
                          ],
                          radiusStyle: true,
                          icons: const [
                            Icons.person_outline,
                            Icons.messenger_outline,
                            Icons.call_outlined
                          ],
                          activeBgColor: const [Colors.lightBlue],
                          borderWidth: 5,
                          onToggle: (e) {
                            if (e == null) {
                              service.selectedMode.value = 0;
                            } else {
                              service.selectedMode.value = e;
                            }
                            log(service.selectedMode.value.toString(),
                                name: 'MODE');

                            service.formValid.value = validate(
                                title,
                                body,
                                price,
                                place,
                                service.image.value,
                                service.selectedItem.value,
                                service.selectedMode.value);
                          },
                        ),
                        Obx(() {
                          return Visibility(
                            visible: service.selectedItem.value == 1 &&
                                service.selectedMode.value != 0,
                            child: const Text(
                              "in-person requires",
                              style: TextStyle(color: Colors.red),
                            ),
                          );
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
                        Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "local",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    "city",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    "state",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    "all",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            Obx(() {
                              return Slider(
                                divisions: 3,
                                value: service.selectedItem.value == 1
                                    ? 0
                                    : service.selectedRange.value,
                                onChanged: service.selectedItem.value == 1
                                    ? null
                                    : (e) {
                                        service.selectedRange.value = e;
                                        final cost = _getPriceForRange(e);
                                        final userCoins =
                                            auth.user.value!.coins;
                                        if (userCoins < cost) {
                                          service.formValid.value &= false;
                                        } else {
                                          service.formValid.value &= true;
                                        }
                                      },
                                min: 0,
                                max: 3,
                                label: "range",
                                thumbColor: Colors.blue,
                              );
                            }),
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                const Text("coin cost" , style: TextStyle(fontSize: 15 , fontWeight: FontWeight.w600),),
                                const CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  foregroundImage: ProjectImages.singleCoin,
                                ),
                                Obx(() {
                                  final range = service.selectedRange.value;
                                  final userCoins = auth.user.value!.coins;
                                  final cost = _getPriceForRange(range);
                                  return Text(
                                    "x$cost",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: userCoins < cost
                                            ? Colors.red
                                            : ProjectColors.lightBlack),
                                  );
                                }),
                              ],
                            )
                          ],
                        ),
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
                                  log(
                                      ' post is valid : ${validate(
                                        title,
                                        body,
                                        price,
                                        place,
                                        service.image.value,
                                        service.selectedItem.value,
                                        service.selectedMode.value,
                                      )}',
                                      name: "SERVICE");
                                  if (!validate(
                                      title,
                                      body,
                                      price,
                                      place,
                                      service.image.value,
                                      service.selectedItem.value,
                                      service.selectedMode.value)) return;
                                  final res = Service(
                                      price: double.parse(price.value.text),
                                      uses: 0,
                                      lastDate: DateTime(1900),
                                      lat: location.latitude!,
                                      lng: location.longitude!,
                                      title: title.value.text,
                                      description: body.value.text,
                                      genre: [
                                        _list.keys.toList()[
                                            service.selectedItem.value]
                                      ],
                                      deliveryMethod:
                                          service.selectedMode.value,
                                      geoHash: "",
                                      active: true,
                                      featured: user.featured,
                                      range:
                                          service.selectedRange.value.toInt(),
                                      date: DateTime.now(),
                                      place: place.value.text,
                                      imageUrl: '',
                                      views: 0,
                                      authorName: user.name,
                                      authorId: user.uid);
                                  service.postService(
                                      res,
                                      _getPriceForRange(
                                          service.selectedRange.value), (e) {
                                    if (e.isSuccess) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text("posted")));
                                    } else {
                                      e = e as Failure<Service>;
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content:
                                                  Text("failed : ${e.error}")));
                                    }
                                    price.clear();
                                    title.clear();
                                    body.clear();
                                    place.clear();
                                  });
                                }
                              : null,
                          color: ProjectColors.lightBlack,
                          child: service.loading.value == 1
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 1.5,
                                  ),
                                )
                              : const Text(
                                  'Done',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white),
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

  int _getPriceForRange(double range) => ((range) * 15).toInt();
}

bool validate(
  TextEditingController title,
  TextEditingController body,
  TextEditingController price,
  TextEditingController address,
  XFile? image,
  int productType,
  int mode,
) {

  final t = title.value.text;
  final b = body.value.text;
  final add = address.value.text;

  if (t.isEmpty || b.isEmpty) return false;
  if (productType == 1 && add.isEmpty) return false;
  if (productType == 1 && image == null) return false;
  if (productType == 1 && mode != 0) return false;
  return true;
}
