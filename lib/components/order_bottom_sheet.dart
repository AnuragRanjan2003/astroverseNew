import 'package:astroverse/models/purchase.dart';
import 'package:astroverse/models/service.dart';
import 'package:astroverse/models/user.dart';
import 'package:astroverse/res/colors/project_colors.dart';
import 'package:astroverse/res/img/images.dart';
import 'package:astroverse/res/strings/other_strings.dart';
import 'package:flutter/material.dart';

class OrderBottomSheet extends StatelessWidget {
  final Purchase? purchase;
  final Service? item;
  final User? currentUser;

  const OrderBottomSheet(
      {super.key,
      required this.purchase,
      required this.item,
      this.currentUser});

  static const _borderRadius = Radius.circular(0);

  @override
  Widget build(BuildContext context) {
    var isBuyer = false;
    if (purchase != null && currentUser != null) {
      isBuyer = purchase!.buyerId == currentUser!.uid;
    }

    doOnConfirm() {}
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: _borderRadius, topLeft: _borderRadius)),
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Confirm Delivery",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: ProjectColors.lightBlack),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              isBuyer ? OtherStrings.textForBuyer : OtherStrings.textForSellers,
              style: const TextStyle(
                  color: ProjectColors.lightBlack,
                  fontSize: 13,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            isBuyer
                ? const SizedBox.shrink()
                : const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      OtherStrings.adviceForSellers,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
            const Image(
              image: ProjectImages.truck,
              height: 200,
              width: 200,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              isBuyer
                  ? OtherStrings.warningForBuyer
                  : OtherStrings.warningForSellers,
              style: const TextStyle(
                  color: Colors.red, fontSize: 13, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            isBuyer
                ? buildRow("Key", purchase!.purchaseId.toString(), Icons.key)
                : _buildTextField(
                    TextEditingController(), "password", const TextStyle()),
            const SizedBox(
              height: 10,
            ),
            isBuyer ? const SizedBox.shrink() : confirmButton(doOnConfirm ,false),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  MaterialButton confirmButton(void Function() doOnConfirm , bool isEnabled) {
    return MaterialButton(
      onPressed: isEnabled?doOnConfirm:null,
      disabledColor: ProjectColors.disabled,
      color: ProjectColors.lightBlack,
      padding: const EdgeInsets.symmetric(vertical: 14),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: const Text(
        "Confirm",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget buildRow(String label, String value, IconData icon) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Wrap(
              children: [
                Icon(
                  icon,
                  color: ProjectColors.lightBlack,
                  size: 24,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  label,
                  style: const TextStyle(
                      color: ProjectColors.lightBlack,
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Text(
              value,
              style: const TextStyle(
                  color: ProjectColors.lightBlack, fontSize: 15),
            ),
          ],
        ),
      );

  Widget _buildTextField(
      TextEditingController controller, String hint, TextStyle style) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: TextField(
        controller: controller,
        maxLength: 14,
        textAlign: TextAlign.start,
        keyboardType: TextInputType.datetime,
        decoration: InputDecoration(
          prefixText: "order_",
          border: InputBorder.none,
          prefixStyle:
              const TextStyle(color: ProjectColors.lightBlack, fontSize: 16),
          hintText: hint,
          hintStyle: const TextStyle(color: ProjectColors.disabled),
          filled: true,
        ),
      ),
    );
  }
}
