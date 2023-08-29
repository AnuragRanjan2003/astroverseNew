import 'dart:developer';

import 'package:astroverse/utils/phone_auth_callbacks.dart';
import 'package:firebase_auth_platform_interface/src/firebase_auth_exception.dart';
import 'package:firebase_auth_platform_interface/src/providers/phone_auth.dart';

class OTPPhoneCallbacks extends PhoneAuthCallbacks {
  static const String _tag = "OTP";

  @override
  int? resendToken = 0;

  final void Function(String code) doAfterCodeSent;
  final void Function(String error) onFail;

  OTPPhoneCallbacks(this.doAfterCodeSent, this.onFail);

  @override
  void codeAutoRetrievalTimeout(String code) {
    logIt("timeout");
  }

  @override
  void onCodeSent(String code, int? token) {
    logIt("code sent");
    logIt(" $code");
    resendToken = token;
    logIt(" resend token : $token");
    doAfterCodeSent(code);
  }

  @override
  void onVerificationComplete(PhoneAuthCredential credentials) {
    logIt("complete");
  }

  @override
  void onVerificationFailed(FirebaseAuthException exception) {
    onFail(exception.message.toString());
    logIt("failed : ${exception.message}");
  }

  void logIt(String msg) {
    log(msg, name: _tag);
  }
}
