import 'dart:ui';

import 'package:flutter/material.dart';

class GlassMorphContainer extends StatelessWidget {
  final double borderRadius;
  final double blur;
  final double opacity;
  final Widget child;
  final EdgeInsets margin;
  final bool onlyBottomRadius;

  const GlassMorphContainer({
    super.key,
    required this.borderRadius,
    required this.blur,
    required this.opacity,
    required this.child,
    required this.margin,
    this.onlyBottomRadius = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(opacity * 0.7),
          borderRadius: onlyBottomRadius
              ? BorderRadius.only(
                  bottomLeft: Radius.circular(borderRadius),
                  bottomRight: Radius.circular(borderRadius))
              : BorderRadius.all(Radius.circular(borderRadius)),
          border:
              Border.all(color: Colors.white.withOpacity(opacity), width: 1.5)),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaY: blur, sigmaX: blur),
          child: child,
        ),
      ),
    );
  }
}
