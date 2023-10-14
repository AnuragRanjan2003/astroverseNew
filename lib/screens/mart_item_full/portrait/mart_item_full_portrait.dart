import 'package:astroverse/models/service.dart';
import 'package:astroverse/res/colors/project_colors.dart';
import 'package:astroverse/res/img/images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MartItemFullPortrait extends StatelessWidget {
  final BoxConstraints cons;

  const MartItemFullPortrait({super.key, required this.cons});

  @override
  Widget build(BuildContext context) {
    final Service? item = Get.arguments;
    final sb = StringBuffer();
    sb.writeAll(item!.genre, ", ");

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          item.imageUrl.isNotEmpty
              ? Image(
                  image: NetworkImage(item.imageUrl),
                  height: cons.maxHeight * 0.45,
                  fit: BoxFit.fill,
                  width: cons.maxWidth,
                )
              : Image(
                  image: ProjectImages.planet,
                  height: cons.maxHeight * 0.45,
                  fit: BoxFit.fill,
                  width: cons.maxWidth,
                ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Row(
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 24),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                    child: Text(
                      sb.toString(),
                      style: const TextStyle(
                          color: ProjectColors.lightBlack,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    child: Text(
                      item.description,
                      style: const TextStyle(
                        color: ProjectColors.lightBlack,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: item.place.isNotEmpty,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      child: Text(
                        'Address',
                        style: TextStyle(
                            fontSize: 16,
                            color: ProjectColors.lightBlack,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: item.place.isNotEmpty,
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                      child: Text(
                        item.place,
                        style: const TextStyle(
                          color: ProjectColors.lightBlack,
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    child: Text(
                      'Details',
                      style: TextStyle(
                          fontSize: 16,
                          color: ProjectColors.lightBlack,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  buildRow('provider', item.authorName, Icons.person_2),
                  buildRow(
                      'date',
                      DateFormat.yMMMd().format(item.date).toString(),
                      Icons.date_range),
                  buildRow(
                      'uses', item.uses.toString(), Icons.data_thresholding),
                  buildRow('likes', item.upVotes.toString(), Icons.favorite),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: MaterialButton(
              onPressed: () {},
              color: const Color(0xff444040),
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              child: Text("Buy ₹${item.price.toInt()}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13, color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }

  Widget buildRow(String label, String value, IconData icon) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Wrap(
              children: [
                Icon(
                  icon,
                  color: ProjectColors.lightBlack,
                  size: 20,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  label,
                  style: const TextStyle(
                      color: ProjectColors.lightBlack,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Text(
              value,
              style: const TextStyle(color: ProjectColors.lightBlack),
            ),
          ],
        ),
      );
}
