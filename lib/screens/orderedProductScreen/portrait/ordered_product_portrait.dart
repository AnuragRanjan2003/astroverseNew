import 'dart:developer';

import 'package:astroverse/components/order_bottom_sheet.dart';
import 'package:astroverse/controllers/auth_controller.dart';
import 'package:astroverse/controllers/order_controller.dart';
import 'package:astroverse/models/purchase.dart';
import 'package:astroverse/res/img/images.dart';
import 'package:astroverse/utils/crypt.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../res/colors/project_colors.dart';

class OrderedProductPortrait extends StatelessWidget {
  final BoxConstraints cons;

  const OrderedProductPortrait({super.key, required this.cons});

  @override
  Widget build(BuildContext context) {
    Purchase? purchase = Get.arguments;
    final OrderController order = Get.find();
    final AuthController auth = Get.find();

    if (purchase == null) {
      return const Center(
        child: Text("unexpected error occurred"),
      );
    }
    log(purchase.toString(), name: "PURCHASE");

    order.purchase.value = purchase;

    if (auth.user.value != null) {
      order.fetchService(auth.user.value!.uid, purchase.itemId);
      order.startPurchaseStream(auth.user.value!.uid, purchase.purchaseId,
          (p0) {
        purchase = p0;
      });
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Obx(() {
              final item = order.service.value;
              if (item == null) {
                return Container(
                  color: Colors.grey,
                );
              }
              return item.imageUrl.isNotEmpty
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
                    );
            }),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Obx(() {
                final item = order.service.value;
                return Text(
                  item == null ? "fetching" : item.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.start,
                );
              }),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Obx(() {
                        if (order.purchase.value == null) {
                          return Container(
                            width: 150,
                            height: 50,
                            color: Colors.grey,
                          );
                        }
                        if (order.purchase.value!.delivered) {
                          return buildChip(
                              'delivered',
                              const FaIcon(
                                FontAwesomeIcons.truckFast,
                                size: 20,
                                color: Colors.green,
                              ),
                              Colors.green);
                        } else {
                          return buildChip(
                              'pending',
                              const FaIcon(
                                FontAwesomeIcons.truckFast,
                                size: 20,
                                color: Colors.red,
                              ),
                              Colors.red);
                        }
                      })),
                  const Expanded(
                    flex: 1,
                    child: SizedBox(),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Obx(() {
                final item = order.service.value;
                if (item == null) {
                  return Container(
                    color: Colors.grey,
                    width: 200,
                    height: 70,
                  );
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    buildChip(
                        '4.4',
                        const Icon(
                          Icons.star,
                          color: Colors.lightGreen,
                        ),
                        null),
                    const SizedBox(
                      width: 10,
                    ),
                    buildChip(
                        item.uses.toString(),
                        const Icon(
                          Icons.data_exploration_outlined,
                          color: Colors.blueAccent,
                        ),
                        null),
                    const SizedBox(
                      width: 10,
                    ),
                    buildChip(
                        item.genre.first,
                        const Icon(
                          Icons.category_outlined,
                          color: Colors.black,
                        ),
                        null),
                  ],
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
              child: Obx(() {
                final sb = StringBuffer();
                final item = order.service.value;
                log(item.toString(), name: "ITEM");
                if (item == null) {
                  return Container(
                    color: Colors.grey,
                    width: 200,
                    height: 70,
                  );
                }
                sb.writeAll(item.genre, ", ");
                return Text(
                  sb.toString(),
                  style: const TextStyle(
                      color: ProjectColors.lightBlack,
                      fontWeight: FontWeight.bold),
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Obx(() {
                final item = order.service.value;
                if (item == null) {
                  return Container(
                    color: Colors.grey,
                    width: 200,
                    height: 70,
                  );
                }
                return Text(
                  item.description,
                  style: const TextStyle(
                    color: ProjectColors.lightBlack,
                  ),
                );
              }),
            ),
            const SizedBox(
              height: 15,
            ),
            Obx(() {
              final item = order.service.value;
              if (item == null) return const SizedBox.shrink();
              return Visibility(
                visible: item.place.isNotEmpty,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  child: Wrap(
                    children: [
                      Icon(
                        Icons.location_pin,
                        color: Colors.black,
                      ),
                      Text(
                        'Pickup Address',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              );
            }),
            Obx(() {
              final item = order.service.value;
              if (item == null) return const SizedBox.shrink();
              return Visibility(
                visible: item.place.isNotEmpty,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 35, vertical: 0),
                  child: Text(
                    item.place,
                    style: const TextStyle(
                      color: ProjectColors.lightBlack,
                    ),
                  ),
                ),
              );
            }),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: Wrap(
                children: [
                  Icon(
                    Icons.info,
                    color: Colors.black,
                    size: 22,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Details',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Obx(() {
              final item = order.service.value;
              if (item == null) {
                return Container(
                  color: Colors.grey,
                  width: 200,
                  height: 70,
                );
              }
              return buildRow('seller', Crypt().decryptFromBase64String(item.authorName), Icons.person_2);
            }),
            Obx(() {
              final item = order.service.value;
              if (item == null) {
                return Container(
                  color: Colors.grey,
                  width: 200,
                  height: 70,
                );
              }
              return buildRow(
                  'date',
                  DateFormat.yMMMd().format(item.date).toString(),
                  Icons.date_range);
            }),
            Obx(() {
              final item = order.service.value;
              if (item == null) {
                return Container(
                  color: Colors.grey,
                  width: 200,
                  height: 70,
                );
              }
              return buildRow(
                  'uses', item.uses.toString(), Icons.data_thresholding);
            }),
            Obx(() {
              final item = order.service.value;
              if (item == null) {
                return Container(
                  color: Colors.grey,
                  width: 200,
                  height: 70,
                );
              }
              return buildRow('likes', item.upVotes.toString(), Icons.favorite);
            }),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: Wrap(
                children: [
                  Icon(
                    Icons.inventory_outlined,
                    color: Colors.black,
                    size: 22,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Invoice',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            order.purchase.value != null
                ? buildRow('payment Id',
                    order.purchase.value!.paymentId.toString(), Icons.numbers)
                : Container(
                    width: 100,
                    height: 30,
                    color: Colors.grey,
                  ),
            order.purchase.value != null
                ? buildRow('price', '₹ ${order.purchase.value!.itemPrice}',
                    Icons.money)
                : Container(
                    width: 100,
                    height: 30,
                    color: Colors.grey,
                  ),
            order.purchase.value != null
                ? buildRow('total price',
                    '₹ ${order.purchase.value!.totalPrice}', Icons.money)
                : Container(
                    width: 100,
                    height: 30,
                    color: Colors.grey,
                  ),
            order.purchase.value != null
                ? buildRow(
                    'bought on',
                    DateFormat.yMMMd()
                        .format(order.purchase.value!.boughtOn)
                        .toString(),
                    Icons.date_range)
                : Container(
                    width: 100,
                    height: 30,
                    color: Colors.grey,
                  ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: Wrap(
                children: [
                  Icon(
                    FontAwesomeIcons.truck,
                    color: Colors.black,
                    size: 18,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Order fulfillment',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Obx(() {
              if (order.purchase.value == null)
                return Container(
                  width: 90,
                  height: 40,
                  color: Colors.grey,
                );
              return buildRow(
                  'status',
                  order.purchase.value!.delivered ? "delivered" : "pending",
                  Icons.numbers);
            }),
            Obx(() {
              if (order.purchase.value == null)
                return Container(
                  width: 90,
                  height: 40,
                  color: Colors.grey,
                );
              return buildRow(
                  'delivered on',
                  order.purchase.value!.deliveredOn != null
                      ? DateFormat.yMMMd()
                          .format(order.purchase.value!.deliveredOn!)
                          .toString()
                      : "to be delivered",
                  Icons.date_range);
            }),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Obx(() {
                final user = auth.user.value!;
                return MaterialButton(
                  onPressed: order.purchase.value!.delivered
                      ? null
                      : () {
                          if (order.purchase.value == null) return;
                          Get.bottomSheet(
                              OrderBottomSheet(
                                purchase: purchase,
                                item: order.service.value,
                                currentUser: auth.user.value,
                              ),
                              isScrollControlled: true);
                        },
                  disabledColor: ProjectColors.disabled,
                  color: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Text(
                    order.purchase.value != null
                        ? ((user.uid == order.purchase.value!.sellerId)
                            ? "Claim"
                            : "Received")
                        : "fetching",
                    style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                );
              }),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  Container buildChip(String text, Widget icon, Color? color) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(width: 1, color: color ?? Colors.grey)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(
              width: 5,
            ),
            Text(
              text,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: color ?? Colors.black),
            ),
          ],
        ));
  }

  Widget buildRow(String label, String? value, IconData icon) => Padding(
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
              value.toString(),
              style: const TextStyle(
                  color: ProjectColors.lightBlack, fontSize: 12),
            ),
          ],
        ),
      );
}
