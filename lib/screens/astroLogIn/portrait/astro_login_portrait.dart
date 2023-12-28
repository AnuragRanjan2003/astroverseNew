import 'dart:developer';

import 'package:astroverse/res/dims/global.dart';
import 'package:astroverse/screens/main/main_screen.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/underlined_box.dart';
import '../../../controllers/auth_controller.dart';
import '../../../res/colors/project_colors.dart';
import '../../../res/decor/button_decor.dart';
import '../../../res/img/images.dart';
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
    final TextEditingController resetEmail = TextEditingController();
    final AuthController auth = Get.find();
    auth.loading.value = false;
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
                  flex: 1,
                  child: SizedBox(
                    child: Image(
                      image: ProjectImages.login,
                      fit: BoxFit.cover,
                    ),
                  )),
              Expanded(
                  flex: 1,
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
                      Builder(builder: (context) {
                        return TextButton(
                            onPressed: () {
                              Scaffold.of(context).showBottomSheet((context) =>
                                  IntrinsicHeight(
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          right: 20,
                                          left: 20,
                                          bottom: 40,
                                          top: 20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          const Text(
                                            "Reset Password",
                                            style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          TextField(
                                            controller: resetEmail,
                                            decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText: "Email"),
                                          ),
                                          const SizedBox(
                                            height: 30,
                                          ),
                                          Obx(
                                            () => MaterialButton(
                                              onPressed: auth
                                                      .resetEmailLoading.isFalse
                                                  ? () {
                                                      if (resetEmail.value.text
                                                          .isNotEmpty) {
                                                        auth.resetEmailLoading
                                                            .value = true;
                                                        auth.sendResetPasswordEmail(
                                                            resetEmail.value
                                                                .text, (p0) {
                                                          auth.resetEmailLoading
                                                              .value = false;
                                                          if (p0.isSuccess) {
                                                            log("mail sent",
                                                                name: "RESET");
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    const SnackBar(
                                                                        content:
                                                                            Text("reset email sent")));
                                                          } else {
                                                            log("mail not sent",
                                                                name: "RESET");
                                                            p0 as Failure<
                                                                String>;
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    SnackBar(
                                                                        content:
                                                                            Text(p0.error)));
                                                          }
                                                          Navigator.of(context)
                                                              .pop();
                                                          resetEmail.clear();
                                                        });
                                                      }
                                                    }
                                                  : null,
                                              color: Colors.blue,
                                              disabledColor:
                                                  ProjectColors.disabled,
                                              disabledTextColor: Colors.white,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  12))),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 15,
                                                      horizontal: 15),
                                              child: Text(
                                                auth.resetEmailLoading.isFalse
                                                    ? "Send Email"
                                                    : "Sending..",
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ));
                            },
                            child: const Text("forgot password"));
                      }),
                      MaterialButton(
                        onPressed: () {
                          auth.signInWithGoogle(
                            (p0) {
                              log("login successful", name: "GOOGLE");
                            },
                            () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const MainScreen(),
                              ));
                            },
                          );
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
                            Obx(
                              () => Text(
                                auth.loading.isFalse
                                    ? "Google"
                                    : "Logging in..",
                                style: TextStylesLight().onButton,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
              TextButton(
                onPressed: () {
                  Get.toNamed(Routes.astroSignUp);
                },
                child: Text(
                  "Sign Up",
                  style: TextStylesLight().bodyBold,
                  textAlign: TextAlign.start,
                ),
              ),
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
