import 'package:astroverse/res/img/images.dart';
import 'package:flutter/material.dart';

class CoinsData {
  final coins = [
    AstroCoin('Handful of Coins', 100, ProjectImages.singleCoin , 20 , "handful of coins"),
    AstroCoin('Stack of Coins', 300, ProjectImages.coinStack ,100 ,"handful of coins"),
    AstroCoin('Bag of Coins', 600, ProjectImages.coinPouch , 300 ,"handful of coins"),
  ];
}

class AstroCoin {
  String name;
  int price;
  int number;
  String description;
  ImageProvider image;

  AstroCoin(this.name, this.price, this.image , this.number ,this.description);
}
