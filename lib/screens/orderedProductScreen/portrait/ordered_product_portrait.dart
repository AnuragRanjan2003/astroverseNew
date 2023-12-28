import 'dart:developer';

import 'package:astroverse/components/order_bottom_sheet.dart';
import 'package:astroverse/controllers/auth_controller.dart';
import 'package:astroverse/controllers/order_controller.dart';
import 'package:astroverse/models/purchase.dart';
import 'package:astroverse/models/service.dart';
import 'package:astroverse/res/img/images.dart';
import 'package:astroverse/screens/messaging.dart';
import 'package:astroverse/utils/crypt.dart';
import 'package:astroverse/utils/zego_cloud_services.dart';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart' as comet;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../res/colors/project_colors.dart';
import '../../../utils/resource.dart';

class OrderedProductPortrait extends StatelessWidget {
  final BoxConstraints cons;
  Purchase? purchase;

  OrderedProductPortrait(
      {super.key, required this.cons, required this.purchase});

  @override
  Widget build(BuildContext context) {
    //Purchase? purchase = Get.arguments;
    final OrderController order = Get.find();
    final AuthController auth = Get.find();
    final crypto = Crypt();
    final zegoService = ZegoCloudServices();

    if (purchase == null) {
      return const Center(
        child: Text("unexpected error occurred"),
      );
    }
    log(purchase.toString(), name: "PURCHASE");

    order.purchase.value = purchase;

    if (auth.user.value != null) {
      order.fetchService(auth.user.value!.uid, purchase!.itemId);
      order.startPurchaseStream(auth.user.value!.uid, purchase!.purchaseId,
          (p0) {
        purchase = p0;
      });
    }

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Obx(() =>
          _buildFab(order.purchase.value, order, crypto, zegoService, context)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Obx(() {
              final item = order.service.value;
              if (item == null) {
                if (order.serviceDeleted.isTrue) {
                  return Container(
                    height: 200,
                    color: Colors.grey,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.info_outline_rounded),
                        Text("service deleted"),
                      ],
                    ),
                  );
                }
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
                  item == null
                      ? (order.serviceDeleted.isFalse
                          ? "fetching"
                          : "service deleted")
                      : item.title,
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
                          if (order.serviceDeleted.isTrue) {
                            return const SizedBox(
                              width: 150,
                              height: 50,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.info_outline_rounded),
                                  Text("service deleted"),
                                ],
                              ),
                            );
                          }
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
                          if (order.purchase.value!.active) {
                            return buildChip(
                                'pending',
                                const FaIcon(
                                  FontAwesomeIcons.truckFast,
                                  size: 20,
                                  color: Colors.orange,
                                ),
                                Colors.orange);
                          } else {
                            return buildChip(
                                'canceled',
                                const FaIcon(
                                  FontAwesomeIcons.cancel,
                                  size: 16,
                                  color: Colors.red,
                                ),
                                Colors.red);
                          }
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
                  if (order.serviceDeleted.isTrue) {
                    return const SizedBox(
                      width: 200,
                      height: 70,
                      child: Column(
                        children: [
                          Icon(Icons.info_outline_rounded),
                          Text("service deleted"),
                        ],
                      ),
                    );
                  }
                  return Container(
                    color: Colors.grey,
                    width: 200,
                    height: 70,
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        buildChip(
                            _calculateMetric(item),
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
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        buildChip(
                            methodToString(item.deliveryMethod),
                            Icon(
                              methodToIcon(item.deliveryMethod),
                              color: Colors.black,
                            ),
                            null),
                        const Spacer(),
                      ],
                    ),
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
                  if (order.serviceDeleted.isTrue) {
                    return const SizedBox.shrink();
                  }
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
                  if (order.serviceDeleted.isTrue) {
                    return const SizedBox.shrink();
                  }
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
                if (order.serviceDeleted.isTrue) {
                  return const SizedBox(
                    height: 200,
                    child: Column(
                      children: <Widget>[
                        Icon(Icons.info_outline_rounded),
                        Text("service deleted"),
                      ],
                    ),
                  );
                }
                return Container(
                  color: Colors.grey,
                  width: 200,
                  height: 70,
                );
              }
              return buildRow(
                  'seller',
                  Crypt().decryptFromBase64String(item.authorName),
                  Icons.person_2);
            }),
            Obx(() {
              final item = order.service.value;
              if (item == null) {
                if (order.serviceDeleted.isTrue) return const SizedBox.shrink();
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
                if (order.serviceDeleted.isTrue) return const SizedBox.shrink();
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
                if (order.serviceDeleted.isTrue) return const SizedBox.shrink();
                return Container(
                  color: Colors.grey,
                  width: 200,
                  height: 70,
                );
              }
              return buildRow(
                  'views', item.views.toString(), Icons.remove_red_eye);
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
              if (order.purchase.value == null) {
                return Container(
                  width: 90,
                  height: 40,
                  color: Colors.grey,
                );
              }
              return buildRow(
                  'status',
                  order.purchase.value!.delivered ? "delivered" : "pending",
                  Icons.numbers);
            }),
            Obx(() {
              if (order.purchase.value == null) {
                return Container(
                  width: 90,
                  height: 40,
                  color: Colors.grey,
                );
              }
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
                  onPressed: order.purchase.value!.delivered ||
                          order.serviceDeleted.isTrue ||
                          order.purchase.value!.active == false
                      ? null
                      : () {
                          if (order.purchase.value == null) return;
                          Get.bottomSheet(
                              OrderBottomSheet(
                                purchase: order.purchase.value,
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
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Obx(() {
                return MaterialButton(
                  onPressed: order.purchase.value!.delivered ||
                          order.cancelingPurchase.isTrue ||
                          order.purchase.value!.active == false
                      ? null
                      : () {
                          if (order.purchase.value == null) return;

                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              surfaceTintColor: Colors.white,
                              title: const Text("Cancel Order"),
                              content: const Text(
                                  "Are you sure you want to cancel the order"),
                              actionsAlignment: MainAxisAlignment.center,
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      order.cancelPurchase(
                                          order.purchase.value!.purchaseId,
                                          order.purchase.value!.buyerId,
                                          order.purchase.value!.sellerId, (e) {
                                        String? text;
                                        Navigator.pop(context);
                                        if (e.isSuccess) {
                                          text =
                                              "Purchase has been deleted. Refund will be initiated.";
                                        } else {
                                          e as Failure<Json>;
                                          text =
                                              "Could not cancel the purchase. Try again later";
                                        }
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                                SnackBar(content: Text(text)));
                                      });
                                    },
                                    child: const Text(
                                      "Yes",
                                      style: TextStyle(color: Colors.red),
                                    )),
                              ],
                            ),
                          );
                        },
                  disabledColor: ProjectColors.disabled,
                  color: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
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

  Widget actionButton(Purchase purchase, Crypt crypto,
      ZegoCloudServices zegoService, BuildContext context) {
    if (purchase.deliveryMethod == 2) {
      return Container(
          child: zegoService.callButton(purchase.sellerId,
              crypto.decryptFromBase64String(purchase.sellerName)));
    }
    if (purchase.deliveryMethod == 1) {
      comet.User receiver = comet.User(
          uid: purchase.sellerId,
          name: crypto.decryptFromBase64String(purchase.sellerName));
      return InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Messaging(receiver: receiver),
            ),
          );
        },
        child: Container(
          width: 60,
          // Set the width of the button
          height: 60,
          margin: const EdgeInsets.only(bottom: 60),
          // Set the height of the button
          decoration: const BoxDecoration(
            shape: BoxShape.circle, // Makes the container circular
            color: Colors.lightBlue, // Set the background color of the button
          ),
          child: const Center(
              child: Icon(
            Icons.messenger_outlined,
            color: Colors.white,
          )),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildFab(Purchase? purchase, OrderController order, Crypt crypto,
      ZegoCloudServices zegoService, BuildContext context) {
    if (order.serviceDeleted.isTrue) {
      return Container(
        margin: const EdgeInsets.only(bottom: 60),
        child: Tooltip(
          triggerMode: TooltipTriggerMode.tap,
          message:
              "The service has been deleted.\nRefund should be in process and may take some time.\nYou may contact us.",
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          showDuration: const Duration(seconds: 8),
          child: Container(
            padding: const EdgeInsets.all(17),
            decoration: const BoxDecoration(
                color: Color.fromRGBO(255, 0, 0, 1),
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: const Icon(
              Icons.info_outline_rounded,
              color: Colors.white,
            ),
          ),
        ),
      );
    }
    if (purchase != null && order.serviceDeleted.isFalse && purchase.active) {
      return actionButton(purchase, crypto, zegoService, context);
    }
    return const SizedBox.shrink();
  }
}

String _calculateMetric(Service item) {
  if (item.views == 0) return '--';
  final metric = (5 * item.uses) / item.views;
  return metric.toStringAsFixed(1);
}

String methodToString(int e) {
  if (e == 0) return "in-person";
  if (e == 1) {
    return "chat";
  } else {
    return "call";
  }
}

IconData methodToIcon(int m) {
  if (m == 0) return Icons.people_outline;
  if (m == 1) return Icons.messenger_outline_outlined;
  return Icons.call_outlined;
}
