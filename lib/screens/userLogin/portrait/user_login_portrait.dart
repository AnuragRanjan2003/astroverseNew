import 'package:astroverse/components/named_box.dart';
import 'package:astroverse/components/underlined_box.dart';
import 'package:astroverse/controllers/auth_controller.dart';
import 'package:astroverse/res/colors/project_colors.dart';
import 'package:astroverse/res/decor/button_decor.dart';
import 'package:astroverse/res/dims/global.dart';
import 'package:astroverse/res/strings/user_login_strings.dart';
import 'package:astroverse/res/textStyles/text_styles.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../routes/routes.dart';

class UserLoginScreenPortrait extends StatelessWidget {
  final BoxConstraints cons;

  const UserLoginScreenPortrait({super.key, required this.cons});

  @override
  Widget build(BuildContext context) {
    final AuthController auth = Get.find();
    final double wd = cons.maxWidth;
    final double ht = cons.maxHeight;
    final TextEditingController email = TextEditingController();
    final TextEditingController password = TextEditingController();
    return Scaffold(
      backgroundColor: ProjectColors.background,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            height: ht*0.98,
            width: wd,
            padding: const EdgeInsets.only(
                right: GlobalDims.horizontalPadding,
                left: GlobalDims.horizontalPadding,
                bottom: 0,
                top: GlobalDims.verticalPaddingExtra),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Expanded(
                    flex: 2,
                    child: SizedBox()),
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
                          height: 20,
                        ),
                        UnderLinedBox(
                          hint: "Enter your Password",
                          controller: password,
                          style: TextStylesLight().body,
                          password: true,
                        ),
                        SizedBox(height: ht*0.05,),
                      ],
                    )),
                Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        MaterialButton(
                            onPressed: () {
                              if (auth.loading.isTrue) return;
                              if (email.value.text.isNotEmpty &&
                                  password.value.text.isNotEmpty) {
                                auth.loginUser(
                                    email.value.text,
                                    password.value.text,
                                    (p) => updateUI(p, context));
                              }
                            },
                            shape: ButtonDecors.filled,
                            color: ProjectColors.main,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Obx(() {
                              if (auth.loading.isFalse) {
                                return Text("Log In",
                                    style: TextStyleDark().onButton);
                              } else {
                                return const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: ProjectColors.background,
                                      strokeWidth: 2.0,
                                    ));
                              }
                            })),
                        const SizedBox(
                          height: 15,
                        ),
                        MaterialButton(
                          onPressed: () {},
                          shape: ButtonDecors.outlined,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const FaIcon(
                                FontAwesomeIcons.google,
                                color: ProjectColors.onBackground,
                                size: 18,
                              ),
                              const SizedBox(
                                width: 10,
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
                Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Text(
                          UserLoginStrings.signup,
                          style: TextStylesLight().small,
                        ),
                        TextButton(
                          onPressed: () {
                            Get.toNamed(Routes.userSignup);
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStylesLight().bodyBold,
                            textAlign: TextAlign.start,
                          ),
                        )
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void updateUI(Resource<dynamic> p, BuildContext context) {
    if (p.isSuccess) {
      Get.toNamed(Routes.main);
    } else {
      p = p as Failure<dynamic>;
      Get.snackbar("Error", p.error);
    }
  }
}
