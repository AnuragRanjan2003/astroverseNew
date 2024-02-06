import 'dart:developer';
import 'dart:io';

import 'package:astroverse/controllers/auth_controller.dart';
import 'package:astroverse/controllers/create_post_controller.dart';
import 'package:astroverse/controllers/location_controller.dart';
import 'package:astroverse/db/plans_db.dart';
import 'package:astroverse/res/colors/project_colors.dart';
import 'package:astroverse/res/img/images.dart';
import 'package:astroverse/utils/geo.dart';
import 'package:astroverse/utils/resource.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/plan.dart';
import '../../../models/post.dart';

const _limit = 5;

class CreatePostPortrait extends StatelessWidget {
  final BoxConstraints cons;
  static const _list = {
    'advanced horoscope': 0,
    'event prediction': 1,
    'self promotion': 2,
    'planetary change': 3,
    'vastu': 4,
    'lal kitab': 5,
    'Tantra/Mantra': 6,
    'remedy': 7,
    'Astro  upaay': 8,
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
    late Plan plan;
    if (auth.user.value!.astro) {
      plan = Plans.astroPlans[auth.user.value!.plan];
    } else {
      if (auth.user.value!.plan == 0) {
        plan = Plans.plans[0];
      } else {
        plan = Plans.plans[auth.user.value!.plan - 1 - VisibilityPlans.all];
      }
    }

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
                      SizedBox(
                        height: 170,
                        width: 170,
                        child: Stack(
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
                              return ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
                                child: image,
                              );
                            }),
                            Align(
                                alignment: Alignment.bottomRight,
                                child: IconButton(
                                    onPressed: () async {
                                      await controller.pickImage();
                                    },
                                    style: const ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                ProjectColors.primary)),
                                    icon: const Icon(
                                      Icons.link,
                                      color: Colors.white,
                                    )))
                          ],
                        ),
                      ),
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

                                if (areDatesSame(user.lastPosted)) {
                                  if (user.postedToday >= plan.postPerDay) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Post limit reached for today")));
                                    return;
                                  }
                                }

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
                                    astrologer: user.astro,
                                    featured: user.featured,
                                    upVotes: 0,
                                    views: 0,
                                    id: "",
                                    genre: [
                                      _list.keys.toList()[
                                          controller.selectedItem.value]
                                    ]);
                                controller.savePost(post, (p0) {
                                  _updateUI(p0, body, title, context);
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
    TextEditingController title, BuildContext context) {
  if (p0.isSuccess) {
    body.clear();
    title.clear();
    log("posted", name: "POST");
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Posted Successfully")));
  } else {
    log((p0 as Failure<Post>).error, name: "POST");
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Post Failed")));
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
