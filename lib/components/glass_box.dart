import 'dart:ui';

import 'package:flutter/material.dart';

class GlassBox extends StatelessWidget {
  final Widget child;
  final double height;
  final double width;

  const GlassBox(
      {super.key,
      required this.child,
      required this.height,
      required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: Stack(
        children: [
          BackdropFilter(filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20)),
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Colors.white.withOpacity(0.5),
              Colors.white.withOpacity(0.1)
            ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
          ),
          Center(
            child: child,
          )
        ],
      ),
    );
  }
}
