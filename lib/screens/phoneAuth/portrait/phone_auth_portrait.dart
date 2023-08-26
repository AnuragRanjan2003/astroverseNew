import 'package:astroverse/components/underlined_box.dart';
import 'package:astroverse/controllers/phone_auth_controller.dart';
import 'package:astroverse/res/colors/project_colors.dart';
import 'package:astroverse/res/decor/button_decor.dart';
import 'package:astroverse/res/dims/global.dart';
import 'package:astroverse/res/img/images.dart';
import 'package:astroverse/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/user.dart';
import '../../../res/textStyles/text_styles.dart';

class PhoneAuthPortrait extends StatelessWidget {
  final BoxConstraints cons;

  const PhoneAuthPortrait({super.key, required this.cons});

  @override
  Widget build(BuildContext context) {
    final phone = TextEditingController();
    final wd = cons.maxWidth;
    final ht = cons.maxHeight;
    final PhoneAuthController controller = Get.find();
    final User? user;
    user = Get.arguments;
    debugPrint(user.toString());
    if (user == null) Get.snackbar("Error", "unexpected error");
    return Scaffold(
      backgroundColor: Colors.white.withAlpha(470),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
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
                        horizontal: GlobalDims.horizontalPadding),
                    decoration: const BoxDecoration(
                        color: ProjectColors.background,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Phone Number",
                          style: TextStylesLight().bodyBold,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        UnderLinedBox(
                            controller: phone,
                            prefix: "+91",
                            hint: "Enter your phone number",
                            maxLen: 10,
                            type: TextInputType.phone,
                            style: TextStylesLight().body),
                        const SizedBox(
                          height: 20,
                        ),
                        MaterialButton(
                          onPressed: user == null ? null : () {
                            String number = phone.value.text;
                            if (!phoneValid(number)) return;
                            number = "+91$number";
                            controller.phone.value = number;
                            Get.toNamed(Routes.otpScreen, arguments:user!);
                          },
                          color: ProjectColors.main,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: ButtonDecors.filled,
                          child: Text(
                            "Verify",
                            style: TextStyleDark().onButton,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
