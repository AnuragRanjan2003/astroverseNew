import 'package:astroverse/models/purchase.dart';
import 'package:astroverse/res/colors/project_colors.dart';
import 'package:flutter/material.dart';

class PurchaseItem extends StatelessWidget {
  final Purchase purchase;

  const PurchaseItem({super.key, required this.purchase});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.white
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10 , vertical: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                child: Image(
                  image: NetworkImage(purchase.itemImage),
                  height: 90,
                  fit: BoxFit.fill,
                  width: 100,
                )),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    purchase.itemName,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '₹${purchase.itemPrice}',
                    style: const TextStyle(
                        color: ProjectColors.lightBlack, fontSize: 12 ,fontWeight: FontWeight.w500),
                  ),
                  _buildChip(
                      toTimeDelay(purchase.boughtOn),
                      const Icon(
                        Icons.history,
                        size: 15,
                      ),
                      const Color(0xffd9d9d9),
                      ProjectColors.lightBlack),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildChip(
                    "unreceived",
                    null,
                    Colors.red.shade200,
                    Colors.red),
                MaterialButton(
                  onPressed: () {},
                  color: ProjectColors.lightBlack,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: const Text(
                    "View",
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container _buildChip(String text, Icon? icon, Color color, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Wrap(
        direction: Axis.horizontal,
        spacing: 2,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          if(icon!=null)icon,
          Text(
            text,
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w600, color: textColor),
          ),
        ],
      ),
    );
  }

  String toTimeDelay(DateTime date) {
    final now = DateTime.now();
    final delay = now.difference(date);
    final days = delay.inDays;
    final hrs = delay.inHours;
    String str = "";
    if (days == 0) {
      str = "${hrs}h ago";
    } else if (days == 1) {
      str = "yesterday";
    } else {
      str = "$days days ago";
    }
    return str;
  }
}
