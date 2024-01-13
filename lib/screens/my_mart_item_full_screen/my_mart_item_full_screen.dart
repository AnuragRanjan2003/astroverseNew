import 'dart:developer';

import 'package:astroverse/controllers/auth_controller.dart';
import 'package:astroverse/controllers/service_controller.dart';
import 'package:astroverse/models/save_service.dart';
import 'package:astroverse/models/service.dart';
import 'package:astroverse/res/colors/project_colors.dart';
import 'package:astroverse/utils/crypt.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MyMartItemFullScreen extends StatelessWidget {
  final SaveService ss;
  const MyMartItemFullScreen({super.key, required this.ss});

  @override
  Widget build(BuildContext context) {
    final ServiceController service = Get.find();
    final AuthController auth = Get.find();
    //final SaveService ss = Get.arguments;

    final crypto = Crypt();

    service.fetchService(ss.id);
    log("save service : ${ss.id}", name: "SAVE SERVICE");
    return Scaffold(
      body: FutureBuilder<Resource<Service>>(
        future: service.fetchService(ss.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if(snapshot.data!.isFailure){
              final error = snapshot.data! as Failure<Service>;
              return Center(child: Text(error.error),);
            }
            final sb = StringBuffer();
            final item = (snapshot.data! as Success<Service>).data;
            sb.writeAll(item.genre, ", ");
            return Column(
              children: [
                Image(
                  image: NetworkImage(item.imageUrl),
                  height: Get.height * 0.45,
                  fit: BoxFit.fitHeight,
                  width: Get.width,
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 8),
                          child: Text(
                            item.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 8),
                          child: Text(
                            '₹ ${item.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18 , color: Colors.green),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              buildChip(
                                  calculateMetric(item),
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
                                    color: ProjectColors.primary,
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
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              child: buildChip(
                                  methodToString(item.deliveryMethod),
                                  Icon(
                                    methodToIcon(item.deliveryMethod),
                                    size: 20,
                                  )),
                            ),
                            const Spacer()
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 3),
                          child: Text(
                            sb.toString(),
                            style: const TextStyle(
                                color: ProjectColors.lightBlack,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 35, vertical: 8),
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 8),
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
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 8),
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
                        buildRow(
                            'service id',
                            item.id,
                            Icons.numbers),
                        buildRow(
                            'seller',
                            crypto.decryptFromBase64String(item.authorName),
                            Icons.person_2),
                        buildRow(
                            'date',
                            DateFormat.yMMMd().format(item.date).toString(),
                            Icons.date_range),
                        buildRow('uses', item.uses.toString(),
                            Icons.data_thresholding),
                        buildRow('views', item.views.toString(),
                            Icons.remove_red_eye),
                      ],
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: Row(
                      children: [
                        Obx(() {
                          final user = auth.user.value;
                          return MaterialButton(
                            onPressed: (user == null ||
                                    service.deletingService.isTrue)
                                ? null
                                : () async {
                                    service.deleteService(ss, user.uid, (p) {
                                      String msg;
                                      if (p.isSuccess) {
                                        msg = "service deleted";
                                      } else {
                                        msg = (p as Failure<String>).error;
                                      }

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                              SnackBar(content: Text(msg)));
                                    });
                                  },
                            color: const Color.fromRGBO(255, 0, 0, 1.0),
                            disabledColor: ProjectColors.disabled,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15),
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            child: service.paymentLoading.isTrue
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.0,
                                    ),
                                  )
                                : const Row(
                                    children: [
                                      Icon(
                                        Icons.delete_outline,
                                        color: Colors.white,
                                      ),
                                      Text("Delete",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                          );
                        }),
                        const Spacer(),
                      ],
                    ))
              ],
            );
          } else {
            return const Center(
              child: SizedBox(
                height: 40,
                width: 40,
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }

  Container buildChip(String text, Icon icon) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
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

  String methodToString(int e) {
    if (e == 0) {
      return "chat";
    } else {
      return "call";
    }
  }

  String calculateMetric(Service item) {
    if (item.views == 0) return '--';
    final metric = (5 * item.uses) / item.views;
    return metric.toStringAsFixed(1);
  }

  IconData methodToIcon(int m) {
    if (m == 0) return Icons.messenger_outline_outlined;
    return Icons.call_outlined;
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
