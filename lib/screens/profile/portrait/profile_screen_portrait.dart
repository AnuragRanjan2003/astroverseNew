import 'package:astroverse/components/buy_coins.dart';
import 'package:astroverse/components/name_plate.dart';
import 'package:astroverse/controllers/auth_controller.dart';
import 'package:astroverse/models/user.dart';
import 'package:astroverse/res/colors/project_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class ProfileScreenPortrait extends StatelessWidget {
  final BoxConstraints cons;
  final User? user;

  const ProfileScreenPortrait({super.key, required this.cons, this.user});

  @override
  Widget build(BuildContext context) {
    final wd = cons.maxWidth;
    final ht = cons.maxHeight;
    final AuthController auth = Get.find();

    auth.getExtraInfo(auth.user.value!.uid);

    auth.startBankDetailsStream(auth.user.value!.uid);

    return WillPopScope(
      onWillPop: () async {
        auth.endBankDetailsStream();
        return true;
      },
      child: Scaffold(
        backgroundColor: ProjectColors.greyBackground,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Obx(() {
                if (auth.user.value != null && auth.info.value != null) {
                  return NamePlate(
                    user: auth.user.value!,
                    info: auth.info.value!,
                    bankDetails: auth.bankDetails.value,
                    onEdit: () {},
                    onLogOut: () {
                      auth.logOut();
                    },
                  );
                } else {
                  return loadingShimmer(Center(
                    child: Container(
                      color: Colors.white,
                      width: wd,
                      height: ht * 0.95,
                    ),
                  ));
                }
              }),
            ),
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  Scaffold.of(context).showBottomSheet(
                      (context) => const BuyCoinsSheet(),
                      constraints: BoxConstraints(maxHeight: Get.height * 0.8),
                      enableDrag: false);
                },
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      border: Border.all(width: 1.2, color: Colors.black)),
                  child: const Wrap(
                    spacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Icon(
                        Icons.currency_bitcoin,
                        size: 17,
                      ),
                      Text("100")
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  loadingShimmer(Widget child) {
    return Shimmer.fromColors(
        baseColor: Colors.grey.shade200,
        highlightColor: Colors.grey.shade400,
        child: child);
  }
}
