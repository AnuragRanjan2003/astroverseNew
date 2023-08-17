import 'dart:core';

import 'package:json_annotation/json_annotation.dart';

part 'item.g.dart';

@JsonSerializable()
class Item {
  final String title;
  final String disc;
  final String userID;
  final String userName;
  final double price;
  final String lat;
  final String long;
  final List<String> category;
  final String address;
  final String id;
  final DateTime date;
  final String uses;
  final int type;
  final String imageURL;

  Item(
    this.title,
    this.userID,
    this.userName,
    this.price,
    this.lat,
    this.long,
    this.address,
    this.id,
    this.date,
    this.uses,
    this.category,
    this.disc, this.imageURL, this.type,
  );

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);

  @override
  String toString() {
    return "Item($title,$userID,$userName,$price,$lat,$long,$address,$id,$date,$uses,$category,$disc,$imageURL,$type)";
  }
}
