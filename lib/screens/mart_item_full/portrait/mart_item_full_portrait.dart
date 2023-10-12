import 'package:astroverse/models/service.dart';
import 'package:astroverse/res/img/images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MartItemFullPortrait extends StatelessWidget {
  final BoxConstraints cons;

  const MartItemFullPortrait({super.key, required this.cons});

  @override
  Widget build(BuildContext context) {
    final Service? item = Get.arguments;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            item!.imageUrl.isNotEmpty
                ? Image(image: NetworkImage(item.imageUrl))
                : const Image(
                    image: ProjectImages.planet,
                  ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Text(
                    "@${item.authorName}",
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 16),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(item.description),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: MaterialButton(
                onPressed: () {},
                color: const Color(0xff444040),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                child: Text("Buy ₹${item.price.toInt()}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 13, color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
