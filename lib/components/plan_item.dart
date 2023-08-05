import 'package:astroverse/res/colors/project_colors.dart';
import 'package:astroverse/res/textStyles/text_styles.dart';
import 'package:flutter/material.dart';

import '../models/plan.dart';

class PlanItem extends StatelessWidget {
  final Plan plan;
  final int selected;
  final void Function(int) onChange;

  const PlanItem(
      {super.key,
      required this.plan,
      required this.selected,
      required this.onChange});

  @override
  Widget build(BuildContext context) {
    final Color _color = getColor(selected!=plan.type);
    return InkWell(
      onTap: () {
        onChange(plan.type);
      },
      child: Container(
          padding:
              const EdgeInsets.only(top: 20, bottom: 20, left: 25, right: 25),
          constraints: const BoxConstraints(minWidth: 140),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: _color)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                plan.name,
                style: TextStylesLight().coloredBodyBold(_color),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Rs ${plan.price.floor()}",
                style: TextStylesLight().coloredBody(_color),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                plan.content,
                style: TextStylesLight().coloredSmall(_color),
                overflow: TextOverflow.visible,
              )
            ],
          )),
    );
  }

   Color getColor(bool p) {
    if (p == true) {
      return  ProjectColors.onBackground;
    } else {
      return  ProjectColors.main;
    }
  }
}
