import 'package:astroverse/models/user.dart';
import 'package:astroverse/res/colors/project_colors.dart';
import 'package:astroverse/res/strings/backend_strings.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeBar extends StatelessWidget {
  final User? user;
  final EdgeInsets padding;
  final Color color;
  final TextStyle style;
  const HomeBar({super.key, required this.user, required this.padding, required this.color, required this.style});

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: padding,
      color: color,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: Image(image: NetworkImage(getImage(user)), height: 40, width: 40,fit: BoxFit.fill,),
            ),
            const SizedBox(width: 10,),
            Text( getName(user), style: style,),
          ],),
          const FaIcon(FontAwesomeIcons.bell , color: ProjectColors.onBackground,)

        ],
      ),
    );
  }
  
  String getName(User? user){
    if(user != null) {
      return user.name;
    } else {
      return "";
    }
  }

  String getImage(User? user){
    if(user != null) {
      return user.image;
    } else {
      return BackEndStrings.defaultImage;
    }
  }
}
