import 'package:astroverse/controllers/auth_controller.dart';
import 'package:astroverse/controllers/in_app_purchase_controller.dart';
import 'package:astroverse/db/coins_data_db.dart';
import 'package:astroverse/res/img/images.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase_platform_interface/src/types/product_details.dart';

class BuyCoinsSheet extends StatefulWidget {
  const BuyCoinsSheet({super.key});

  @override
  State<BuyCoinsSheet> createState() => _BuyCoinsSheetState();
}

class _BuyCoinsSheetState extends State<BuyCoinsSheet> {
  final AuthController auth = Get.find();
  InAppPurchaseController iap = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (iap.isActive.isFalse) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
                image: ProjectImages.emptyBox,
                height: 100,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "The store is closed at the moment",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        );
      }
      final coinsData = iap.products
          .map((element) => AstroCoin(
              _productToTitle(element),
              element.price,
              _productToImage(element),
              _productToNumber(element),
              element.description,
              element.id))
          .toList();

      coinsData.sort(
          (a, b) => a.price.compareTo(b.price));

      return Scaffold(
        body: CarouselSlider(
          items: List.generate(
              coinsData.length, (index) => coinItem(coinsData[index])),
          options: CarouselOptions(
            height: 400,
            aspectRatio: 16 / 9,
            viewportFraction: 0.73,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: false,
            enlargeCenterPage: true,
            enlargeFactor: 0.3,
            onPageChanged: (e, _) {},
            scrollDirection: Axis.horizontal,
          ),
        ),
      );
    });
  }

  Widget coinItem(AstroCoin coin) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Image(
            image: coin.image,
          ),
        ),
        Text(
          coin.name,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text(coin.description),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Wrap(
            children: [
              const Text(
                "includes : ",
                style: TextStyle(
                    fontWeight: FontWeight.normal, fontStyle: FontStyle.italic),
              ),
              Text(
                '${coin.number} x astrocoins',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: MaterialButton(
            onPressed: () async {
              final product = iap.products
                  .firstWhere((element) => element.id == coin.productId);
              await iap.buyCoins(product);
            },
            color: Colors.lightGreen,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              coin.price,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        )
      ],
    );
  }

  static int _productToNumber(ProductDetails element) =>
      CoinsData().coins.firstWhere((e) => e.productId == element.id).number;

  static ImageProvider _productToImage(ProductDetails element) =>
      CoinsData().coins.firstWhere((e) => e.productId == element.id).image;

  static String _productToTitle(ProductDetails element) =>
      CoinsData().coins.firstWhere((e) => e.productId == element.id).name;
}
