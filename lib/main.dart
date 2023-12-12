import 'dart:developer';

import 'package:astroverse/controllers/location_controller.dart';
import 'package:astroverse/firebase_options.dart';
import 'package:astroverse/res/colors/project_colors.dart';
import 'package:astroverse/routes/routes.dart';
import 'package:astroverse/utils/crypt.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

void main() async {
  final navigatorKey = GlobalKey<NavigatorState>();
  WidgetsFlutterBinding.ensureInitialized();
  final app = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: '.env');


  final analytics = FirebaseAnalytics.instanceFor(app: app);
  analytics.logEvent(name: "login");
  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);
  runApp(MyApp(
    navigatorKey: navigatorKey,
  ));
}

class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const MyApp({super.key, required this.navigatorKey});

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    observer.analytics.logLogin(loginMethod: "gmail");
    analytics.logLogin(loginMethod: "Email");
    Get.put(LocationController());
    return GetMaterialApp(
      title: 'Flutter Demo',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      getPages: AppRoutes.getPages,
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: ProjectColors.primary),
        useMaterial3: true,
      ),
    );
  }
}
