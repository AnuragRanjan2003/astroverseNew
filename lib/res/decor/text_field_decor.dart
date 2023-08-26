import 'package:astroverse/res/colors/project_colors.dart';
import 'package:astroverse/res/textStyles/text_styles.dart';
import 'package:flutter/material.dart';

class TextFieldDecors {
  InputDecoration filled(String hint) => InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        hintText: hint,
        hintStyle: const TextStyle(color: ProjectColors.onBackground),
        enabledBorder: _defaultEnabledBorder,
        focusedBorder: _defaultFocusedBorder,
      );

  InputDecoration underlined(String hint , String? prefix) => InputDecoration(
    prefixText: prefix,
    prefixStyle: TextStylesLight().bodyBold,
    contentPadding:
    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    hintText: hint,
    hintStyle: const TextStyle(color: ProjectColors.onBackground),
    enabledBorder: _defaultUnderlinedEnabledBorder,
    focusedBorder: _defaultUnderlinedFocusedBorder,
  );

  static const _defaultFocusedBorder = OutlineInputBorder(
      borderSide: BorderSide(color: ProjectColors.main, width: 1.7),
      borderRadius: BorderRadius.all(Radius.circular(20)));

  static const _defaultEnabledBorder = OutlineInputBorder(
      borderSide: BorderSide(color: ProjectColors.onBackground, width: 1.7),
      borderRadius: BorderRadius.all(Radius.circular(20)));

  static const _defaultUnderlinedFocusedBorder = OutlineInputBorder(
      borderSide: BorderSide(color: ProjectColors.onBackground, width: 1.7),);

  static const _defaultUnderlinedEnabledBorder = OutlineInputBorder(
      borderSide: BorderSide(color: ProjectColors.onBackground, width: 1.7),);
}
