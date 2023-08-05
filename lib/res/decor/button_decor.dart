import 'package:astroverse/res/colors/project_colors.dart';
import 'package:flutter/material.dart';

class ButtonDecors {
  static const _radius = BorderRadius.all(Radius.circular(15));
  static const outlined = RoundedRectangleBorder(
      side: BorderSide(color: ProjectColors.main ,width: 2.0), borderRadius: _radius);

  static const filled = RoundedRectangleBorder(borderRadius: _radius);
}
