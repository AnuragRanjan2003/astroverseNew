import 'package:astroverse/res/colors/project_colors.dart';
import 'package:astroverse/res/decor/text_field_decor.dart';
import 'package:flutter/material.dart';

class UnderLinedBox extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextStyle  style;
  final bool password;
  final String? prefix;
  final int? maxLen;
  final TextInputType? type;
  const UnderLinedBox({super.key, required this.controller, required this.hint, required this.style, this.password = false, this.prefix, this.maxLen, this.type});

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: style,
      controller: controller,
      obscureText: password,
      keyboardType: type,
      textAlign: TextAlign.center,
      maxLength: maxLen,
      decoration: TextFieldDecors().underlined(hint,prefix)
    );
  }
}
