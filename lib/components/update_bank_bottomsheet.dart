import 'package:astroverse/controllers/auth_controller.dart';
import 'package:astroverse/models/user_bank_details.dart';
import 'package:astroverse/res/colors/project_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateBankBottomSheet extends StatefulWidget {
  final UserBankDetails bankDetails;

  const UpdateBankBottomSheet({super.key, required this.bankDetails});

  @override
  State<UpdateBankBottomSheet> createState() =>
      _UpdateBankBottomSheetState(bankDetails);
}

class _UpdateBankBottomSheetState extends State<UpdateBankBottomSheet> {
  final UserBankDetails _bankDetails;
  final AuthController auth = Get.find();

  _UpdateBankBottomSheetState(this._bankDetails);

  @override
  void dispose() {
    auth.disableAccountUpdate.value = true;
    auth.clearError();
    super.dispose();
  }

  @override
  void initState() {
    auth.disableAccountUpdate.value = _disableButton(_bankDetails.upiId,
        _bankDetails.accountNumber, _bankDetails.ifscCode, _bankDetails.branch);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final upi = TextEditingController(text: _bankDetails.upiId);
    final account = TextEditingController(text: _bankDetails.accountNumber);
    final ifsc = TextEditingController(text: _bankDetails.ifscCode);
    final branch = TextEditingController(text: _bankDetails.branch);

    upi.addListener(() {
      auth.disableAccountUpdate.value = _disableButton(upi.value.text,
          account.value.text, ifsc.value.text, branch.value.text);
    });
    account.addListener(() {
      auth.disableAccountUpdate.value = _disableButton(upi.value.text,
          account.value.text, ifsc.value.text, branch.value.text);
    });
    ifsc.addListener(() {
      auth.disableAccountUpdate.value = _disableButton(upi.value.text,
          account.value.text, ifsc.value.text, branch.value.text);
    });
    branch.addListener(() {
      auth.disableAccountUpdate.value = _disableButton(upi.value.text,
          account.value.text, ifsc.value.text, branch.value.text);
    });

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Update bank details",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    color: ProjectColors.lightBlack,
                    fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Obx(() {
              return editField(upi, Icons.account_balance_wallet, "upi Id",
                  "UPI", auth.upiError.value);
            }),
            const SizedBox(
              height: 20,
            ),
            Obx(() {
              return editField(account, Icons.numbers_sharp, "upi Id", "A/C",
                  auth.accError.value);
            }),
            const SizedBox(
              height: 20,
            ),
            Obx(() {
              return editField(
                  ifsc, Icons.numbers, "upi Id", "IFSC", auth.ifscError.value);
            }),
            const SizedBox(
              height: 20,
            ),
            Obx(() {
              return editField(branch, Icons.alt_route_outlined, "upi Id",
                  "Branch", auth.branchError.value);
            }),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Obx(() {
                return MaterialButton(
                  onPressed: auth.disableAccountUpdate.isTrue
                      ? null
                      : () {
                          _handelUpdate(
                              upi.value.text,
                              account.value.text,
                              ifsc.value.text,
                              branch.value.text,
                              auth.user.value!.uid);
                        },
                  color: Colors.blue,
                  disabledColor: ProjectColors.disabled,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: const Text(
                    "Update",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                );
              }),
            )
          ],
        ),
      ),
    );
  }

  void _handelUpdate(
      String upi, String ac, String ifsc, String branch, String userId) {
    final data = UserBankDetails(
        accountNumber: ac, ifscCode: ifsc, branch: branch, upiId: upi);
    auth.addUserBankDetails(data, userId, (p0) => _handelSuccess(p0.data),
        (p0) => _handelFailure(p0));
  }

  bool _disableButton(String upi, String acc, String ifsc, String branch) {
    auth.clearError();
    if (_bankDetails.isUnchanged(acc, ifsc, branch, upi)) return true;
    if (auth.user.value == null) return true;
    if (upi.isEmpty && (acc.isEmpty || ifsc.isEmpty || branch.isEmpty)) {
      return true;
    }
    if (acc.length < 10 || acc.length > 20) {
      auth.accError.value = "length too ${acc.length < 10 ? "short" : "long"}";
      return true;
    }
    if (!upi.contains('@')) {
      auth.upiError.value = "must contain '@'";
      return true;
    }
    return false;
  }

  void _handelSuccess(UserBankDetails p0) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("updated")));
  }

  void _handelFailure(String err) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Failed : $err")));
  }

  Container editField(TextEditingController upi, IconData icon, String hint,
      String label, String? error) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
          border: Border.all(
              color: error != null ? Colors.red : ProjectColors.disabled,
              width: 1)),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 5),
            child: Icon(
              icon,
              color: Colors.blue,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 30),
            child: Text(
              label,
              style: const TextStyle(
                  fontSize: 15,
                  color: ProjectColors.disabled,
                  fontWeight: FontWeight.w500),
            ),
          ),
          const Divider(
            color: Colors.blue,
            thickness: 10,
          ),
          Expanded(
            child: TextField(
              controller: upi,
              textAlign: TextAlign.end,
              keyboardType: label == "A/C" ? TextInputType.number : null,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                errorText: error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
