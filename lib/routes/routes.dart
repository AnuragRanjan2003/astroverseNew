import 'package:astroverse/screens/ask/ask_screen.dart';
import 'package:astroverse/screens/emailverfication/email_verification_screen.dart';
import 'package:astroverse/screens/main/main_screen.dart';
import 'package:astroverse/screens/moreProfile/more_profile_screen.dart';
import 'package:astroverse/screens/profile/profile_screen.dart';
import 'package:astroverse/screens/userLogin/user_login_screen.dart';
import 'package:astroverse/screens/userSignUp/user_sign_up_screen.dart';
import 'package:get/get.dart';

class Routes {
  static const userLogin = '/userLogin';
  static const userSignup = '/signup';
  static const main = '/main';
  static const moreProfile = '/more_profile';
  static const emailVerify = '/email_verify';
  static const ask = '/';
  static const profile = '/profile';
}

class AppRoutes {
  static List<GetPage> get getPages => [
        GetPage(
          name: Routes.ask,
          page: () => const AskScreen(),
        ),
        GetPage(
          name: Routes.userLogin,
          page: () => const UserLoginScreen(),
        ),
        GetPage(
          name: Routes.userSignup,
          page: () => const UserSignUpScreen(),
        ),
        GetPage(
          name: Routes.main,
          page: () => const MainScreen(),
        ),
        GetPage(
          name: Routes.moreProfile,
          page: () => const MoreProfileScreen(),
        ),
        GetPage(
          name: Routes.emailVerify,
          page: () => const EmailVerificationScreen(),
        ),
        GetPage(
          name: Routes.profile,
          page: () => const ProfileScreen(),
        ),
      ];
}
