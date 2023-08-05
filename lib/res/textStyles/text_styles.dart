import 'package:astroverse/res/colors/project_colors.dart';
import 'package:flutter/material.dart';

abstract class ProjectTextStyles {
  TextStyle get body;
  TextStyle get bodyBold;

  TextStyle get header;

  TextStyle get onButton;

  TextStyle get small;
  TextStyle get smallBold;

  TextStyle get subtitle;
}

class TextStylesLight implements ProjectTextStyles {
  @override
  TextStyle get body =>
      const TextStyle(color: ProjectColors.primary, fontSize: 16);

  @override
  TextStyle get header => const TextStyle(
      color: ProjectColors.primary, fontSize: 35, fontWeight: FontWeight.w700);

  @override
  TextStyle get onButton => const TextStyle(
      color: ProjectColors.primary, fontSize: 18, fontWeight: FontWeight.w600);

  @override
  TextStyle get small => const TextStyle(
      color: ProjectColors.primary, fontSize: 14, fontWeight: FontWeight.w400);

  @override
  TextStyle get subtitle =>
      const TextStyle(color: ProjectColors.primary, fontSize: 16 );

  @override
  TextStyle get bodyBold => const TextStyle(color: ProjectColors.primary, fontSize: 16 , fontWeight: FontWeight.w600);

  @override
  TextStyle get smallBold => const TextStyle(
      color: ProjectColors.primary, fontSize: 14, fontWeight: FontWeight.w600);
}

class TextStyleDark implements ProjectTextStyles {
  @override
  TextStyle get body =>
      const TextStyle(color: ProjectColors.background, fontSize: 16);

  @override
  TextStyle get header => const TextStyle(
      color: ProjectColors.background,
      fontSize: 26,
      fontWeight: FontWeight.w700);

  @override
  TextStyle get onButton => const TextStyle(
      color: ProjectColors.background,
      fontSize: 16,
      fontWeight: FontWeight.w600);

  @override
  TextStyle get small => const TextStyle(
      color: ProjectColors.background,
      fontSize: 14,
      fontWeight: FontWeight.w400);

  @override
  TextStyle get subtitle =>
      const TextStyle(color: ProjectColors.background, fontSize: 14);

  @override
  TextStyle get bodyBold => const TextStyle(color: ProjectColors.background, fontSize: 16 , fontWeight: FontWeight.w600);

  @override
  TextStyle get smallBold =>const TextStyle(
      color: ProjectColors.background,
      fontSize: 14,
      fontWeight: FontWeight.w600);
}
