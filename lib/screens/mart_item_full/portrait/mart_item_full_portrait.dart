import 'dart:developer';

import 'package:astroverse/controllers/auth_controller.dart';
import 'package:astroverse/controllers/service_controller.dart';
import 'package:astroverse/models/service.dart';
import 'package:astroverse/res/colors/project_colors.dart';
import 'package:astroverse/res/img/images.dart';
import 'package:astroverse/res/strings/backend_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MartItemFullPortrait extends StatelessWidget {
  final BoxConstraints cons;

  const MartItemFullPortrait({super.key, required this.cons});

  @override
  Widget build(BuildContext context) {
    final Service? item = Get.arguments;
    final ServiceController service = Get.find();
    final AuthController auth = Get.find();
    final sb = StringBuffer();
    sb.writeAll(item!.genre, ", ");
    log(item.toString(), name: "ITEM");

    service.attachPaymentEventListeners(auth.user.value!, item);

    service.fetchProviderDetails(item.authorId);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          item.imageUrl.isNotEmpty
              ? Hero(
                  tag: "service ${item.id}",
                  child: Image(
                    image: NetworkImage(item.imageUrl),
                    height: cons.maxHeight * 0.45,
                    fit: BoxFit.fitHeight,
                    width: cons.maxWidth,
                  ),
                )
              : Hero(
                  tag: "service ${item.id}",
                  child: Image(
                    image: ProjectImages.planet,
                    height: cons.maxHeight * 0.45,
                    fit: BoxFit.fitHeight,
                    width: cons.maxWidth,
                  ),
                ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    child: Text(
                      item.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        buildChip(
                            '4.4',
                            const Icon(
                              Icons.star,
                              color: Colors.lightGreen,
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        buildChip(
                            item.uses.toString(),
                            const Icon(
                              Icons.data_exploration_outlined,
                              color: Colors.blueAccent,
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        buildChip(
                            item.genre.first,
                            const Icon(
                              Icons.category_outlined,
                              color: Colors.black,
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                    child: Text(
                      sb.toString(),
                      style: const TextStyle(
                          color: ProjectColors.lightBlack,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 35, vertical: 8),
                    child: Text(
                      item.description,
                      style: const TextStyle(
                        color: ProjectColors.lightBlack,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: item.place.isNotEmpty,
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      child: Wrap(
                        children: [
                          Icon(
                            Icons.location_pin,
                            color: ProjectColors.lightBlack,
                          ),
                          Text(
                            'Pickup Address',
                            style: TextStyle(
                                fontSize: 16,
                                color: ProjectColors.lightBlack,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: item.place.isNotEmpty,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 35, vertical: 0),
                      child: Text(
                        item.place,
                        style: const TextStyle(
                          color: ProjectColors.lightBlack,
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    child: Wrap(
                      children: [
                        Icon(
                          Icons.info,
                          color: ProjectColors.lightBlack,
                          size: 22,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Details',
                          style: TextStyle(
                              fontSize: 16,
                              color: ProjectColors.lightBlack,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  buildRow('provider', item.authorName, Icons.person_2),
                  buildRow(
                      'date',
                      DateFormat.yMMMd().format(item.date).toString(),
                      Icons.date_range),
                  buildRow(
                      'uses', item.uses.toString(), Icons.data_thresholding),
                  buildRow('likes', item.upVotes.toString(), Icons.favorite),
                ],
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Obx(() {
                final user = auth.user.value;
                final providerState = service.serviceProvider.value;
                log(providerState.toString(), name: "PROVIDER IN BUTTON");
                return MaterialButton(
                  onPressed: (user == null ||
                          service.paymentLoading.isTrue ||
                          providerState != BackEndStrings.providerFound)
                      ? null
                      : () async {
                          service.makePayment(item, user.phNo, user.email);
                        },
                  color: const Color(0xff444040),
                  disabledColor: ProjectColors.disabled,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 70, vertical: 15),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: service.paymentLoading.isTrue
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.0,
                          ),
                        )
                      : Text(
                          providerState == BackEndStrings.providerNotFound
                              ? "Provider not found"
                              : "Buy for ₹ ${item.price.toInt()}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 13, color: Colors.white)),
                );
              }))
        ],
      ),
    );
  }

  Container buildChip(String text, Icon icon) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(width: 1, color: Colors.grey)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(
              width: 5,
            ),
            Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ],
        ));
  }

  Widget buildRow(String label, String value, IconData icon) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Wrap(
              children: [
                Icon(
                  icon,
                  color: ProjectColors.lightBlack,
                  size: 20,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  label,
                  style: const TextStyle(
                      color: ProjectColors.lightBlack,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Text(
              value,
              style: const TextStyle(color: ProjectColors.lightBlack),
            ),
          ],
        ),
      );
}
