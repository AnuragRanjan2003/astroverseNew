import 'package:astroverse/screens/ask/ask_screen.dart';
import 'package:astroverse/screens/astroLogIn/astro_login_screen.dart';
import 'package:astroverse/screens/astroSelectPlan/astro_select_plan.dart';
import 'package:astroverse/screens/astroSignUp/astro_signup_screen.dart';
import 'package:astroverse/screens/createPost/create_post_screen.dart';
import 'package:astroverse/screens/createService/create_service_screen.dart';
import 'package:astroverse/screens/emailverfication/email_verification_screen.dart';
import 'package:astroverse/screens/main/main_screen.dart';
import 'package:astroverse/screens/mart_item_full/mart_item_full_screen.dart';
import 'package:astroverse/screens/moreProfile/more_profile_screen.dart';
import 'package:astroverse/screens/otpScreen/otp_screen.dart';
import 'package:astroverse/screens/phoneAuth/phone_auth_screen.dart';
import 'package:astroverse/screens/post_full_screen/post_full_screen.dart';
import 'package:astroverse/screens/profile/profile_screen.dart';
import 'package:astroverse/screens/public_profile/public_profile_screen.dart';
import 'package:astroverse/screens/purchasesScreen/purchases_screen.dart';
import 'package:astroverse/screens/askLocationScreen/ask_location_screen.dart';
import 'package:astroverse/screens/userLogin/user_login_screen.dart';
import 'package:astroverse/screens/userSignUp/user_sign_up_screen.dart';
import 'package:get/get.dart';

class Routes {
  static const userLogin = '/user_login';
  static const userSignup = '/sign_up';
  static const main = '/main';
  static const moreProfile = '/more_profile';
  static const emailVerify = '/email_verify';
  static const ask = '/';
  static const profile = '/profile';
  static const astroLogin = '/astro_login';
  static const astroSignUp = '/astro_signup';
  static const astroSelectPlan = '/astro_select_plan';
  static const phoneAuth = '/phone_auth';
  static const otpScreen = '/otp';
  static const upiScreen = '/upi';
  static const postFullScreen = '/post_full_screen';
  static const createPostScreen = '/create_post_screen';
  static const martItemFullScreen = '/mart_item_full_screen';
  static const createServiceScreen = '/create_service_screen';
  static const publicProfile = '/public_profile_screen';
  static const purchasesScreen = '/purchases_screen';
  static const purchaseFullScreen = '/purchase_full_screen';
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
        GetPage(
          name: Routes.astroLogin,
          page: () => const AstroLogInScreen(),
        ),
        GetPage(
          name: Routes.astroSignUp,
          page: () => const AstroSignUpScreen(),
        ),
        GetPage(
          name: Routes.astroSelectPlan,
          page: () => const AstroSelectPlan(),
        ),
        GetPage(
          name: Routes.phoneAuth,
          page: () => const PhoneAuthScreen(),
        ),
        GetPage(
          name: Routes.otpScreen,
          page: () => const OtpScreen(),
        ),
        GetPage(
          name: Routes.upiScreen,
          page: () => const EnterUpiScreen(),
        ),
        GetPage(
          name: Routes.postFullScreen,
          page: () => const PostFullScreen(),
        ),
        GetPage(
          name: Routes.createPostScreen,
          page: () => const CreatePostScreen(),
        ),
        GetPage(
          name: Routes.martItemFullScreen,
          page: () => const MartItemFullScreen(),
        ),
        GetPage(
          name: Routes.createServiceScreen,
          page: () => const CreateServiceScreen(),
        ),
        GetPage(
          name: Routes.publicProfile,
          page: () => const PublicProfileScreen(),
        ),
        GetPage(
          name: Routes.purchasesScreen,
          page: () => const PurchasesScreen(),
        ),
        GetPage(
          name: Routes.purchaseFullScreen,
          page: () => const PostFullScreen(),
        ),
      ];
}
