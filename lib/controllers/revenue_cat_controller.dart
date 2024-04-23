import 'dart:developer';

import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class RevenueCatController extends GetxController {
  Rxn<Offerings> offerings = Rxn();
  RxList<StoreProduct> products = RxList();


  static const _astroProductIdentifiers = [
    "0astro_disha",
    "1astro_kripa",
  ];

  static const _userIdentifiers = [
    "user_premium",
  ];

  _startListeningForEntitlementChanges(Function(CustomerInfo) updateDb) {
    Purchases.addCustomerInfoUpdateListener((customerInfo) {
      updateDb(customerInfo);
    });
  }

  Future<void> initialize(bool debugMode, String apiKey) async {
    if (debugMode) await Purchases.setLogLevel(LogLevel.debug);
    final config = PurchasesConfiguration(apiKey);
    await Purchases.configure(config);
  }

  Future<void> logIn(
      String uid, Function(CustomerInfo) onCustomerInfoChange) async {
    try {
      await Purchases.logIn(uid);
      _startListeningForEntitlementChanges((p0) {
        onCustomerInfoChange(p0);
      });
    } catch (e) {}
  }

  purchaseProduct(StoreProduct product, Function() updateDb) async {
    try {
      final customerInfo = await Purchases.purchaseStoreProduct(product);
      if (customerInfo.entitlements.active.containsKey("astro disha")) {
        log("astro disha entitlement active", name: "Entitlement");
        updateDb();
      }
    } catch (e) {
      log(e.toString(), name: "Entitlement");
    }
  }

  Future<CustomerInfo> refreshCustomerInfo() async {
    return await Purchases.getCustomerInfo();
  }

  Future<void> getProductsForAstrologer() async {
    final $products = await Purchases.getProducts(_astroProductIdentifiers);

    products.value = $products;

    log($products.toString(), name: "PRODUCTS");
  }

  Future<void> getProductsForUsers() async {
    final $products = await Purchases.getProducts(_userIdentifiers);

    products.value = $products;

    log($products.toString(), name: "PRODUCTS");
  }

  logout() async {
    await Purchases.logOut();
  }
}
