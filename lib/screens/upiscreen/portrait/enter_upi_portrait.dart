import 'dart:developer';

import 'package:astroverse/res/textStyles/text_styles.dart';
import 'package:astroverse/screens/astroSignUp/portrait/astro_signup_portrait.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../components/underlined_box.dart';
import '../../../models/user.dart';
import '../../../res/colors/project_colors.dart';
import '../../../res/decor/button_decor.dart';
import '../../../res/dims/global.dart';
import '../../../res/img/images.dart';
import '../../../routes/routes.dart';

class EnterUpiPortrait extends StatelessWidget {
  final BoxConstraints cons;

  const EnterUpiPortrait({super.key, required this.cons});

  @override
  Widget build(BuildContext context) {
    final Parcel parcel = Get.arguments;
    final User? user = parcel.data;
    final google = parcel.google;

    log(user.toString(), name: "USER");
    final TextEditingController upi = TextEditingController();
    if (user == null) Get.snackbar("Error", "unexpected error");
    return Scaffold(
        backgroundColor: Colors.blue.shade50,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(top: 10),
            height: cons.maxHeight,
            width: cons.maxWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Expanded(
                    flex: 4,
                    child: Image(
                      image: ProjectImages.bank,
                    )),
                Expanded(
                    flex: 3,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: GlobalDims.horizontalPadding,
                          vertical: 20),
                      decoration: const BoxDecoration(
                          color: ProjectColors.background,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(40),
                              topLeft: Radius.circular(40))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Enter UPI Id",
                            style: TextStylesLight().bodyBold,
                            textAlign: TextAlign.center,
                          ),
                          UnderLinedBox(
                              controller: upi,
                              hint: "Enter your UPI Id",
                              prefix:
                                  const Icon(FontAwesomeIcons.buildingColumns),
                              type: TextInputType.emailAddress,
                              style: TextStylesLight().body),
                          MaterialButton(
                            onPressed: () {
                              log(upi.value.text, name: "UPI");
                              user!.upiID = upi.value.text;
                              Get.toNamed(Routes.phoneAuth, arguments: Parcel(data: user, google: google));
                            },
                            shape: ButtonDecors.filled,
                            color: ProjectColors.main,
                            disabledColor: ProjectColors.disabled,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: Text(
                              "Proceed",
                              style: TextStyleDark().onButton,
                            ),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                Get.toNamed(Routes.phoneAuth,
                                    arguments:
                                        Parcel(data: user, google: google));
                              },
                              child: Text(
                                "Skip",
                                style: TextStylesLight().smallBold,
                              )),
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ));
  }
}
