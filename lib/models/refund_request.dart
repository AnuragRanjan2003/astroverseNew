import 'package:cloud_firestore/cloud_firestore.dart';

class RefundRequest {
  final String id;
  final String paymentId;
  final String purchaseId;
  final double amountToRefund;
  final double amount;
  final DateTime refundDate;
  final String status;
  final DateTime? lastActionOn;
  final String receiverUid;

  RefundRequest(
      {required this.id,
      required this.paymentId,
      required this.purchaseId,
      required this.amountToRefund,
      required this.amount,
      required this.refundDate,
      required this.status,
      required this.lastActionOn,
      required this.receiverUid});

  factory RefundRequest.fromJson(json) => RefundRequest(
        id: json["id"] as String,
        paymentId: json["paymentId"] as String,
        purchaseId: json["purchaseId"] as String,
        amountToRefund: (json["amountToRefund"] as num).toDouble(),
        amount: (json["amount"] as num).toDouble(),
        refundDate: (json["refundDate"] as Timestamp).toDate(),
        lastActionOn: json["lastActionOn"] != null
            ? (json["lastActionOn"] as Timestamp).toDate()
            : null,
        status: json["status"] as String,
        receiverUid: json["receiverUid"] as String,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "paymentId": paymentId,
        "purchaseId": purchaseId,
        "receiverUid": receiverUid,
        "amount": amount,
        "amountToRefund": amountToRefund,
        "refundDate": refundDate,
        "lastActionOn": lastActionOn,
        "status": status,
      };
}

class RefundStatus{
  static const pending = "pending";
}
