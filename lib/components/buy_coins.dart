import 'package:astroverse/controllers/auth_controller.dart';
import 'package:astroverse/db/coins_data_db.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuyCoinsSheet extends StatefulWidget {
  const BuyCoinsSheet({super.key});

  @override
  State<BuyCoinsSheet> createState() => _BuyCoinsSheetState();
}

class _BuyCoinsSheetState extends State<BuyCoinsSheet> {
  final AuthController auth = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CarouselSlider(
        items: List.generate(CoinsData().coins.length,
            (index) => coinItem(CoinsData().coins[index])),
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(coin.description),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
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
            onPressed: () {
              auth.giveCoinsToUser(coin.number, auth.user.value!.uid, (p0) {
                if (p0.isSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("coins purchases")));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("failed to buy coins")));
                }
              });
            },
            color: Colors.lightGreen,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              '₹ ${coin.price}',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}
