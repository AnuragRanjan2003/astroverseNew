import 'package:astroverse/res/colors/project_colors.dart';
import 'package:flutter/material.dart';

class LockedCallButton extends StatelessWidget {
  const LockedCallButton({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialButton(
      onPressed: null,
      disabledColor: ProjectColors.disabled,
      padding: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30))),
      child: Wrap(
        spacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Icon(
            Icons.call,
            size: 22,
            color: Colors.white,
          ),
          Text(
            "Call",
            style: TextStyle(color: Colors.white, fontSize: 16),
          )
        ],
      ),
    );
  }
}
