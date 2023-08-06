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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../db/plans.dart';
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
    final models.User user = args;
    final String password = auth.pass.value;
    return Scaffold(
      backgroundColor: ProjectColors.background,
      body: SingleChildScrollView(
        child: Container(
          width: wd,
          height: ht,
          padding: const EdgeInsets.only(
              right: GlobalDims.horizontalPadding,
              left: GlobalDims.horizontalPadding,
              top: GlobalDims.verticalPaddingExtra),
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
                      borderRadius: const BorderRadius.all(Radius.circular(50)),
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
                child: Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(
                      Plans.plans.length,
                      (index) => PlanItem(
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
                  if (auth.loading.isTrue) return;
                  user.plan = auth.selectedPlan.value;
                  auth.createUserWithEmail(user, password, (p0) {
                    updateUI(p0);
                  });
                },
                padding: const EdgeInsets.symmetric(vertical: 10),
                color: ProjectColors.main,
                shape: ButtonDecors.filled,
                child: Obx(() {
                  if (auth.loading.isFalse) {
                    return Text(
                      "Create Account",
                      style: TextStylesLight().onButton,
                    );
                  } else {
                    return const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: ProjectColors.background,
                      ),
                    );
                  }
                }),
              )
            ],
          ),
        ),
      ),
    );
  }

  updateUI(Resource p) {
    if (p.isSuccess) {
      Get.toNamed(Routes.main);
    } else {
      Get.snackbar("Error", (p as Failure<void>).error);
    }
  }
}
