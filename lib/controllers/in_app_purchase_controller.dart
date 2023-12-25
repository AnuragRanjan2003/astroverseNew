import 'dart:async';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class InAppPurchaseController extends GetxController {
  late Function(PurchaseDetails details) onPurchase;
  late Function(PurchaseDetails details) onPending;
  late Function(IAPError details) onError;
  late Function(PurchaseDetails) onCanceled;

  RxBool isActive = false.obs;
  final _iapConnection = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  RxList<ProductDetails> products = <ProductDetails>[].obs;
  RxList<PurchaseDetails> purchases = <PurchaseDetails>[].obs;
  final List<String> _consumables = <String>[
    "coins_small_pack",
    "stack_of_coins",
    "bag_of_coins"
  ];
  RxBool purchasePending = false.obs;
  RxBool loading = true.obs;

  @override
  void onInit() async {
    await initStoreInfo();
    if (isActive.isTrue) {
      log("store active", name: "IAP");
      await getProducts();
    } else {
      log("store inactive", name: "IAP");
    }

    _subscription = _iapConnection.purchaseStream.listen((event) {
      purchases.addAll(event);
      for (var element in event) {
        log("purchased ${element.productID}", name: "IAP SUB");
        if (element.status == PurchaseStatus.purchased) {
          onPurchase(element);
        } else if (element.status == PurchaseStatus.pending) {
          onPending(element);
        } else if (element.status == PurchaseStatus.error) {
          onError(element.error!);
        }else if(element.status == PurchaseStatus.canceled){
          onCanceled(element);
        }

        verifyPurchase(element.productID, () {
          log("purchased ${element.productID}", name: "IAP SUB");
        });
      }
    });
    super.onInit();
  }

  void attachEventHandler(
    Function(PurchaseDetails) onSuccessPurchase,
    Function(PurchaseDetails) onPending,
    Function(IAPError) onError,
    Function(PurchaseDetails) onCanceled,
  ) {
    onPurchase = onSuccessPurchase;
    this.onPending = onPending;
    this.onError = onError;
    this.onCanceled = onCanceled;
  }

  Future<void> initStore() async {
    await initStoreInfo();
    if (isActive.isTrue) {
      log("store active", name: "IAP");
      await getProducts();
    } else {
      log("store inactive", name: "IAP");
    }

    _subscription = _iapConnection.purchaseStream.listen((event) {
      purchases.addAll(event);
      for (var element in event) {
        if (element.status == PurchaseStatus.purchased) {
          log("purchased", name: "IAP SUB");
          onPurchase(element);
        }

        verifyPurchase(element.productID, () {
          log("purchased ${element.productID}", name: "IAP SUB");
        });
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> initStoreInfo() async {
    isActive.value = await _iapConnection.isAvailable();
  }

  Future<void> getProducts() async {
    final ids = _consumables.toSet();
    try {
      final res = await _iapConnection.queryProductDetails(ids);
      products.value = res.productDetails;
      StringBuffer sb = StringBuffer();
      for (var it in products) {
        sb.write(" ${it.title} ,");
      }
      log(sb.toString(), name: 'IAP');
    } on InAppPurchaseException catch (e) {
      log(e.message.toString(), name: "IAP PRODUCTS");
    } catch (e) {
      log(e.toString(), name: "IAP PRODUCTS");
    }
  }

  Future<void> getPastPurchases() async {}

  buyCoins(ProductDetails product) async {
    final param = PurchaseParam(productDetails: product);
    await _iapConnection.buyConsumable(purchaseParam: param);
  }

  PurchaseDetails? hasPurchased(String productId) {
    return purchases
        .firstWhereOrNull((element) => element.productID == productId);
  }

  void verifyPurchase(String id, Function() onSuccess) {
    final b = hasPurchased(id);
    if (b != null && b.status == PurchaseStatus.purchased) {
      onSuccess();
    }
  }
}
