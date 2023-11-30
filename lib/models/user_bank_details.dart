import 'package:astroverse/utils/crypt.dart';

class UserBankDetails {
  String accountNumber;
  String ifscCode;
  String branch;
  String upiId;

  UserBankDetails({
    required this.accountNumber,
    required this.ifscCode,
    required this.branch,
    required this.upiId,
  });

  factory UserBankDetails.fromJson(json) => UserBankDetails(
        accountNumber: json['accountNumber'] as String,
        ifscCode: json['ifscCode'] as String,
        branch: json['branch'] as String,
        upiId: json['upiId'] as String,
      );

  Map<String, dynamic> toJson() => {
        'accountNumber': encryptString(accountNumber),
        'ifscCode': encryptString(ifscCode),
        'branch': encryptString(branch),
        'upiId': encryptString(upiId),
      };

  static encryptString(String text) {
    final crypto = Crypt();
    return crypto.encryptToBase64String(text);
  }

  static decryptString(String encoded) {
    final crypto = Crypt();
    return crypto.decryptFromBase64String(encoded);
  }

  bool areValid() {
    if (upiId.isEmpty &&
        (accountNumber.isEmpty || ifscCode.isEmpty || branch.isEmpty)) {
      return false;
    }
    return true;
  }

  UserBankDetails decrypted() {
    return UserBankDetails(
        accountNumber: decryptString(accountNumber),
        ifscCode: decryptString(ifscCode),
        branch: decryptString(branch),
        upiId: decryptString(upiId));
  }

  bool isUnchanged(String acc, String ifsc, String branch, String upi) {
    return (acc == accountNumber &&
        ifsc == ifscCode &&
        branch == this.branch &&
        upi == upiId);
  }
}
