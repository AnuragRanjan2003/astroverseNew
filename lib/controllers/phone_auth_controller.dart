import 'dart:async';
import 'dart:developer';

import 'package:astroverse/repo/auth_repo.dart';
import 'package:astroverse/utils/phone_auth_callbacks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class PhoneAuthController extends GetxController {
  static const String _tag = "PHONE AUTH";
  final AuthRepo _repo = AuthRepo();
  Rx<String> phone = Rx("");
  Rx<String> otpEntered = Rx("");
  String? receivedOtp;
  Rx<int> resendTimer = 120.obs;
  Timer? timer;
  Rx<bool> sendOtpLoading = false.obs;
  Rx<bool> verifyOtpLoading = false.obs;

  void sendOtp(PhoneAuthCallbacks callbacks, String number) {
    _repo.sendOtp(callbacks, number).then((_) {
      startTimer();
      log("done", name: "OTP SENT");
    }).onError((error, stackTrace) {});
  }

  checkOtp(PhoneAuthCredential cred, void Function() onVerified,
      void Function() onFailed) {
    _repo.checkOTP(cred).then((value) {
      if (value == true) {
        log("phone verified", name: _tag);
        onVerified();
      } else {
        onFailed();
        log("phone not ", name: _tag);
      }
    });
  }

  startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendTimer.value == 0) {
        timer.cancel();
      } else {
        resendTimer.value = resendTimer.value - 1;
      }
    });
  }

  resetTimer() {
    resendTimer.value = 120;
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}
