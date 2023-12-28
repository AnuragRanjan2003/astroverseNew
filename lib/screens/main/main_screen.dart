import 'package:astroverse/controllers/in_app_purchase_controller.dart';
import 'package:astroverse/controllers/main_controller.dart';
import 'package:astroverse/db/coins_data_db.dart';
import 'package:astroverse/screens/main/landscape/main_screen_landscape.dart';
import 'package:astroverse/screens/main/portrait/main_screen_portrait.dart';
import 'package:astroverse/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../controllers/auth_controller.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final main = Get.put(MainController());
    final AuthController auth = Get.find();
    main.setUser(auth.user.value);
    final iap = Get.put(InAppPurchaseController());
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
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("A purchase is pending , please don't close the app")));
  }

  _handleError(IAPError e, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Purchase Failed : ${e.message}")));
  }

  _handleCancelation(PurchaseDetails p0, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Purchase Canceled : ${p0.productID}")));
  }
}
