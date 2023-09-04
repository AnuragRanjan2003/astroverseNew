import 'dart:io';

import 'package:astroverse/db/plans_db.dart';
import 'package:astroverse/res/dims/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../components/astro_plan_item.dart';
import '../../../controllers/auth_controller.dart';
import '../../../models/plan.dart';
import '../../../models/user.dart';
import '../../../res/colors/project_colors.dart';
import '../../../res/decor/button_decor.dart';
import '../../../res/img/images.dart';
import '../../../res/textStyles/text_styles.dart';
import '../../../routes/routes.dart';
import '../../../utils/resource.dart';

class AstroSelectPlanPortrait extends StatelessWidget {
  final BoxConstraints cons;

  const AstroSelectPlanPortrait({super.key, required this.cons});

  @override
  Widget build(BuildContext context) {
    final wd = cons.maxWidth;
    final ht = cons.maxHeight;
    final User? user = Get.arguments;
    final AuthController auth = Get.find();
    debugPrint(user.toString());
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: wd,
            padding: GlobalDims.defaultScreenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50)),
                        child: Obx(() {
                          if (auth.image.value == null) {
                            return Image(
                              image: ProjectImages.man,
                              fit: BoxFit.fill,
                              height: ht * 0.15,
                            );
                          } else {
                            return Image.file(
                              File(auth.image.value!.path),
                              fit: BoxFit.fill,
                              height: ht * 0.2,
                            );
                          }
                        }),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: FloatingActionButton.small(
                          backgroundColor: ProjectColors.main,
                          onPressed: () async {
                            final file = await ImagePicker()
                                .pickImage(source: ImageSource.gallery);
                            auth.image.value = file;
                          },
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(60))),
                          child: const Icon(
                            Icons.add,
                            color: ProjectColors.background,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Choose a plan",
                  style: TextStylesLight().bodyBold,
                ),
                SizedBox(
                  height: ht * 0.01,
                ),
                Obx(() => Column(
                      children: List.generate(
                          Plans.astroPlans.length,
                          (index) => GestureDetector(
                                child: astroPlanItem(Plans.astroPlans[index],
                                    auth.astroPlanSelected.value == index),
                                onTap: () {
                                  auth.astroPlanSelected.value = index;
                                },
                              )),
                    )),
                SizedBox(
                  height: 0.02 * ht,
                ),
                MaterialButton(
                  onPressed: () {
                    if (user == null) return;
                    if (auth.loading.isTrue) return;
                    user.plan = auth.selectedPlan.value;
                    debugPrint(user.toString());
                    if (user.uid.isEmpty) {
                      auth.createUserWithEmail(user, auth.pass.value, (p0) {
                        updateUI(p0);
                      });
                    } else {
                      auth.saveGoogleData(user, (value) {
                        if (value is Success<void>) {
                          debugPrint("user done");
                        }
                      },true ,(){});
                    }
                  },
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  color: ProjectColors.main,
                  shape: ButtonDecors.filled,
                  child: Obx(() {
                    if (auth.loading.isFalse) {
                      return Text(
                        "Create Account",
                        style: TextStyleDark().onButton,
                      );
                    } else {
                      return const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: ProjectColors.background,
                          strokeWidth: 2.0,
                        ),
                      );
                    }
                  }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget astroPlanItem(Plan plan, bool sel) => AstroPlanItem(
        plan: plan,
        sel: sel,
      );
}

void updateUI(Resource p) {
  if (p is Success) {
    Get.toNamed(Routes.emailVerify);
  } else {
    Get.snackbar("Error", (p as Failure<void>).error);
  }
}
