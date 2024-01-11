import 'dart:developer' as dev;

import 'package:astroverse/components/underlined_box.dart';
import 'package:astroverse/controllers/phone_auth_controller.dart';
import 'package:astroverse/models/user.dart' as models;
import 'package:astroverse/res/colors/project_colors.dart';
import 'package:astroverse/res/decor/button_decor.dart';
import 'package:astroverse/res/dims/global.dart';
import 'package:astroverse/res/img/images.dart';
import 'package:astroverse/screens/astroSignUp/portrait/astro_signup_portrait.dart';
import 'package:astroverse/screens/otpScreen/otp_screen.dart';
import 'package:astroverse/utils/otp_phone_callbacks.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../res/textStyles/text_styles.dart';

class PhoneAuthPortrait extends StatelessWidget {
  final BoxConstraints cons;
  final Parcel parcel;

  const PhoneAuthPortrait(
      {super.key, required this.cons, required this.parcel});

  @override
  Widget build(BuildContext context) {
    final phone = TextEditingController();
    final wd = cons.maxWidth;
    final ht = cons.maxHeight;
    final PhoneAuthController controller = Get.find();

    final models.User? user;
    user = parcel.data;
    final bool google = parcel.google;
    debugPrint(user.toString());
    dev.log("user got : ${user.toString()}", name: "USER");
    if (user == null) Get.snackbar("Error", "unexpected error");
    late OTPPhoneCallbacks callbacks;
    return Scaffold(
      backgroundColor: ProjectColors.primary,
      body: SingleChildScrollView(
        child: SizedBox(
          width: wd,
          height: ht,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Expanded(
                  flex: 3,
                  child: Image(
                    image: ProjectImages.phone,
                  )),
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: GlobalDims.horizontalPadding, vertical: 20),
                  decoration: const BoxDecoration(
                      color: ProjectColors.background,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Phone Number",
                        textAlign: TextAlign.center,
                        style: TextStylesLight().bodyBold,
                      ),
                      UnderLinedBox(
                          controller: phone,
                          prefix: const Text("+91"),
                          hint: "Enter your phone number",
                          maxLen: 10,
                          type: TextInputType.phone,
                          style: TextStylesLight().body),
                      Obx(() => MaterialButton(
                            onPressed: user == null
                                ? null
                                : () {
                                    String number = phone.value.text;
                                    dev.log(phoneValid(number).toString(),
                                        name: "NUMBER");
                                    if (!phoneValid(number)) return;
                                    number = "+91$number";
                                    controller.sendOtpLoading.value = true;

                                    controller.phone.value = number;
                                    callbacks = OTPPhoneCallbacks(
                                      (code) {
                                        controller.sendOtpLoading.value = false;
                                        final parcel = PhoneDataParcel(
                                            code,
                                            Parcel(data: user, google: google),
                                            number,
                                            callbacks);
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) =>
                                              OtpScreen(parcel: parcel),
                                        ));
                                      },
                                      (error) {
                                        controller.sendOtpLoading.value = false;
                                        controller.verifyOtpLoading.value =
                                            false;
                                      },
                                    );
                                    controller.sendOtp(callbacks, number);
                                  },
                            color: ProjectColors.main,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: ButtonDecors.filled,
                            child: controller.sendOtpLoading.isFalse
                                ? Text(
                                    "Send OTP",
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
                          ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool phoneValid(String num) {
    if (num.length != 10) return false;
    return true;
  }
}

class PhoneDataParcel {
  final String code;
  final Parcel parcel;
  final String number;
  final OTPPhoneCallbacks callbacks;

  PhoneDataParcel(this.code, this.parcel, this.number, this.callbacks);
}
