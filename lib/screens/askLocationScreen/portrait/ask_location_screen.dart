import 'dart:developer';

import 'package:astroverse/components/glass_morph_container.dart';
import 'package:astroverse/controllers/location_controller.dart';
import 'package:astroverse/res/strings/other_strings.dart';
import 'package:astroverse/res/textStyles/text_styles.dart';
import 'package:astroverse/screens/astroSignUp/portrait/astro_signup_portrait.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

import '../../../models/user.dart';
import '../../../res/colors/project_colors.dart';
import '../../../res/decor/button_decor.dart';
import '../../../res/dims/global.dart';
import '../../../res/img/images.dart';
import '../../../routes/routes.dart';

class AskLocationPortrait extends StatelessWidget {
  final BoxConstraints cons;

  const AskLocationPortrait({super.key, required this.cons});

  @override
  Widget build(BuildContext context) {
    final Parcel parcel = Get.arguments;
    final User? user = parcel.data;
    final google = parcel.google;
    final LocationController location = Get.find();

    log(user.toString(), name: "USER");
    final TextEditingController upi = TextEditingController();
    if (user == null) Get.snackbar("Error", "unexpected error");
    return Scaffold(
        backgroundColor: Colors.blue.shade100,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(top: 10),
            height: cons.maxHeight,
            width: cons.maxWidth,
            child: Stack(
              children: [
                Positioned(
                  top: Get.height * 0.2 - 50,
                  left: Get.width * 0.5 - 150,
                  child: const Image(
                    image: ProjectImages.location,
                    height: 300,
                    width: 300,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: GlassMorphContainer(
                    blur: 20,
                    borderRadius: 20,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    opacity: 0.7,
                    child: IntrinsicHeight(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: GlobalDims.horizontalPadding,
                            vertical: 30),
                        decoration: const BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(40),
                                topLeft: Radius.circular(40))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Verify your Location",
                              style: TextStylesLight().bodyBold,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              OtherStrings.locationText,
                              style:
                                  TextStyle(fontSize: 13, color: Colors.black),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 0.5,
                                      color: ProjectColors.disabled),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15)),
                                  color: Colors.white),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 13),
                              child: Wrap(
                                spacing: 12,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                alignment: WrapAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.my_location_outlined,
                                    color: Colors.blue,
                                  ),
                                  FutureBuilder(
                                    future: getAddress(
                                        location.location.value!.latitude,
                                        location.location.value!.longitude),
                                    builder: (context, snapshot) => Text(
                                      snapshot.data.toString(),
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            MaterialButton(
                              onPressed: () {
                                log(upi.value.text, name: "UPI");
                                user!.location = location.location.value!
                                    .geoPointFromLocationData();

                                Get.toNamed(Routes.phoneAuth,
                                    arguments:
                                        Parcel(data: user, google: google));
                              },
                              shape: ButtonDecors.filled,
                              color: Colors.blue,
                              disabledColor: ProjectColors.disabled,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              child: const Wrap(
                                spacing: 10,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    "Confirm Location",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

extension on LocationData {
  GeoPoint? geoPointFromLocationData() {
    if (latitude == null || longitude == null) return null;
    return GeoPoint(latitude!, longitude!);
  }
}

Future<String> getAddress(double? lat, double? lng) async {
  if (lat == null || lng == null) return "";
  final geoCode = GeoCode();
  Address address =
      await geoCode.reverseGeocoding(latitude: lat, longitude: lng);
  return "${address.streetAddress} , ${address.postal}";
}
