import 'dart:developer';
import 'dart:io';

import 'package:astroverse/controllers/auth_controller.dart';
import 'package:astroverse/controllers/create_post_controller.dart';
import 'package:astroverse/res/img/images.dart';
import 'package:astroverse/res/textStyles/text_styles.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/main_controller.dart';
import '../../../models/post.dart';
import '../../../res/decor/button_decor.dart';
import '../../../res/dims/global.dart';

class CreatePostPortrait extends StatelessWidget {
  final BoxConstraints cons;

  const CreatePostPortrait({
    super.key,
    required this.cons,
  });

  @override
  Widget build(BuildContext context) {
    final MainController main = Get.find();
    final AuthController auth = Get.find();
    final CreatePostController controller = Get.put(CreatePostController());
    final List<TextEditingController> textControllers =
        List.generate(2, (index) => TextEditingController());
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: GlobalDims.horizontalPadding),
                child: Text('Create\na Post' ,style: TextStyle(fontSize: 28 , fontWeight: FontWeight.bold),),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: GlobalDims.horizontalPadding),
                child: TextField(
                    controller: textControllers[0],
                    decoration: InputDecoration(
                        labelText: "title",
                        labelStyle: TextStylesLight().lightBody,
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))))),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: GlobalDims.horizontalPadding),
                child: Obx(() {
                  final image = controller.image.value;
                  if (image == null) {
                    return const Image(
                      image: ProjectImages.bank,
                      height: 250,
                      width: 250,
                    );
                  } else {
                    return Image.file(
                      File(image.path),
                      height: 250,
                      width: 250,
                    );
                  }
                }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: GlobalDims.horizontalPadding),
                child: IconButton(
                    onPressed: () {
                      controller.pickImage();
                    },
                    icon: const Icon(Icons.image_outlined)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: GlobalDims.horizontalPadding),
                child: Text(
                  "Body",
                  style: TextStylesLight().body,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: GlobalDims.horizontalPadding),
                child: TextField(
                    controller: textControllers[1],
                    maxLines: 7,
                    maxLength: 100,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))))),
              ),
              const SizedBox(
                height: 15,
              ),
              Obx(() => MaterialButton(
                  onPressed: () {
                    final post = Post(
                        title: textControllers[0].value.text,
                        description: textControllers[1].value.text,
                        genre: ["a"],
                        imageUrl: "",
                        date: DateTime.now(),
                        authorId: auth.user.value!.uid,
                        lat: 0,
                        lng: 0,
                        authorName: auth.user.value!.name);
                    controller.savePost(post, (p0) {
                      if (p0.isSuccess) {
                        log("posted", name: "POST");
                        Get.snackbar(
                          '',
                          '',
                          titleText: const Text(
                            'posted successfully',
                            style: TextStyle(color: Colors.lightBlue),
                          ),
                          messageText: const Text(
                            'posted successfully',
                            style: TextStyle(color: Colors.lightBlue),
                          ),
                          snackPosition: SnackPosition.BOTTOM,
                          duration: const Duration(seconds: 3),
                          backgroundColor: Colors.white,
                          colorText: Colors.white,
                        );
                      } else {
                        log((p0 as Failure<Post>).error, name: "POST");
                      }
                    });
                  },
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  color: Colors.lightBlue,
                  shape: ButtonDecors.filled,
                  child: controller.loading.isFalse
                      ? Text(
                          "Post",
                          style: TextStyleDark().onButton,
                        )
                      : const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ))),
            ],
          ),
        ),
      )),
    );
  }
}
