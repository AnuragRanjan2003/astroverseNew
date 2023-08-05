import 'package:astroverse/screens/userLogin/landscape/user_login_landscape.dart';
import 'package:astroverse/screens/userLogin/portrait/user_login_portrait.dart';
import 'package:astroverse/utils/responsive.dart';
import 'package:flutter/material.dart';

class UserLoginScreen extends StatelessWidget {
  const UserLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive(
      portrait: (cons) => UserLoginScreenPortrait(cons: cons),
      landscape: (cons) => UserLoginScreenLandscape(cons: cons),
    );
  }
}
