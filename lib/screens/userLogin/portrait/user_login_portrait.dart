import 'package:astroverse/components/textbox.dart';
import 'package:astroverse/res/colors/project_colors.dart';
import 'package:astroverse/res/decor/button_decor.dart';
import 'package:astroverse/res/dims/global.dart';
import 'package:astroverse/res/strings/user_login_strings.dart';
import 'package:astroverse/res/textStyles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserLoginScreenPortrait extends StatelessWidget {
  final BoxConstraints cons;

  const UserLoginScreenPortrait({super.key, required this.cons});

  @override
  Widget build(BuildContext context) {
    final double wd = cons.maxWidth;
    final double ht = cons.maxHeight;
    final TextEditingController email = TextEditingController();
    final TextEditingController password = TextEditingController();
    return Scaffold(
      backgroundColor: ProjectColors.background,
      body: SingleChildScrollView(
        child: Container(
          height: ht,
          width: wd,
          padding: const EdgeInsets.symmetric(
              horizontal: GlobalDims.horizontalPadding,
              vertical: GlobalDims.verticalPaddingExtra),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                UserLoginStrings.title,
                style: TextStylesLight().header,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                UserLoginStrings.subTitle,
                style: TextStylesLight().subtitle,
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                "Email",
                style: TextStylesLight().bodyBold,
              ),
              const SizedBox(
                height: 8,
              ),
              TextBox(label: "Enter your Email", controller: email),
              const SizedBox(
                height: 30,
              ),
              Text(
                "Password",
                style: TextStylesLight().bodyBold,
              ),
              const SizedBox(
                height: 8,
              ),
              TextBox(
                label: "Enter your Password",
                controller: password,
                password: true,
              ),
              const SizedBox(
                height: 20,
              ),
              MaterialButton(
                onPressed: () {},
                shape: ButtonDecors.filled,
                color: ProjectColors.main,
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  "Log In",
                  style: TextStylesLight().onButton
                ),
              ),
              const SizedBox(height: 10,),
              MaterialButton(
                onPressed: () {},
                shape: ButtonDecors.outlined,
                padding: const EdgeInsets.symmetric( vertical: 12),
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const FaIcon(FontAwesomeIcons.google , color: ProjectColors.primary,size: 18,),
                    const SizedBox(width: 10,),
                    Text("Google" , style: TextStylesLight().onButton,),
                  ],
                ),
              ),
              Text(UserLoginStrings.signup ,   style: TextStylesLight().small,),
              TextButton(onPressed: (){}, child: Text("Sign Up" , style: TextStylesLight().bodyBold,textAlign: TextAlign.start,),)
            ],
          ),
        ),
      ),
    );
  }
}
