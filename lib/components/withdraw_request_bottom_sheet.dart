import 'package:astroverse/models/user.dart';
import 'package:astroverse/models/withdraw_request.dart';
import 'package:astroverse/res/colors/project_colors.dart';
import 'package:flutter/material.dart';
import 'package:shortid/shortid.dart';

class WithdrawRequestBottomSheet extends StatefulWidget {
  final User user;
  final Function(WithdrawRequest wr) onConfirm;

  const WithdrawRequestBottomSheet(
      {super.key, required this.user, required this.onConfirm});

  @override
  State<WithdrawRequestBottomSheet> createState() =>
      _WithdrawRequestBottomSheetState();
}

class _WithdrawRequestBottomSheetState
    extends State<WithdrawRequestBottomSheet> {
  late TextEditingController amt;
  late String error;

  @override
  void initState() {
    super.initState();
    amt = TextEditingController(text: "500.00");
    error = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Request Withdraw",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "A withdraw request will be sent to the server and will be verified and credited in due course of time.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(
              height: 28,
            ),
            TextField(
              controller: amt,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  errorText: error.isNotEmpty ? error : null,
                  labelText: "amount",
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: ProjectColors.primary)),
                  hintText: "Enter withdraw amount",
                  hintStyle: const TextStyle(color: ProjectColors.disabled)),
            ),
            const SizedBox(
              height: 20,
            ),
            MaterialButton(
              onPressed: () {
                double amount = double.parse(amt.value.text.trim());
                if (amount <= 500) {
                  setState(() {
                    error = "please provide a larger amount";
                  });
                  return;
                }

                final req = WithdrawRequest(
                    shortid.generate(),
                    widget.user.name,
                    widget.user.uid,
                    amount,
                    DateTime.now(),
                    null,
                    WithdrawStatus.pending);

                widget.onConfirm(req);
              },
              color: ProjectColors.primary,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: const Text(
                "Send Request",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
