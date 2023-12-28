import 'dart:developer';

import 'package:astroverse/components/underlined_box.dart';
import 'package:astroverse/controllers/auth_controller.dart';
import 'package:astroverse/res/colors/project_colors.dart';
import 'package:astroverse/res/decor/button_decor.dart';
import 'package:astroverse/res/dims/global.dart';
import 'package:astroverse/res/img/images.dart';
import 'package:astroverse/res/textStyles/text_styles.dart';
import 'package:astroverse/screens/emailverfication/email_verification_screen.dart';
import 'package:astroverse/screens/main/main_screen.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../routes/routes.dart';

class UserLoginScreenPortrait extends StatelessWidget {
  final BoxConstraints cons;

  const UserLoginScreenPortrait({super.key, required this.cons});

  @override
  Widget build(BuildContext context) {
    final AuthController auth = Get.find();
    GoogleSignIn().signOut();
    auth.loading.value = false;
    final double wd = cons.maxWidth;
    final double ht = cons.maxHeight;
    final TextEditingController email = TextEditingController();
    final TextEditingController password = TextEditingController();
    final TextEditingController resetEmail = TextEditingController();
    return Scaffold(
      backgroundColor: ProjectColors.background,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            height: ht * 0.98,
            width: wd,
            padding: const EdgeInsets.only(
                right: GlobalDims.horizontalPadding,
                left: GlobalDims.horizontalPadding,
                bottom: 0,
                top: GlobalDims.verticalPaddingExtra),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(
                    flex: 1,
                    child: SizedBox(
                      child: Image(
                        image: ProjectImages.login,
                        fit: BoxFit.fitHeight,
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
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    )),
                Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
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
                                Scaffold.of(context)
                                    .showBottomSheet(
                                        (context) => IntrinsicHeight(
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    right: 20,
                                                    left: 20,
                                                    bottom: 40,
                                                    top: 20),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .stretch,
                                                  children: [
                                                    const Text(
                                                      "Reset Password",
                                                      style: TextStyle(
                                                          fontSize: 22,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    TextField(
                                                      controller: resetEmail,
                                                      decoration:
                                                          const InputDecoration(
                                                              border:
                                                                  OutlineInputBorder(),
                                                              hintText:
                                                                  "Email"),
                                                    ),
                                                    const SizedBox(
                                                      height: 30,
                                                    ),
                                                    Obx(
                                                      () => MaterialButton(
                                                        onPressed:
                                                            auth.resetEmailLoading
                                                                    .isFalse
                                                                ? () {
                                                                    if (resetEmail
                                                                        .value
                                                                        .text
                                                                        .isNotEmpty) {
                                                                      auth.resetEmailLoading
                                                                              .value =
                                                                          true;
                                                                      auth.sendResetPasswordEmail(
                                                                          resetEmail
                                                                              .value
                                                                              .text,
                                                                          (p0) {
                                                                        auth.resetEmailLoading.value =
                                                                            false;
                                                                        if (p0
                                                                            .isSuccess) {
                                                                          log("mail sent",
                                                                              name: "RESET");
                                                                          ScaffoldMessenger.of(context)
                                                                              .showSnackBar(const SnackBar(content: Text("reset email sent")));
                                                                        } else {
                                                                          log("mail not sent",
                                                                              name: "RESET");
                                                                          p0 as Failure<
                                                                              String>;
                                                                          ScaffoldMessenger.of(context)
                                                                              .showSnackBar(SnackBar(content: Text(p0.error)));
                                                                        }
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                        resetEmail
                                                                            .clear();
                                                                      });
                                                                    }
                                                                  }
                                                                : null,
                                                        color: Colors.blue,
                                                        disabledColor:
                                                            ProjectColors
                                                                .disabled,
                                                        disabledTextColor:
                                                            Colors.white,
                                                        shape: const RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            12))),
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 15,
                                                                horizontal: 15),
                                                        child: Text(
                                                          auth.resetEmailLoading
                                                                  .isFalse
                                                              ? "Send Email"
                                                              : "Sending..",
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white),
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
                            auth.loading.value = true;
                            auth.signInWithGoogle(
                              (p0) {
                                auth.loading.value = false;
                                if (p0.isSuccess) {
                                  log(" login successful", name: "GOOGLE");
                                }
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
                    Get.toNamed(Routes.userSignup);
                  },
                  child: Text(
                    "Sign Up",
                    style: TextStylesLight().bodyBold,
                    textAlign: TextAlign.start,
                  ),
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void updateUI(Resource<dynamic> p, bool b, BuildContext context) {
    if (p.isSuccess) {
      if (b == false) {
        //Get.toNamed(Routes.emailVerify);
        Navigator.push(context, MaterialPageRoute(builder: (context) => const EmailVerificationScreen(),));

      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const MainScreen(),));
        //Get.offAllNamed(Routes.main);
      }
    } else {
      p = p as Failure<dynamic>;
      Get.snackbar("Error", p.error);
    }
  }

  void googleUpdateUI(Resource<UserCredential> value) {
    if (value.isSuccess) {
      debugPrint("got user");
      debugPrint((value as Success<UserCredential>).data.user?.toString());
    } else {
      debugPrint((value as Failure<UserCredential>).error);
    }
  }
}
