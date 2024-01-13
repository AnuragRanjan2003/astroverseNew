// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map json) => Transaction(
      json['id'] as String,
      json['uid'] as String,
      Transaction._dateFromTimeStamp(json['date'] as Timestamp),
      json['itemId'] as String,
      json['itemType'] as String,
      (json['amount'] as num).toDouble(),
      json['orderId'] as String,
      json['status'] != null ? json["status"] as String : "pending",
      json['lastAction'] != null
          ? Transaction._dateFromTimeStamp(json['lastAction'] as Timestamp)
          : null,
    );

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': Transaction._dateAsIs(instance.date),
      'uid': instance.uid,
      'itemId': instance.itemId,
      'itemType': instance.itemType,
      'amount': instance.amount,
      'orderId': instance.orderId,
      'status': instance.status,
      'lastAction': instance.lastAction,
    };
