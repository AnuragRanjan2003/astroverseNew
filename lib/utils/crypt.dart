import 'package:encrypt/encrypt.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Crypty{

    final _key = Key.fromSecureRandom(128);

    String encrypt(String value){
        final iv = IV.fromLength(128);
        final enc = Encrypter(AES(_key,mode: AESMode.cbc),);
        return enc.encrypt(value,iv: iv).base64;
    }
}