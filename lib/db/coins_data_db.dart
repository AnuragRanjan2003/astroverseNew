import 'package:astroverse/res/img/images.dart';
import 'package:flutter/material.dart';

class CoinsData {
  final coins = [
    AstroCoin('Handful of Coins', "100", ProjectImages.singleCoin , 20 , "handful of coins", "coins_small_pack"),
    AstroCoin('Stack of Coins', "300", ProjectImages.coinStack ,100 ,"handful of coins" ,"stack_of_coins"),
    AstroCoin('Bag of Coins', "600", ProjectImages.coinPouch , 300 ,"handful of coins", "bag_of_coins"),
  ];
}

class AstroCoin {
  String name;
  String price;
  int number;
  final String productId;
  String description;
  ImageProvider image;

  AstroCoin(this.name, this.price, this.image , this.number ,this.description, this.productId);
}
