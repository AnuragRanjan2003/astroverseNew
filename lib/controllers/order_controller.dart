import 'dart:async';
import 'dart:developer';

import 'package:astroverse/models/purchase.dart';
import 'package:astroverse/models/service.dart';
import 'package:astroverse/repo/orders_repo.dart';
import 'package:astroverse/res/strings/backend_strings.dart';
import 'package:astroverse/utils/constants.dart';
import 'package:astroverse/utils/crypt.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  final _repo = OrderRepo();

  Rxn<Service> service = Rxn();
  RxString enteredCode = "".obs;
  RxBool confirming = false.obs;
  Rxn<Purchase> purchase = Rxn();
  RxBool checkBox = false.obs;
  RxBool serviceDeleted = false.obs;
  RxBool cancelingPurchase = false.obs;

  StreamSubscription<DocumentSnapshot<Purchase?>>? _purchaseSub;

  @override
  void onClose() {
    service.value = null;
    _purchaseSub?.cancel();
  }

  processConfirmation(String enteredCode, String codeHash, Function() onFail,
      Purchase purchase, String currentUserId) {
    enteredCode = "order_$enteredCode";
    enteredCode = enteredCode.trim();
    codeHash = codeHash.trim();
    log(enteredCode, name: "ORDER CODE");
    final enteredCodeHash = Crypt().encryptToBase64String(enteredCode);
    if (enteredCodeHash != codeHash) {
      log("not match", name: "ORDER CODE");
      log("$enteredCode || $codeHash ", name: "CODE MATCH");
      this.enteredCode.value = "";
      onFail();

      return;
    }

    confirming.value = true;

    _repo
        .confirmDelivery(
            purchase.purchaseId,
            purchase.buyerId,
            purchase.sellerId,
            _computeAmountToSeller(true, double.parse(purchase.itemPrice)))
        .then((value) {
      confirming.value = false;
      if (value.isSuccess) {
        Get.snackbar("confirmed", "delivery was confirmed successfully");
      } else {
        Get.snackbar("Error", "delivery could not be confirmed");
      }
    });
  }

  Future<void>? stopPurchaseStream() => _purchaseSub?.cancel();

  startPurchaseStream(
      String currentUid, String purchaseId, Function(Purchase? p) onChange) {
    _purchaseSub =
        _repo.purchaseStream(currentUid, purchaseId).listen((snapshot) {
      purchase.value = snapshot.data();
      onChange(snapshot.data());
    });
  }

  fetchService(String uid, String serviceId) {
    serviceDeleted.value = false;
    _repo.fetchService(uid, serviceId).then((value) {
      if (value.isSuccess) {
        value = value as Success<Service>;
        service.value = value.data;
        log(value.data.toString(), name: "SERVICE FETCH");
      } else {
        value = value as Failure<Service>;
        service.value = null;
        log(value.error, name: "SERVICE FETCH");
        serviceDeleted.value = value.error == Errors.docNotFound;
      }
    });
  }

  cancelPurchase(
      String id, String buyerId, String sellerId, Function(Resource) updateUI) {
    cancelingPurchase.value = true;
    _repo.cancelPurchase(id, buyerId, sellerId).then((value) {
      cancelingPurchase.value = false;
      updateUI(value);
    });
  }

  double _computeAmountToSeller(bool chargeConvenience, double amount) {
    if (chargeConvenience) {
      return amount - Constants.appConvenienceFee;
    } else {
      return amount;
    }
  }
}
