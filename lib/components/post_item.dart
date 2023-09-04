import 'package:astroverse/res/colors/project_colors.dart';
import 'package:astroverse/res/textStyles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/post.dart';

class PostItem extends StatelessWidget {
  final Post post;

  const PostItem({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 18, right: 18, top: 15, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        post.title,
                        style: TextStylesLight().coloredBodyBold(Colors.black),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(width: 8,),
                      Text("@${post.authorName}" , style: TextStylesLight().coloredSmall(ProjectColors.onBackground),)
                    ],
                  ),
                  Text(
                    toTimeDelay(post.date),
                    style: TextStylesLight().coloredSmall(ProjectColors.onBackground),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          AspectRatio(
              aspectRatio: 4 / 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                child: Image(
                  image: NetworkImage(post.imageUrl),
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )),
          const SizedBox(
            height: 8,
          ),
          Text(
            post.description,
            style: TextStylesLight().small,
            textAlign: TextAlign.start,
            overflow: TextOverflow.visible,
            maxLines: 6,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  onPressed: () {},
                  icon: const FaIcon(
                    FontAwesomeIcons.comments,
                    size: 20,
                    color: ProjectColors.onBackground,
                  )),
              IconButton(
                  onPressed: () {},
                  icon: const FaIcon(
                    FontAwesomeIcons.heart,
                    size: 20,
                    color: ProjectColors.onBackground,
                  )),
              IconButton(
                  onPressed: () {},
                  icon: const FaIcon(
                    FontAwesomeIcons.thumbsDown,
                    size: 20,
                    color: ProjectColors.onBackground,
                  )),
            ],
          )
        ],
      ),
    );
  }

  String toTimeDelay(DateTime date){
    final now = DateTime.now();
    final delay = now.difference(date);
    final days = delay.inDays;
    String str ="";
    if(days==0) {
      str = "today";
    } else if(days==1) {
      str = "yesterday";
    } else {
      str=  "$days days ago";
    }
    return str;
  }
}
