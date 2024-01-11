import 'dart:developer';

import 'package:astroverse/components/plan_item.dart';
import 'package:astroverse/controllers/auth_controller.dart';
import 'package:astroverse/db/plans_db.dart';
import 'package:astroverse/models/plan.dart';
import 'package:astroverse/models/user.dart';
import 'package:astroverse/res/colors/project_colors.dart';
import 'package:astroverse/utils/geo.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

typedef Json = Map<String, dynamic>;

class UpgradeFeaturesBottomSheet extends StatefulWidget {
  final User user;

  const UpgradeFeaturesBottomSheet({super.key, required this.user});

  @override
  State<UpgradeFeaturesBottomSheet> createState() =>
      _UpgradeFeaturesBottomSheetState();
}

class _UpgradeFeaturesBottomSheetState
    extends State<UpgradeFeaturesBottomSheet> {
  late AuthController auth;

  @override
  Widget build(BuildContext context) {
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
            ...List.generate(
                Plans.plans.sublist(1).length,
                (index) => Plans.plans.sublist(1)[index].value + VisibilityPlans.all + 1 >
                        widget.user.plan
                    ? Obx(() => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: PlanItem(
                              plan: Plans.plans.sublist(1)[index],
                              selected: auth.selectedUpgradeFeatures.value,
                              onChange: (p) {
                                auth.selectedUpgradeFeatures.value = p.value;
                              }),
                        ))
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: PlanItem(
                          plan: Plans.plans.sublist(1)[index],
                          selected: -1,
                          taken: true,
                          onChange: (p) {},
                        ),
                      )),
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
                      if (auth.selectedUpgradeFeatures.value != -1) {
                        plan = Plans.plans.singleWhere((p) =>
                            auth.selectedUpgradeFeatures.value == p.value);
                      }
                      return MaterialButton(
                        onPressed: validate(auth)
                            ? null
                            : () {
                                auth.updateRangeForUser(
                                    widget.user.uid,
                                    plan!.value + VisibilityPlans.all + 1,
                                    plan.price, (p0) {
                                  if (p0.isSuccess) {
                                    auth.selectedUpgradePlan.value = -1;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "plan upgraded successfully")));
                                  } else {
                                    auth.selectedUpgradePlan.value = -1;
                                    p0 as Failure<Json>;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(p0.error)));
                                  }
                                  Navigator.pop(context);
                                });
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

  validate(AuthController auth) {
    final x = (auth.selectedUpgradeFeatures.value == -1 ||
            widget.user.coins <
                Plans.plans
                    .singleWhere(
                        (p) => auth.selectedUpgradeFeatures.value == p.value)
                    .price) ||
        auth.upgradingFeatures.isTrue;
    log("$x", name: "VALIDATE");
    return x;
  }

  @override
  void initState() {
    auth = Get.find();
    auth.selectedUpgradeFeatures.value = -1;
    super.initState();
  }
}
