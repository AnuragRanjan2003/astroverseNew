import 'package:flutter/material.dart';

import '../models/plan.dart';
import '../res/colors/project_colors.dart';
import '../res/textStyles/text_styles.dart';

class AstroPlanItem extends StatelessWidget {
  final bool sel;
  final Plan plan;

  const AstroPlanItem({
    super.key, required this.sel, required this.plan,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical:4),
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      decoration: BoxDecoration(
        color: !sel?Colors.grey.withAlpha(20):Colors.transparent,
          border: sel ? Border.all(color: ProjectColors.main , width: 1.5) : Border.all(color: ProjectColors.disabled),
          borderRadius: const BorderRadius.all(Radius.circular(5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                plan.name,
                style: TextStylesLight().bodyBold,
              ),
              Text(
                plan.content,
                style: TextStylesLight().small,
                maxLines: 4,
                textAlign: TextAlign.left,
              ),
            ],
          ),
          Text(
            "₹${plan.price.toInt()}",
            style: TextStylesLight().bodyBold,
          )
        ],
      ),
    );
  }
}