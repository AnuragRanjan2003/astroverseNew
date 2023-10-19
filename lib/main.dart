import 'package:astroverse/firebase_options.dart';
import 'package:astroverse/res/colors/project_colors.dart';
import 'package:astroverse/routes/routes.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final app = await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance
      .activate(androidProvider: AndroidProvider.playIntegrity);
  final analytics = FirebaseAnalytics.instanceFor(app: app);
  analytics.logLogin(loginMethod: "Email");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
