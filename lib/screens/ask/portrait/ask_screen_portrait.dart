import 'package:astroverse/controllers/auth_controller.dart';
import 'package:astroverse/res/colors/project_colors.dart';
import 'package:astroverse/res/decor/button_decor.dart';
import 'package:astroverse/res/dims/global.dart';
import 'package:astroverse/res/strings/ask_screen_strings.dart';
import 'package:astroverse/res/textStyles/text_styles.dart';
import 'package:astroverse/screens/astroLogIn/astro_login_screen.dart';
import 'package:astroverse/screens/userLogin/user_login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
              Expanded(child: SvgPicture.asset('lib/assets/svg/welcome.svg' , fit: BoxFit.fitWidth,)),
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
                  onPressed: () => navigateToUserLogin(context),
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
                onPressed: () => navigateToAstroLogin(context),
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

  void navigateToUserLogin(BuildContext context) {
    //Get.toNamed(Routes.userLogin);
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const UserLoginScreen(),
    ));
  }

  void navigateToAstroLogin(BuildContext context) {
    //Get.toNamed(Routes.astroLogin);
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const AstroLogInScreen(),
    ));
  }
}
