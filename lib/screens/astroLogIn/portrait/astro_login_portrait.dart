import 'package:astroverse/res/dims/global.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/underlined_box.dart';
import '../../../controllers/auth_controller.dart';
import '../../../res/colors/project_colors.dart';
import '../../../res/decor/button_decor.dart';
import '../../../res/img/images.dart';
import '../../../res/strings/user_login_strings.dart';
import '../../../res/textStyles/text_styles.dart';
import '../../../routes/routes.dart';

class AstroLogInPortrait extends StatelessWidget {
  final BoxConstraints cons;

  const AstroLogInPortrait({super.key, required this.cons});

  @override
  Widget build(BuildContext context) {
    final double wd = cons.maxWidth;
    final double ht = cons.maxHeight;
    final TextEditingController email = TextEditingController();
    final TextEditingController password = TextEditingController();
    final AuthController auth = Get.find();
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: wd,
          height: ht,
          padding: GlobalDims.defaultScreenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Expanded(
                  flex: 2,
                  child: SizedBox(
                    child: Image(
                      image: ProjectImages.login,
                      fit: BoxFit.cover,
                    ),
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
                        height: 20,
                      ),
                      UnderLinedBox(
                        hint: "Enter your Password",
                        controller: password,
                        style: TextStylesLight().body,
                        password: true,
                      ),
                      SizedBox(
                        height: ht * 0.05,
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
                            if (auth.loading.isTrue) return;
                            if (email.value.text.isNotEmpty &&
                                password.value.text.isNotEmpty) {
                              auth.loginUser(
                                  email.value.text,
                                  password.value.text,
                                  (p, b) => updateUI(p, b, context));
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
              Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Text(
                        UserLoginStrings.signup,
                        style: TextStylesLight().small,
                        textAlign: TextAlign.center,
                      ),
                      TextButton(
                        onPressed: () {
                          Get.toNamed(Routes.astroSignUp);
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
    );
  }
}

updateUI(Resource<dynamic> p, bool b, BuildContext context) {
  if (p.isSuccess) {
    if (b == false) {
      Get.toNamed(Routes.emailVerify);
    } else {
      Get.offAllNamed(Routes.main);
    }
  } else {
    p = p as Failure<dynamic>;
    Get.snackbar("Error", p.error);
  }
}
