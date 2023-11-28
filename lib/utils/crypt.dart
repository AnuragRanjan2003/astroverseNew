import 'package:encrypt/encrypt.dart';

class Crypt {
    static const _keyString = "Your16CharacterK";
    static const _ivString = "Your16CharacterK";

    String _decrypt(Encrypted encryptedData) {
        final key = Key.fromUtf8(_keyString);
        final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
        final initVector = IV.fromUtf8(_ivString);
        return encrypter.decrypt(encryptedData, iv: initVector);
    }

    Encrypted _encrypt(String plainText) {
        final key = Key.fromUtf8(_keyString);
        final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
        final initVector = IV.fromUtf8(_ivString);
        Encrypted encryptedData = encrypter.encrypt(plainText, iv: initVector);
        return encryptedData;
    }

    String encryptToBase64String(String text) => _encrypt(text).base64;

    String decryptFromBase64String(String encryptedString) =>
        _decrypt(Encrypted.fromBase64(encryptedString));
}
