import 'package:astroverse/controllers/auth_controller.dart';
import 'package:astroverse/models/user.dart';
import 'package:astroverse/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../components/named_box.dart';
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
        child: Container(
          height: ht,
          width: wd,
          padding: const EdgeInsets.only(
              right: GlobalDims.horizontalPadding,
              left: GlobalDims.horizontalPadding,
              bottom: 10,
              top: GlobalDims.verticalPaddingExtra),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        UserSignUpStrings.title,
                        style: TextStylesLight().header,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        UserSignUpStrings.subTitle,
                        style: TextStylesLight().subtitle,
                      ),
                    ],
                  )),
              Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NamedBox(
                          name: "Email",
                          hint: "Enter your Email",
                          controller: email,
                          nameStyle: TextStylesLight().bodyBold),
                      const SizedBox(
                        height: 10,
                      ),
                      NamedBox(
                          name: "Username",
                          hint: "Enter your username",
                          controller: name,
                          nameStyle: TextStylesLight().bodyBold),
                      const SizedBox(
                        height: 10,
                      ),
                      NamedBox(
                        name: "Password",
                        hint: "Enter your Password",
                        controller: password,
                        nameStyle: TextStylesLight().bodyBold,
                        password: true,
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
                          if(email.value.text.isEmpty || password.value.text.isEmpty || name.value.text.isEmpty) return;
                          auth.pass.value = password.value.text;
                          final User user = User(
                              name.value.text, email.value.text, "", 0, "");
                          Get.toNamed(Routes.moreProfile, arguments: user);
                        },
                        shape: ButtonDecors.filled,
                        color: ProjectColors.main,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text("Next", style: TextStylesLight().onButton),
                      ),
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
                            const FaIcon(
                              FontAwesomeIcons.google,
                              color: ProjectColors.primary,
                              size: 18,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Google",
                              style: TextStyleDark().onButton,
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
    );
  }
}
