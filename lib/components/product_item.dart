import 'package:astroverse/res/colors/project_colors.dart';
import 'package:astroverse/res/textStyles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/models/store_product_wrapper.dart';

class ProductItem extends StatelessWidget {
  final StoreProduct product;
  final int selected;
  final bool taken;
  final int index;
  final void Function(StoreProduct) onChange;

  const ProductItem({
    super.key,
    required this.product,
    required this.selected,
    required this.onChange,
    required this.index,
    this.taken = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = getColor(selected != index);
    return InkWell(
      onTap: () {
        onChange(product);
      },
      child: Container(
          padding:
              const EdgeInsets.only(top: 20, bottom: 20, left: 25, right: 25),
          margin: const EdgeInsets.symmetric(vertical: 5),
          constraints: const BoxConstraints(minWidth: 140),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              border: Border.all(color: color)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product.title.split("(")[0],
                    style: TextStylesLight().coloredBodyBold(color),
                  ),
                  taken
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 10),
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              border:
                                  Border.all(color: ProjectColors.disabled)),
                          child: const Text(
                            "taken",
                            style: TextStyle(
                                color: ProjectColors.disabled, fontSize: 12),
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "${product.price}",
                style: TextStylesLight().coloredBody(color),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                product.description,
                style: TextStylesLight().coloredSmall(color),
                overflow: TextOverflow.visible,
              )
            ],
          )),
    );
  }

  Color getColor(bool p) {
    if (p == true) {
      return ProjectColors.onBackground;
    } else {
      return ProjectColors.main;
    }
  }
}
