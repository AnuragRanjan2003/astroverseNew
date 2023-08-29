import 'package:firebase_auth/firebase_auth.dart';

abstract class PhoneAuthCallbacks {
  int? resendToken;
  void onVerificationComplete(PhoneAuthCredential credentials);

  void onVerificationFailed(FirebaseAuthException exception);

  void onCodeSent(String code, int? token);

  void codeAutoRetrievalTimeout(String code);
}
