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
          if(image!=null)Image(image:image!, height: 100,),
          Text(text , style: TextStylesLight().bodyBold,)

        ],
      ),
    );
  }
}
