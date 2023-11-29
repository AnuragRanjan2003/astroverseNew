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
        'accountNumber': accountNumber,
        'ifscCode': ifscCode,
        'branch': branch,
        'upiId': upiId,
      };
}
