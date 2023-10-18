import 'package:astroverse/models/service.dart';
import 'package:astroverse/res/colors/project_colors.dart';
import 'package:astroverse/res/img/images.dart';
import 'package:astroverse/res/textStyles/text_styles.dart';
import 'package:astroverse/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MartItem extends StatelessWidget {
  final Service item;
  static const double _radius = 20;

  const MartItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Colors.white,
      elevation: 8,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(_radius))),
      child: Container(
        height: 350,
        width: 130,
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
                      fit: BoxFit.fill,
                      height: 140,
                    )
                  : const Image(
                      image: ProjectImages.planet,
                      height: 140,
                      fit: BoxFit.fill,
                    ),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('@${item.authorName}',style: const TextStyle(fontSize: 11),),
                  Text(
                    item.genre[0],
                    style: const TextStyle(fontSize: 10,color: Color(0xff444040),fontWeight: FontWeight.bold),
                  ),
                  Text(
                    item.title,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 12),
                  ),
                  Text(
                    '₹${item.price.toInt()}',
                    style: TextStylesLight().bodyBold,
                  ),
                  MaterialButton(
                    onPressed: () =>
                        Get.toNamed(Routes.martItemFullScreen, arguments: item),
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    color: ProjectColors.lightBlack,
                    child: const Text(
                      "Buy",
                      style: TextStyle(fontSize: 13, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
