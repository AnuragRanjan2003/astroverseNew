import 'package:astroverse/res/colors/project_colors.dart';
import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({
    super.key,
    required this.controller,
    required this.hint,
    required this.width,
    this.bottom, this.bottomSpacing,
  });

  final TextEditingController controller;
  final String hint;
  final double width;
  final Widget? bottom;
  final double? bottomSpacing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      width: width,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 0.5, color: ProjectColors.disabled),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: IntrinsicHeight(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.blue,
                  ),
                  border: InputBorder.none,
                  hintText: hint,
                  hintStyle: const TextStyle(
                      fontSize: 14, color: ProjectColors.disabled)),
              style: const TextStyle(fontSize: 14),
            ),
            if(bottom!=null) SizedBox(height: bottomSpacing==null?5:bottomSpacing!,),
            if (bottom != null) bottom!,
          ],
        ),
      ),
    );
  }
}
