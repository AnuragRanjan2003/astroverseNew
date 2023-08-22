import 'package:astroverse/controllers/auth_controller.dart';
import 'package:astroverse/res/colors/project_colors.dart';
import 'package:astroverse/res/decor/button_decor.dart';
import 'package:astroverse/res/dims/global.dart';
import 'package:astroverse/res/strings/verify_email_string.dart';
import 'package:astroverse/res/textStyles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmailVerificationPortrait extends StatelessWidget {
  final BoxConstraints cons;

  const EmailVerificationPortrait({super.key, required this.cons});

  @override
  Widget build(BuildContext context) {
    debugPrint("email built again");
    final double ht = cons.maxHeight;
    final double wd = cons.maxWidth;
    final AuthController auth = Get.find();
    auth.sendVerificationEmail(
      () {
        auth.emailVerified.value = true;
      },
    );

    return Obx(() {
      if (auth.emailVerified.isFalse) {
        return buildView(wd, ht, auth);
      } else {
        return buildCentre();
      }
    });
  }

  Scaffold buildCentre() => Scaffold(
        body: Center(
          child: Text(
            "Email verified",
            style: TextStylesLight().bodyBold,
          ),
        ),
      );

  Scaffold buildView(double wd, double ht, AuthController auth) {
    return Scaffold(
        backgroundColor: ProjectColors.background,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              width: wd,
              padding: GlobalDims.defaultScreenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.email_outlined,
                    size: 120,
                    color: ProjectColors.onBackground,
                  ),
                  Column(
                    children: [
                      Text(
                        VerifyEmailString.title,
                        style: TextStylesLight().bodyBold,
                      ),
                      SizedBox(
                        height: ht * 0.02,
                      ),
                      Text(
                        VerifyEmailString.subTitle,
                        style: TextStylesLight().subtitle,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: ht * 0.1,
                  ),
                  Text(
                    VerifyEmailString.resend,
                    style: TextStylesLight().body,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Obx(() => Text(
                        toTime(auth.resendTimer.value),
                        style: TextStylesLight().bodyBold,
                        textAlign: TextAlign.center,
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Obx(() => MaterialButton(
                        onPressed: auth.resendTimer.value == 0
                            ? () {
                                auth.sendVerificationEmail(
                                  () {
                                    auth.emailVerified.value = true;
                                  },
                                );
                              }
                            : null,
                        disabledColor: ProjectColors.onBackground,
                        shape: ButtonDecors.filled,
                        color: ProjectColors.main,
                        child: Text(
                          "resend",
                          style: TextStyleDark().onButton,
                        ),
                      ))
                ],
              ),
            ),
          ),
        ));
  }

  String toTime(int x) {
    if (x == 60) return "01 : 00";
    if (x == 0) return "00 : 00";
    return "00 : $x";
  }
}
