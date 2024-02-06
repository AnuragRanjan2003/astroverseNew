import 'dart:developer';

import 'package:astroverse/controllers/in_app_purchase_controller.dart';
import 'package:astroverse/controllers/main_controller.dart';
import 'package:astroverse/db/coins_data_db.dart';
import 'package:astroverse/res/colors/project_colors.dart';
import 'package:astroverse/routes/routes.dart';
import 'package:astroverse/screens/main/landscape/main_screen_landscape.dart';
import 'package:astroverse/screens/main/portrait/main_screen_portrait.dart';
import 'package:astroverse/utils/crypt.dart';
import 'package:astroverse/utils/env_vars.dart';
import 'package:astroverse/utils/responsive.dart';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart' as c;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../controllers/auth_controller.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late MainController main;
  late AuthController auth;
  late InAppPurchaseController iap;
  final crypto = Crypt();

  @override
  Widget build(BuildContext context) {
    main.setUser(auth.user.value);

    iap.attachEventHandler(
      (p0) => _handleSuccessfulPurchase(p0, auth, context),
      (p0) => _handlePendingPurchase(p0, auth, context),
      (p0) => _handleError(p0, context),
      (p0) => _handleCancelation(p0, context),
    );

    return Responsive(
        portrait: (cons) => MainScreenPortrait(cons: cons),
        landscape: (cons) => MainScreenLandscape(cons: cons));
  }

  void _handleSuccessfulPurchase(
      details, AuthController auth, BuildContext context) {
    final coin = CoinsData()
        .coins
        .firstWhere((element) => element.productId == details.productID);
    auth.giveCoinsToUser(coin.number, auth.user.value!.uid, (p0) {
      Navigator.pop(context);
      if (p0.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("${coin.number} coins have been credited")));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("failed to buy coins")));
      }
    });
  }

  _handlePendingPurchase(
      PurchaseDetails p0, AuthController auth, BuildContext context) {
    showLoadingDialog(context);
  }

  _handleError(IAPError e, BuildContext context) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Purchase Failed : ${e.message}")));
  }

  _handleCancelation(PurchaseDetails p0, BuildContext context) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Purchase Canceled : ${p0.productID}")));
  }

  showLoadingDialog(BuildContext context) {
    final dialog = AlertDialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 80),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      title: const Text(
        "Payment pending",
        style: TextStyle(fontSize: 14),
      ),
      content: Container(
        height: 100,
        color: Colors.transparent,
        child: const Center(
          child: CircularProgressIndicator(
            color: ProjectColors.primary,
            strokeWidth: 1.5,
          ),
        ),
      ),
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => dialog,
    );
  }

  @override
  void initState() {
    auth = Get.find();
    main = Get.put(MainController());
    iap = Get.put(InAppPurchaseController());
    Get.clearRouteTree();
    super.initState();
  }
}
