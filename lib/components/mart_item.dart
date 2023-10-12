import 'package:astroverse/models/service.dart';
import 'package:astroverse/res/img/images.dart';
import 'package:astroverse/res/textStyles/text_styles.dart';
import 'package:astroverse/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MartItem extends StatelessWidget {
  final Service item;
  static const double _radius = 30;

  const MartItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Colors.white,
      elevation: 8,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(_radius))),
      child: Container(
        height: 440,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(_radius))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(_radius)),
              child: item.imageUrl.isNotEmpty
                  ? Image.network(
                      item.imageUrl,
                      height: 220,
                      fit: BoxFit.fitWidth,
                    )
                  : const Image(
                      image: ProjectImages.planet,
                      fit: BoxFit.fill,
                      height: 220,
                    ),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text("@name"), Text("today")],
                  ),
                  const Chip(
                    label: Text(
                      "palm reading",
                      style: TextStyle(fontSize: 10),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                  ),
                  const Text(
                    "dtata\nadsda\ndasdaas",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    "₹50",
                    style: TextStylesLight().bodyBold,
                  ),
                  MaterialButton(
                    onPressed: () => Get.toNamed(Routes.martItemFullScreen , arguments: item),
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    color: const Color(0xff444040),
                    child: const Text(
                      "Buy",
                      style: TextStyle(fontSize: 13, color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
