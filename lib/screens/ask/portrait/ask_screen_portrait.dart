import 'package:astroverse/controllers/auth_controller.dart';
import 'package:astroverse/res/colors/project_colors.dart';
import 'package:astroverse/res/decor/button_decor.dart';
import 'package:astroverse/res/dims/global.dart';
import 'package:astroverse/res/img/images.dart';
import 'package:astroverse/res/strings/ask_screen_strings.dart';
import 'package:astroverse/res/textStyles/text_styles.dart';
import 'package:astroverse/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AskScreenPortrait extends StatelessWidget {
  final BoxConstraints cons;

  const AskScreenPortrait({super.key, required this.cons});

  @override
  Widget build(BuildContext context) {
    final AuthController auth = Get.put(AuthController());
    final double wd = cons.maxWidth;
    final double ht = cons.maxHeight;
    return Scaffold(
      backgroundColor: ProjectColors.background,
      body: SingleChildScrollView(
        child: Container(
          width: wd,
          height: ht,
          padding: const EdgeInsets.symmetric(
              horizontal: GlobalDims.horizontalPadding,
              vertical: GlobalDims.verticalPaddingExtra),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Expanded(child: Image(image: ProjectImages.appLogo)),
              Text(
                AskScreenStrings.title,
                style: TextStylesLight().header,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                AskScreenStrings.subTitle,
                style: TextStylesLight().subtitle,
                overflow: TextOverflow.visible,
              ),
              const SizedBox(
                height: 30,
              ),
              MaterialButton(
                  onPressed: () => navigateToUserLogin(),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: ButtonDecors.outlined,
                  child: Text(
                    "User",
                    style: TextStylesLight().onButton,
                  )),
              const SizedBox(
                height: 15,
              ),
              MaterialButton(
                onPressed: navigateToAstroLogin,
                padding: const EdgeInsets.symmetric(vertical: 15),
                color: ProjectColors.main,
                shape: ButtonDecors.filled,
                child: Text(
                  "Astrologer",
                  style: TextStyleDark().onButton,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void navigateToUserLogin() {
    Get.toNamed(Routes.userLogin);
  }

  void navigateToAstroLogin() {
    Get.toNamed(Routes.astroLogin);
  }
}
