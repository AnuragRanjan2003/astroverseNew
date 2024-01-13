import 'package:cloud_firestore/cloud_firestore.dart';

class WithdrawRequest {
  final String requestId;
  final String requesterName;
  final String requesterUid;
  final double amount;
  final DateTime date;
  final DateTime? resolvedOn;
  final String status;

  WithdrawRequest(
    this.requestId,
    this.requesterName,
    this.requesterUid,
    this.amount,
    this.date,
    this.resolvedOn,
    this.status,
  );

  factory WithdrawRequest.fromJson(json) => WithdrawRequest(
        json["requestId"] as String,
        json["requesterName"] as String,
        json["requesterUid"] as String,
        (json["amount"] as num).toDouble(),
        (json["date"] as Timestamp).toDate(),
        json["resolvedOn"] != null
            ? (json["resolvedOn"] as Timestamp).toDate()
            : null,
        json["status"] as String,
      );

  Map<String, dynamic> toJson() => {
        "requestId": requestId,
        "requesterName": requesterName,
        "requesterUid": requesterUid,
        "amount": amount,
        "date": date,
        "resolvedOn": resolvedOn,
        "status": status,
      };
}

class WithdrawStatus{
  static const pending = "pending";
}
