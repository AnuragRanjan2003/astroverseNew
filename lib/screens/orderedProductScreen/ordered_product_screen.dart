import 'package:astroverse/controllers/order_controller.dart';
import 'package:astroverse/screens/orderedProductScreen/landscape/ordered_product_landscape.dart';
import 'package:astroverse/screens/orderedProductScreen/portrait/ordered_product_portrait.dart';
import 'package:astroverse/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderedProductScreen extends StatelessWidget {
  const OrderedProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final order = Get.put(OrderController());
    return Responsive(
      portrait: (p0) => OrderedProductPortrait(cons: p0),
      landscape: (p0) => OrderedProductLandscape(cons: p0),
    );
  }
}
