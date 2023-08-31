import 'package:astroverse/res/dims/global.dart';
import 'package:astroverse/res/textStyles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../models/user.dart';

class NamePlate extends StatelessWidget {
  final User user;
  final void Function() onLogOut;
  final void Function() onEdit;

  const NamePlate(
      {super.key,
      required this.user,
      required this.onLogOut,
      required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: GlobalDims.horizontalPadding),
      child: Column(
        children: [
          nameItemWithButton(
              null,
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                child: Image.network(user.image, width: 120),
              ),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: onEdit,
                    child: const Text("Edit"),
                  ),
                  ElevatedButton(
                    onPressed: onLogOut,
                    child: const Text("logout"),
                  ),
                ],
              )),
          const SizedBox(
            height: 25,
          ),
          nameItem(
            "name",
            user.name,
          ),
          nameItem(
            "email",
            user.email,
          ),
          nameItem(
            "phone number",
            user.phNo,
          ),
          nameItem(
            "upi id",
            user.upiID,
          ),
          nameItem(
            "account type",
            user.astro ? "astro" : "general",
          ),
          nameItemWithButton(
              "plan",
              Text(
                user.plan.toString(),
                style: TextStylesLight().small,
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text("upgrade"),
              )),
        ],
      ),
    );
  }

  Widget nameItem(
    String label,
    String? value,
  ) {
    if (value.isBlank == true || value == null) {
      value = "unavailable";
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStylesLight().coloredSmall(Colors.lightBlue),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value,
              style: TextStylesLight().small,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget nameItemWithButton(String? label, Widget child, Widget button) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Text(
            label,
            style: TextStylesLight().coloredSmall(Colors.lightBlue),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [child, button],
        ),
      ],
    );
  }
}
