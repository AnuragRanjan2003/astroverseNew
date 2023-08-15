import 'package:astroverse/components/underlined_box.dart';
import 'package:astroverse/controllers/auth_controller.dart';
import 'package:astroverse/models/user.dart';
import 'package:astroverse/res/img/images.dart';
import 'package:astroverse/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../res/colors/project_colors.dart';
import '../../../res/decor/button_decor.dart';
import '../../../res/dims/global.dart';
import '../../../res/strings/user_signup_strings.dart';
import '../../../res/textStyles/text_styles.dart';

class UserSignUpPortrait extends StatelessWidget {
  final BoxConstraints cons;

  const UserSignUpPortrait({super.key, required this.cons});

  @override
  Widget build(BuildContext context) {
    final double wd = cons.maxWidth;
    final double ht = cons.maxHeight;
    final TextEditingController email = TextEditingController();
    final TextEditingController password = TextEditingController();
    final TextEditingController name = TextEditingController();
    final AuthController auth = Get.find();

    return Scaffold(
      backgroundColor: ProjectColors.background,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            height: ht * 0.95,
            width: wd,
            padding: const EdgeInsets.only(
              right: GlobalDims.horizontalPadding,
              left: GlobalDims.horizontalPadding,
              bottom: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Expanded(
                    flex: 2,
                    child: Image(
                      image: ProjectImages.signup,
                      fit: BoxFit.cover,
                    )),
                Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        UnderLinedBox(
                            hint: "Enter your Email",
                            controller: email,
                            style: TextStylesLight().body),
                        const SizedBox(
                          height: 17,
                        ),
                        UnderLinedBox(
                            hint: "Enter your username",
                            controller: name,
                            style: TextStylesLight().body),
                        const SizedBox(
                          height: 17,
                        ),
                        UnderLinedBox(
                          hint: "Enter your Password",
                          controller: password,
                          style: TextStylesLight().body,
                          password: true,
                        ),
                        SizedBox(
                          height: ht * 0.04,
                        ),
                      ],
                    )),
                Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        MaterialButton(
                          onPressed: () {
                            if (email.value.text.isEmpty ||
                                password.value.text.isEmpty ||
                                name.value.text.isEmpty) return;
                            auth.pass.value = password.value.text;
                            final User user = User(name.value.text,
                                email.value.text, "", 0, "", false, "");
                            Get.toNamed(Routes.moreProfile, arguments: user);
                          },
                          shape: ButtonDecors.filled,
                          color: ProjectColors.main,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Text("Next", style: TextStyleDark().onButton),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        MaterialButton(
                          onPressed: () {
                            auth.signUpWithGoogle();
                          },
                          shape: ButtonDecors.outlined,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Image(
                                image: ProjectImages.googleIcon,
                                height: 28,
                                width: 32,
                              ),
                              Text(
                                "Google",
                                style: TextStylesLight().onButton,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
                Column(
                  children: [
                    Text(
                      UserSignUpStrings.signup,
                      style: TextStylesLight().small,
                    ),
                    TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text(
                        "Log In",
                        style: TextStylesLight().bodyBold,
                        textAlign: TextAlign.start,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
