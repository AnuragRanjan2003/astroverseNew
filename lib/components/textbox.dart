import 'package:astroverse/res/decor/text_field_decor.dart';
import 'package:flutter/material.dart';

import '../res/colors/project_colors.dart';
import '../res/textStyles/text_styles.dart';

class TextBox extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool password;

  const TextBox(
      {super.key,
      required this.label,
      required this.controller,
      this.password = false});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: password,
      decoration: TextFieldDecors().filled(label),
      style: TextStylesLight().body,
      maxLines: 1,
      cursorColor: ProjectColors.primary,
    );
  }
}
