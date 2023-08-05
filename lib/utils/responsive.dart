import 'package:flutter/cupertino.dart';

class Responsive extends StatelessWidget {
  final Widget Function(BoxConstraints) portrait;
  final Widget Function(BoxConstraints) landscape;

  const Responsive(
      {super.key, required this.portrait, required this.landscape});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 500) {
          return portrait(constraints);
        } else {
          return landscape(constraints);
        }
      },
    );
  }
}
