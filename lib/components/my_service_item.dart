import 'package:astroverse/models/save_service.dart';
import 'package:astroverse/res/colors/project_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class MyServiceItem extends StatefulWidget {
  final SaveService ss;
  final Function() onTap;

  const MyServiceItem(this.ss, {super.key, this.onTap = _doNothing});

  static _doNothing() {}

  @override
  State<MyServiceItem> createState() => _MyServiceItemState();
}

class _MyServiceItemState extends State<MyServiceItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: Image(
                image: NetworkImage(widget.ss.imageUrl),
                fit: BoxFit.fill,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Shimmer.fromColors(
                      baseColor: Colors.grey.shade200,
                      highlightColor: Colors.grey.shade400,
                      child: Container(
                        height: 100,
                        width: 100,
                        color: Colors.white,
                      ));
                },
                height: 100,
                width: 100,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.ss.name,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  DateFormat.yMMMd().format(
                    DateTime.parse(widget.ss.date),
                  ),
                  style: const TextStyle(
                      fontSize: 12, color: ProjectColors.disabled),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container buildChip(String text, Icon icon) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(width: 1, color: Colors.grey)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(
              width: 5,
            ),
            Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ],
        ));
  }
}
