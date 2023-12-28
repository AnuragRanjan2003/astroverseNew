import 'package:astroverse/models/service.dart';
import 'package:astroverse/res/colors/project_colors.dart';
import 'package:astroverse/res/img/images.dart';
import 'package:astroverse/res/textStyles/text_styles.dart';
import 'package:astroverse/screens/mart_item_full/mart_item_full_screen.dart';
import 'package:astroverse/utils/crypt.dart';
import 'package:flutter/material.dart';

class MartItem extends StatelessWidget {
  final Service item;
  static const double _radius = 20;

  const MartItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final crypto = Crypt();
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
                  ? Hero(
                      tag: "service ${item.id}",
                      child: Image.network(
                        item.imageUrl,
                        fit: BoxFit.fill,
                        height: 140,
                      ),
                    )
                  : Hero(
                      tag: "service ${item.id}",
                      child: const Image(
                        image: ProjectImages.planet,
                        height: 140,
                        fit: BoxFit.fill,
                      ),
                    ),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    '@${crypto.decryptFromBase64String(item.authorName)}',
                    style: const TextStyle(fontSize: 11),
                  ),
                  Text(
                    item.title,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xff444040),
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        border: Border.all(width: 1)),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 3,
                      children: [
                        Icon(
                          methodToIcon(item.deliveryMethod),
                          size: 10,
                        ),
                        Text(
                          methodToString(item.deliveryMethod),
                          style: const TextStyle(
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  item.featured
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                              border: Border.all(width: 1)),
                          child: const Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 3,
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.orangeAccent,
                                size: 10,
                              ),
                              Text(
                                'featured',
                                style: TextStyle(
                                    fontSize: 10, color: Colors.orangeAccent),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                  Text(
                    item.genre[0],
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    '₹${item.price.toInt()}',
                    style: TextStylesLight().bodyBold,
                  ),
                  MaterialButton(
                    // TODO("nav")
                    onPressed: () =>
                        //Get.toNamed(Routes.martItemFullScreen, arguments: item),
                        Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MartItemFullScreen(item: item),
                    )),
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

  String methodToString(int e) {
    if (e == 0) return "in-person";
    if (e == 1) {
      return "chat";
    } else {
      return "call";
    }
  }

  IconData methodToIcon(int m) {
    if (m == 0) return Icons.people_outline;
    if (m == 1) return Icons.messenger_outline_outlined;
    return Icons.call_outlined;
  }
}
