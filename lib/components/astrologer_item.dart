import 'package:astroverse/models/user.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AstrologerItem extends StatelessWidget {
  final User user;

  const AstrologerItem({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      decoration: const BoxDecoration(
          color: Color(0x2ae1e0e0),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Row(
        children: [
          ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              child: Image(
                image: NetworkImage(user.image),
                height: 90,
                width: 90,
                fit: BoxFit.cover,
              )),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    user.plan == 4 ? _featuredChip() : const SizedBox.shrink(),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _dataWidget(FontAwesomeIcons.eye, '250'),
                    _dataWidget(FontAwesomeIcons.airbnb, '180'),
                  ],
                )
              ],
            ),
          ))
        ],
      ),
    );
  }

  Widget _dataWidget(IconData icon, String text) {
    return Wrap(
      spacing: 5,
      children: [
        Icon(
          icon,
          size: 15,
        ),
        Text(text)
      ],
    );
  }

  Widget _featuredChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: const BorderRadius.all(Radius.circular(30))),
      child: const Text(
        'featured',
        style: TextStyle(fontSize: 12),
      ),
    );
  }
}
