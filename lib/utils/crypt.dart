import 'dart:developer';

import 'package:astroverse/utils/env_vars.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Crypt {

    static String? _keyString;
    static String? _ivString;

    static initialize(String key){
        _keyString = key;
        _ivString = key;
    }


    String _decrypt(Encrypted encryptedData) {
        final key = Key.fromUtf8(_keyString!);
        log("decrypting : ${encryptedData.base64}" , name:"CRYPT");
        final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
        final initVector = IV.fromUtf8(_ivString!);
        return encrypter.decrypt(encryptedData, iv: initVector);
    }

    Encrypted _encrypt(String plainText) {
        final key = Key.fromUtf8(_keyString!);
        log("encrypting : $plainText" , name:"CRYPT");
        final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
        final initVector = IV.fromUtf8(_ivString!);
        Encrypted encryptedData = encrypter.encrypt(plainText, iv: initVector);
        return encryptedData;
    }

    String encryptToBase64String(String text) => _encrypt(text).base64;

    String decryptFromBase64String(String encryptedString) =>
        _decrypt(Encrypted.fromBase64(encryptedString));
}
