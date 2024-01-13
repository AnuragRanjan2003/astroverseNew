import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'transaction.g.dart';

@JsonSerializable(anyMap: true)
class Transaction {
  final String id;
  @JsonKey(fromJson: _dateFromTimeStamp, toJson: _dateAsIs)
  DateTime date;
  DateTime? lastAction;
  final String uid;
  final String itemId;
  final String itemType;
  final double amount;
  final String status;
  final String orderId;

  Transaction(this.id, this.uid, this.date, this.itemId, this.itemType,
      this.amount, this.orderId, this.status,this.lastAction);

  factory Transaction.fromJson(json) => _$TransactionFromJson(json);

  Map<String,dynamic> toJson() => _$TransactionToJson(this);

  static DateTime _dateFromTimeStamp(Timestamp timestamp) =>
      DateTime.parse(timestamp.toDate().toString());

  static DateTime _dateAsIs(DateTime dateTime) => dateTime;
}

class TransactionStatus{
  static const pending = "Pending";
  static const complete = "complete";
  static const canceledByUser = "canceledByUser";
}
