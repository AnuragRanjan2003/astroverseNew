import 'dart:developer';

import 'package:encrypt/encrypt.dart';

class Crypt {
  static String? _keyString;
  static String? _ivString;

  static initialize(String key) {
    _keyString = key;
    _ivString = key;
  }

  String _decrypt(Encrypted encryptedData) {
    final key = Key.fromUtf8(_keyString!);
    final iv = IV.fromUtf8(_keyString!);
    log("decrypting : ${encryptedData.base64}", name: "CRYPT");
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    return encrypter.decrypt(encryptedData, iv: iv);
  }

  Encrypted _encrypt(String plainText) {
    final key = Key.fromUtf8(_keyString!);
    final iv = IV.fromUtf8(_keyString!);
    log("encrypting : $plainText", name: "CRYPT");
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    Encrypted encryptedData = encrypter.encrypt(plainText, iv: iv);
    return encryptedData;
  }

  String encryptToBase64String(String text) => _encrypt(text).base64;

  String decryptFromBase64String(String encryptedString) =>
      _decrypt(Encrypted.fromBase64(encryptedString));
}
