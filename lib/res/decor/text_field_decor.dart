import 'package:astroverse/res/colors/project_colors.dart';
import 'package:astroverse/res/textStyles/text_styles.dart';
import 'package:flutter/material.dart';

class TextFieldDecors {
  static const _borderWidth=  1.2;
  InputDecoration filled(String hint) => InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        hintText: hint,
        hintStyle: const TextStyle(color: ProjectColors.onBackground),
        enabledBorder: _defaultEnabledBorder,
        focusedBorder: _defaultFocusedBorder,
      );

  InputDecoration underlined(String hint , Widget? prefix) => InputDecoration(
    prefixIcon: prefix,
    prefixIconColor: ProjectColors.onBackground,
    contentPadding:
    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    hintText: hint,
    hintStyle: const TextStyle(color: ProjectColors.disabled),
    enabledBorder: _defaultUnderlinedEnabledBorder,
    focusedBorder: _defaultUnderlinedFocusedBorder,
  );

  static const _defaultFocusedBorder = OutlineInputBorder(
      borderSide: BorderSide(color: ProjectColors.main, width: _borderWidth),
      borderRadius: BorderRadius.all(Radius.circular(30)));

  static const _defaultEnabledBorder = OutlineInputBorder(
      borderSide: BorderSide(color: ProjectColors.onBackground, width: _borderWidth),
      borderRadius: BorderRadius.all(Radius.circular(30)));

  static const _defaultUnderlinedFocusedBorder = OutlineInputBorder(
      borderSide: BorderSide(color: ProjectColors.onBackground, width: _borderWidth),);

  static const _defaultUnderlinedEnabledBorder = OutlineInputBorder(
      borderSide: BorderSide(color: ProjectColors.onBackground, width: _borderWidth),);
}
