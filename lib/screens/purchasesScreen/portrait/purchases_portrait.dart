import 'package:astroverse/components/purchase_item.dart';
import 'package:astroverse/controllers/auth_controller.dart';
import 'package:astroverse/controllers/purchase_controller.dart';
import 'package:astroverse/res/colors/project_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PurchasesPortrait extends StatelessWidget {
  final BoxConstraints cons;

  const PurchasesPortrait({super.key, required this.cons});

  @override
  Widget build(BuildContext context) {
    final searchText = TextEditingController();
    final PurchaseController purchase = Get.put(PurchaseController());
    final AuthController auth = Get.find();
    final user = auth.user.value!;
    purchase.fetchPurchases(user.uid);

    return Scaffold(
        backgroundColor: const Color(0xffefefef),
        body: Stack(children: [
          Obx(() {
            final list = purchase.purchaseList;
            return Padding(
              padding: const EdgeInsets.only(left: 5, right: 5, top: 10),
              child: ListView.separated(
                itemBuilder: (context, index) => index == 0
                    ? const SizedBox(
                        height: 60,
                      )
                    : PurchaseItem(purchase: list[index - 1]),
                itemCount: list.length + 1,
                separatorBuilder: (context, index) => const SizedBox(
                  height: 10,
                ),
              ),
            );
          }),
          _buildSearchBox(searchText)
        ]));
  }

  Container _buildSearchBox(TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 60,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: TextField(
        controller: controller,
        decoration: const InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              color: Colors.blue,
            ),
            border: InputBorder.none,
            hintText: 'Search for "received"',
            hintStyle: TextStyle(fontSize: 14, color: ProjectColors.disabled)),
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}
