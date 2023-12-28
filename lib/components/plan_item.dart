import 'package:astroverse/res/colors/project_colors.dart';
import 'package:astroverse/res/textStyles/text_styles.dart';
import 'package:flutter/material.dart';

import '../models/plan.dart';

class PlanItem extends StatelessWidget {
  final Plan plan;
  final int selected;
  final bool taken;
  final void Function(Plan) onChange;

  const PlanItem({
    super.key,
    required this.plan,
    required this.selected,
    required this.onChange,
    this.taken = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = getColor(selected != plan.value);
    return InkWell(
      onTap: () {
        onChange(plan);
      },
      child: Container(
          padding:
              const EdgeInsets.only(top: 20, bottom: 20, left: 25, right: 25),
          margin: const EdgeInsets.symmetric(vertical: 5),
          constraints: const BoxConstraints(minWidth: 140),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              border: Border.all(color: color)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    plan.name,
                    style: TextStylesLight().coloredBodyBold(color),
                  ),
                  taken?Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: ProjectColors.disabled)),
                    child: const Text(
                      "taken",
                      style: TextStyle(color: ProjectColors.disabled, fontSize: 12),
                    ),
                  ):const SizedBox.shrink(),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "${plan.price} coins",
                style: TextStylesLight().coloredBody(color),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                plan.content,
                style: TextStylesLight().coloredSmall(color),
                overflow: TextOverflow.visible,
              )
            ],
          )),
    );
  }

  Color getColor(bool p) {
    if (p == true) {
      return ProjectColors.onBackground;
    } else {
      return ProjectColors.main;
    }
  }
}
