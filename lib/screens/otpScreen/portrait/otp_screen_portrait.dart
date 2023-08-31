import 'dart:developer';

import 'package:astroverse/controllers/phone_auth_controller.dart';
import 'package:astroverse/models/user.dart' as models;
import 'package:astroverse/res/colors/project_colors.dart';
import 'package:astroverse/res/decor/button_decor.dart';
import 'package:astroverse/res/dims/global.dart';
import 'package:astroverse/res/img/images.dart';
import 'package:astroverse/res/textStyles/text_styles.dart';
import 'package:astroverse/routes/routes.dart';
import 'package:astroverse/screens/phoneAuth/portrait/phone_auth_portrait.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controller.dart';
import '../../../utils/resource.dart';

class OtpScreenPortrait extends StatelessWidget {
  final BoxConstraints cons;

  const OtpScreenPortrait({super.key, required this.cons});

  @override
  Widget build(BuildContext context) {
    final PhoneAuthController controller = Get.find();
    final AuthController auth = Get.find();
    final wd = cons.maxWidth;
    final ht = cons.maxHeight;
    final PhoneDataParcel dataParcel = Get.arguments;
    final models.User? user = dataParcel.parcel.data;
    final bool google = dataParcel.parcel.google;
    final String code = dataParcel.code;
    final String number = dataParcel.number;
    final callbacks = dataParcel.callbacks;
    log(user.toString(), name: "USER");
    log(code.toString(), name: "CODE");
    if (user == null) Get.snackbar("Error", "unexpected error");
    return Scaffold(
        backgroundColor: Colors.blue.shade50,
        body: SingleChildScrollView(
          child: Container(
            width: wd,
            height: ht,
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Expanded(
                    flex: 4,
                    child: Image(
                      image: ProjectImages.phone,
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
                            "Enter OTP",
                            style: TextStylesLight().bodyBold,
                            textAlign: TextAlign.center,
                          ),
                          OtpTextField(
                            numberOfFields: 6,
                            styles: List.generate(
                                6, (index) => TextStylesLight().bodyBold),
                            onCodeChanged: (e) {
                              controller.otpEntered.value = "";
                            },
                            onSubmit: (e) {
                              controller.otpEntered.value = e;
                              log(e, name: "OTP SUBMIT");
                            },
                          ),
                          Obx(() => MaterialButton(
                                onPressed: controller.otpEntered.value.length ==
                                        6
                                    ? () {
                                        controller.verifyOtpLoading.value =
                                            true;
                                        log(controller.otpEntered.value,
                                            name: "ON PRESSED");
                                        log(code, name: "ON PRESSED");
                                        final cred =
                                            PhoneAuthProvider.credential(
                                                verificationId: code,
                                                smsCode: controller
                                                    .otpEntered.value
                                                    .toString());
                                        controller.checkOtp(cred, () {
                                          user!.phNo = number;
                                          if (!google) {
                                            auth.createUserWithEmailForAstro(
                                                user, auth.pass.value, (p0) {
                                              if (p0 is Success) {
                                                Get.toNamed(
                                                  Routes.emailVerify,
                                                );
                                              } else {
                                                log((p0 as Failure).error,
                                                    name: "CREATE USER");
                                              }
                                            });
                                          } else {
                                            auth.saveGoogleData(user, (value) {
                                              log("saved" , name: "SAVE DATA");
                                            },user.astro);
                                          }
                                        }, () {
                                          controller.verifyOtpLoading.value =
                                              false;
                                        });
                                      }
                                    : null,
                                shape: ButtonDecors.filled,
                                color: ProjectColors.main,
                                disabledColor: ProjectColors.disabled,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                child: controller.verifyOtpLoading.isFalse
                                    ? Text(
                                        "Verify",
                                        style: TextStyleDark().onButton,
                                      )
                                    : const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.0,
                                        ),
                                      ),
                              )),
                          Column(
                            children: [
                              Text(
                                "Didn't receive the OTP? Retry in",
                                style: TextStylesLight().small,
                                textAlign: TextAlign.center,
                              ),
                              Obx(() => Text(
                                    toTime(controller.resendTimer.value),
                                    style: TextStylesLight().bodyBold,
                                    textAlign: TextAlign.center,
                                  )),
                            ],
                          ),
                          Obx(() => ElevatedButton(
                              onPressed: controller.resendTimer.value == 0
                                  ? () {
                                      controller.sendOtp(callbacks, number);
                                    }
                                  : null,
                              child: Text(
                                "Resend OTP",
                                style: TextStylesLight().smallBold,
                              ))),
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ));
  }

  String toTime(int x) {
    return "0${x ~/ 60} : ${doubleDigit(x)}";
  }

  String doubleDigit(int x) {
    if (x % 60 < 10) return "0${x % 60}";
    return "${x % 60}";
  }
}
