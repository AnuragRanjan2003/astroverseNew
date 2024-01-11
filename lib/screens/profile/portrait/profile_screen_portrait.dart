import 'package:astroverse/components/buy_coins.dart';
import 'package:astroverse/components/name_plate.dart';
import 'package:astroverse/controllers/auth_controller.dart';
import 'package:astroverse/res/colors/project_colors.dart';
import 'package:astroverse/res/img/images.dart';
import 'package:astroverse/screens/ask/ask_screen.dart';
import 'package:astroverse/utils/num_parser.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class ProfileScreenPortrait extends StatelessWidget {
  final BoxConstraints cons;

  const ProfileScreenPortrait({super.key, required this.cons});

  @override
  Widget build(BuildContext context) {
    final wd = cons.maxWidth;
    final ht = cons.maxHeight;
    final AuthController auth = Get.find();

    auth.getExtraInfo(auth.user.value!.uid);

    if (auth.bankDetails.value == null) {
      auth.startBankDetailsStream(auth.user.value!.uid);
    }

    return PopScope(
      onPopInvoked: (e) async {
        auth.endBankDetailsStream();
      },
      canPop: true,
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
                    onQualificationUpdate: (e) {
                      if (auth.user.value == null) return;
                      auth.updateUser(
                          {"qualifications": e.body}, auth.user.value!.uid,
                          (e) {
                        if (e.isSuccess) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Qualifications Updated")));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Some Error Occurred")));
                        }
                      });
                    },
                    onLogOut: () {
                      auth.logOut(
                        () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => const AskScreen(),
                              ),
                              (route) => false);
                        },
                      );
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
                      constraints: BoxConstraints(maxHeight: Get.height * 0.8));
                },
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(
                          width: 1.2, color: ProjectColors.disabled)),
                  child: Wrap(
                    spacing: 5,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Obx(() {
                        return Text(
                          auth.user.value == null
                              ? "XX"
                              : NumberParser()
                                  .toSocialMediaString(auth.user.value!.coins),
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: ProjectColors.disabled),
                        );
                      }),
                      const CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.transparent,
                        child: Image(
                          image: ProjectImages.singleCoin,
                          fit: BoxFit.fill,
                        ),
                      ),
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
