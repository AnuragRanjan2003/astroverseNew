import 'package:astroverse/res/colors/project_colors.dart';
import 'package:astroverse/res/decor/text_field_decor.dart';
import 'package:flutter/material.dart';

class UnderLinedBox extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextStyle  style;
  final bool password;
  const UnderLinedBox({super.key, required this.controller, required this.hint, required this.style, this.password = false});

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: style,
      controller: controller,
      obscureText: password,
      decoration: TextFieldDecors().underlined(hint)
    );
  }
}
