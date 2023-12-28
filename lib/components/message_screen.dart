import 'package:astroverse/res/img/images.dart';
import 'package:astroverse/res/textStyles/text_styles.dart';
import 'package:flutter/material.dart';

class MessageScreen extends StatelessWidget {
  final ImageProvider? image;
  final String text;
  const MessageScreen({super.key, this.image, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        direction: Axis.vertical,
        spacing: 30,
        children: [
          Image(image:image??ProjectImages.emptyBox, height: 100,),
          Text(text , style: TextStylesLight().bodyBold,)

        ],
      ),
    );
  }
}
