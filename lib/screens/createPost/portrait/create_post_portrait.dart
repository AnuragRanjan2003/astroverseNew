import 'dart:developer';
import 'dart:io';

import 'package:astroverse/controllers/auth_controller.dart';
import 'package:astroverse/controllers/create_post_controller.dart';
import 'package:astroverse/controllers/location_controller.dart';
import 'package:astroverse/res/colors/project_colors.dart';
import 'package:astroverse/res/img/images.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/post.dart';

class CreatePostPortrait extends StatelessWidget {
  final BoxConstraints cons;
  static const _list = {
    'event prediction': 0,
    'entertainment': 1,
    'promotion': 2,
  };

  const CreatePostPortrait({
    super.key,
    required this.cons,
  });

  @override
  Widget build(BuildContext context) {
    final AuthController auth = Get.find();
    final CreatePostController controller = Get.put(CreatePostController());

    final LocationController loc = Get.find();
    final body = TextEditingController();
    final title = TextEditingController();
    final ScrollController scrollController = ScrollController();

    body.addListener(() {
      controller.formValid.value =
          body.value.text.isNotEmpty && title.value.text.isNotEmpty;
    });

    title.addListener(() {
      controller.formValid.value =
          body.value.text.isNotEmpty && title.value.text.isNotEmpty;
    });

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
          height: cons.maxHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Post\nSomething',
                style: TextStyle(
                    fontSize: 30,
                    color: ProjectColors.lightBlack,
                    fontWeight: FontWeight.w900),
              ),
              const SizedBox(
                height: 8,
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() {
                        var image = const Image(
                          image: ProjectImages.planet,
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                        );
                        if (controller.image.value != null) {
                          image = Image.file(
                            File(controller.image.value!.path),
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
                          );
                        }
                        return GestureDetector(
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            child: image,
                          ),
                          onTap: () async {
                            await controller.pickImage();
                          },
                        );
                      }),
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        "Let's set a title",
                        style: TextStyle(
                            color: ProjectColors.lightBlack,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: title,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                        decoration: const InputDecoration(
                            labelText: 'title', border: OutlineInputBorder()),
                        maxLines: 1,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "What kind of post is it?",
                        style: TextStyle(
                            color: ProjectColors.lightBlack,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      DropdownMenu(
                          width: 190,
                          initialSelection: _list.keys.first,
                          inputDecorationTheme: const InputDecorationTheme(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)))),
                          dropdownMenuEntries: List.generate(
                              _list.length,
                              (i) => DropdownMenuEntry(
                                  value: _list.keys.toList()[i],
                                  label: _list.keys.toList()[i])),
                          onSelected: (e) {
                            if (e == null) {
                              controller.selectedItem.value = 0;
                            } else {
                              controller.selectedItem.value = _list[e]!;
                            }
                            log(controller.selectedItem.value.toString(),
                                name: 'DROPDOWN');
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Write something ...",
                        style: TextStyle(
                            color: ProjectColors.lightBlack,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: body,
                        style: const TextStyle(fontWeight: FontWeight.w400),
                        decoration: const InputDecoration(
                            labelText: 'body', border: OutlineInputBorder()),
                        maxLines: 4,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => MaterialButton(
                        disabledColor: Colors.grey.shade500,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 60, vertical: 12),
                        onPressed: controller.formValid.isTrue &&
                                controller.loading.isFalse
                            ? () {
                                var location = loc.location.value!;
                                var user = auth.user.value!;
                                log(
                                    ' post is valid : ${validate(
                                      title,
                                      body,
                                    )}',
                                    name: "SERVICE");
                                if (!validate(title, body)) return;
                                final post = Post(
                                    authorId: user.uid,
                                    authorName: user.name,
                                    date: DateTime.now(),
                                    description: body.value.text,
                                    imageUrl: "",
                                    lat: location.latitude!,
                                    lng: location.longitude!,
                                    title: title.value.text,
                                    comments: 0,
                                    upVotes: 0,
                                    views: 0,
                                    id: "",
                                    genre: [
                                      _list.keys.toList()[
                                          controller.selectedItem.value]
                                    ]);
                                controller.savePost(post, (p0) {
                                  _updateUI(p0, body, title);
                                }, user.uid);
                              }
                            : null,
                        color: ProjectColors.lightBlack,
                        child: controller.loading.isFalse
                            ? const Text(
                                'Post',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white),
                              )
                            : const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

_updateUI(Resource<Post> p0, TextEditingController body,
    TextEditingController title) {
  if (p0.isSuccess) {
    body.clear();
    title.clear();
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
}

bool validate(
  TextEditingController title,
  TextEditingController body,
) {
  final t = title.value.text;
  final b = body.value.text;
  if (t.isEmpty || b.isEmpty) return false;
  return true;
}
