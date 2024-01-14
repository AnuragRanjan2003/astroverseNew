// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Purchase _$PurchaseFromJson(Map json) => Purchase(
      itemId: json['itemId'] as String,
      purchaseId: json['purchaseId'] as String,
      paymentId: json['paymentId'] as String,
      itemPrice: json['itemPrice'] as String,
      totalPrice: json['totalPrice'] as String,
      itemImage: json['itemImage'] as String,
      itemName: json['itemName'] as String,
      buyerId: json['buyerId'] as String,
      buyerName: json['buyerName'] as String,
      sellerId: json['sellerId'] as String,
      sellerName: json['sellerName'] as String,
      boughtOn: Purchase._dateFromTimeStamp(json['boughtOn'] as Timestamp),
      delivered: json['delivered'] as bool,
      review: json['review'] as int?,
      refundId: json['refundId'] as String?,
      active: (json['active'] ?? true) as bool,
      deliveryMethod: (json['deliveryMethod'] as num).toInt(),
      deliveredOn: Purchase._nullableDateFromTimeStamp(
          json['deliveredOn'] as Timestamp?),
      secretCode: Purchase._getNullableString(json['secretCode']),
    );

Map<String, dynamic> _$PurchaseToJson(Purchase instance) => <String, dynamic>{
      'itemId': instance.itemId,
      'purchaseId': instance.purchaseId,
      'itemPrice': instance.itemPrice,
      'totalPrice': instance.totalPrice,
      'buyerId': instance.buyerId,
      'buyerName': instance.buyerName,
      'sellerId': instance.sellerId,
      'sellerName': instance.sellerName,
      'itemImage': instance.itemImage,
      'itemName': instance.itemName,
      'boughtOn': Purchase._dateAsIs(instance.boughtOn),
      'delivered': instance.delivered,
      'review': instance.review,
      'refundId': instance.refundId,
      'deliveredOn': Purchase._nullableDateAsIs(instance.deliveredOn),
      'paymentId': instance.paymentId,
      'secretCode': instance.secretCode,
      'deliveryMethod': instance.deliveryMethod,
      'active': instance.active,
    };
