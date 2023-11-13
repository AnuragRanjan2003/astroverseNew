import 'package:astroverse/res/colors/project_colors.dart';
import 'package:flutter/material.dart';

class LoadMoreButton extends StatelessWidget {
  const LoadMoreButton({
    super.key,
    required this.cons,
    required this.loadMore,
  });

  final BoxConstraints cons;
  final void Function() loadMore;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      EdgeInsets.symmetric(horizontal: cons.maxWidth * 0.2),
      child: MaterialButton(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          onPressed: () {
            loadMore();
          },
          child: const Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              children: [
                Text(
                  "load more",
                  style: TextStyle(color: ProjectColors.disabled),
                ),
                Icon(
                  Icons.refresh,
                  color: Colors.lightBlue,
                  size: 18,
                )
              ])),
    );
  }
}