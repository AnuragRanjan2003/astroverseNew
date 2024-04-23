import 'dart:developer';

import 'package:astroverse/controllers/auth_controller.dart';
import 'package:astroverse/controllers/revenue_cat_controller.dart';
import 'package:astroverse/db/plans_db.dart';
import 'package:astroverse/models/plan.dart';
import 'package:astroverse/res/colors/project_colors.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/service_controller.dart';
import '../models/user.dart';

class UpgradeRangeBottomSheet extends StatelessWidget {
  final User user;

  const UpgradeRangeBottomSheet({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final AuthController auth = Get.find();
    final RevenueCatController rcController = Get.find();
    auth.selectedUpgradePlan.value = -1;
    rcController.getProductsForAstrologer();

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Select a plan",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            Obx(() {
              final _products = rcController.products.value;
              return Column(
                children: List.generate(
                    _products.length,
                    (index) => ListTile(
                          title: Text(_products[index].title),
                          onTap: () {
                            auth.selectedUpgradePlan.value = index;
                          },
                        )),
              );
            }),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Spacer(),
                Expanded(
                  flex: 5,
                  child: Obx(
                    () {
                      Plan? plan;
                      if (auth.selectedUpgradePlan.value != -1) {
                        plan = Plans.astroPlans.singleWhere(
                            (p) => auth.selectedUpgradePlan.value == p.value);
                      }
                      return MaterialButton(
                        onPressed: validate(auth) || plan == null
                            ? null
                            : () async {
                                await rcController.purchaseProduct(
                                    rcController.products[
                                        auth.selectedUpgradePlan.value],
                                    updateDb(auth, plan!, context));
                              },
                        disabledColor: ProjectColors.disabled,
                        disabledTextColor: Colors.white,
                        color: ProjectColors.primary,
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        child: plan == null
                            ? const Text("select a plan")
                            : Text(
                                "upgrade for ${plan.price} coins",
                                style: const TextStyle(color: Colors.white),
                              ),
                      );
                    },
                  ),
                ),
                const Spacer()
              ],
            ),
            const SizedBox(
              height: 120,
            )
          ],
        ),
      ),
    );
  }

  bool validate(AuthController auth) {
    final x = (auth.selectedUpgradePlan.value == -1 ||
            user.coins <
                Plans.astroPlans
                    .singleWhere(
                        (p) => auth.selectedUpgradePlan.value == p.value)
                    .price) ||
        auth.upgradingPlan.isTrue;
    log("$x", name: "VALIDATE");
    return x;
  }

  updateDb(AuthController auth, Plan plan, BuildContext context) {
    auth.updateRangeForUser(user.uid, plan!.value, plan.price, (p0) {
      if (p0.isSuccess) {
        auth.selectedUpgradePlan.value = -1;
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("range upgraded successfully")));
      } else {
        auth.selectedUpgradePlan.value = -1;
        p0 as Failure<Json>;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(p0.error)));
      }
      Navigator.pop(context);
    });
  }
}
