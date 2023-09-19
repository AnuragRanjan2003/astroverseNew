import 'dart:developer';

import 'package:astroverse/controllers/auth_controller.dart';
import 'package:astroverse/res/img/images.dart';
import 'package:astroverse/res/textStyles/text_styles.dart';
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
    final List<TextEditingController> textControllers =
        List.generate(2, (index) => TextEditingController());
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          padding: GlobalDims.defaultScreenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                  controller: textControllers[0],
                  decoration: InputDecoration(
                      labelText: "title",
                      labelStyle: TextStylesLight().lightBody,
                      border: const OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20))))),
              const Image(image: ProjectImages.bank),
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.image_outlined)),
              Text(
                "Body",
                style: TextStylesLight().body,
              ),
              TextField(
                  controller: textControllers[1],
                  maxLines: 7,
                  maxLength: 100,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10))))),
              MaterialButton(
                  onPressed: () {
                    final post = Post(
                        title: textControllers[0].value.text,
                        description: textControllers[1].value.text,
                        genre: ["a"],
                        imageUrl: "",
                        date: DateTime.now(),
                        authorId: auth.user.value!.uid,
                        authorName: auth.user.value!.name);
                    main.savePost(post, (p0) {
                      if (p0.isSuccess) log("posted", name: "POST");
                    });
                  },
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  color: Colors.lightBlue,
                  shape: ButtonDecors.filled,
                  child: Text(
                    "Post",
                    style: TextStyleDark().onButton,
                  )),
            ],
          ),
        ),
      )),
    );
  }
}
