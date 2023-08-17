import 'dart:io';

import 'package:astroverse/components/plan_item.dart';
import 'package:astroverse/controllers/auth_controller.dart';
import 'package:astroverse/models/user.dart' as models;
import 'package:astroverse/res/colors/project_colors.dart';
import 'package:astroverse/res/decor/button_decor.dart';
import 'package:astroverse/res/dims/global.dart';
import 'package:astroverse/res/img/images.dart';
import 'package:astroverse/res/textStyles/text_styles.dart';
import 'package:astroverse/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../db/plans_db.dart';
import '../../../utils/resource.dart';

class MoreProfilePortrait extends StatelessWidget {
  final BoxConstraints cons;

  const MoreProfilePortrait({super.key, required this.cons});

  @override
  Widget build(BuildContext context) {
    final double wd = cons.maxWidth;
    final double ht = cons.maxHeight;
    final AuthController auth = Get.find();
    final args = Get.arguments;
    final models.User? user = args;
    final String password = auth.pass.value;
    if (user == null) Get.snackbar("Error", "unknown error occurred");
    debugPrint(user?.toString());
    return Scaffold(
      backgroundColor: ProjectColors.background,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: wd,
            padding: GlobalDims.defaultScreenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "One Last\nStep",
                  style: TextStylesLight().header,
                ),
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
                              height: ht * 0.2,
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
                  height: ht * 0.03,
                ),
                SizedBox(
                  height: ht * 0.27,
                  child: Obx(() =>
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: List.generate(
                            Plans.plans.length,
                                (index) =>
                                PlanItem(
                                    plan: Plans.plans[index],
                                    selected: auth.selectedPlan.value,
                                    onChange: (e) {
                                      auth.selectedPlan.value = e;
                                    }),
                          ))),
                ),
                SizedBox(
                  height: ht * 0.05,
                ),
                MaterialButton(
                  onPressed: () {
                    if (user == null) return;
                    if (auth.loading.isTrue) return;
                    user.plan = auth.selectedPlan.value;
                    debugPrint(user.toString());
                    if(user.uid.isEmpty) {
                      auth.createUserWithEmail(user, password, (p0) {
                      updateUI(p0);
                    });
                    }else{
                      auth.saveGoogleData(user, (value) {
                        if(value is Success<void>){
                          debugPrint("user done");
                        }
                      });
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

  updateUI(Resource p) {
    if (p is Success) {
      Get.toNamed(Routes.emailVerify);
    } else {
      Get.snackbar("Error", (p as Failure<void>).error);
    }
  }
}
