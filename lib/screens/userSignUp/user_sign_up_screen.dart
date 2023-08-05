import 'package:astroverse/screens/userLogin/landscape/user_login_landscape.dart';
import 'package:astroverse/screens/userSignUp/portrait/user_signup_portrait.dart';
import 'package:astroverse/utils/responsive.dart';
import 'package:flutter/material.dart';

class UserSignUpScreen extends StatelessWidget {
  const UserSignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive(
      portrait: (cons) => UserSignUpPortrait(cons: cons),
      landscape: (cons) => UserLoginScreenLandscape(cons: cons),
    );
  }
}
