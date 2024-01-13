import 'package:astroverse/firebase_options.dart';
import 'package:astroverse/res/colors/project_colors.dart';
import 'package:astroverse/routes/routes.dart';
import 'package:astroverse/screens/ask/ask_screen.dart';
import 'package:astroverse/screens/on_boarding/on_boarding_screen.dart';
import 'package:astroverse/utils/crypt.dart';
import 'package:astroverse/utils/env_vars.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

void main() async {
  final navigatorKey = GlobalKey<NavigatorState>();
  WidgetsFlutterBinding.ensureInitialized();
  final app = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform);

  await dotenv.load(fileName: '.env');
  final pref = await SharedPreferences.getInstance();
  final firstTime = pref.getBool("first_time") ?? true;
  Crypt.initialize(dotenv.get(EnvVars.cryptKey));

  final analytics = FirebaseAnalytics.instanceFor(app: app);
  analytics.logEvent(name: "login");
  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);
  runApp(MyApp(
    navigatorKey: navigatorKey,
    firstTime: firstTime,
  ));
}

class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final bool firstTime;

  const MyApp({super.key, required this.navigatorKey, required this.firstTime});

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
 
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    observer.analytics.logLogin(loginMethod: "gmail");
    analytics.logLogin(loginMethod: "Email");

    return GetMaterialApp(
      title: 'Flutter Demo',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      getPages: AppRoutes.getPages,
      home: firstTime ? const OnBoardingScreen() : const AskScreen(),
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: ProjectColors.primary),
        disabledColor: ProjectColors.disabled,
        progressIndicatorTheme: const ProgressIndicatorThemeData(color: ProjectColors.primary),
        useMaterial3: true,
      ),
    );
  }
}
