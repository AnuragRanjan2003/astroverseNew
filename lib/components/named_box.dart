import 'package:astroverse/components/textbox.dart';
import 'package:flutter/material.dart';

class NamedBox extends StatelessWidget {
  final String name;
  final String hint;
  final TextStyle nameStyle;
  final TextEditingController controller;
  final bool password;

  const NamedBox(
      {super.key,
      required this.name,
      required this.hint,
      required this.controller,
      required this.nameStyle,
      this.password = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: nameStyle,
        ),
        const SizedBox(
          height: 8,
        ),
        TextBox(label: hint, controller: controller , password: password,)
      ],
    );
  }
}
