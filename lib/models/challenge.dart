import 'package:astroverse/components/upgrade_features_bottom_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Challenge {
  final String id;
  final String title;
  final String body;
  final String status;
  final DateTime publishDate;
  final int totalVotes;
  final int votesFor;
  final int votesAgainst;

  Challenge({
    required this.id,
    required this.title,
    required this.body,
    required this.status,
    required this.publishDate,
    this.totalVotes = 0,
    required this.votesFor,
    required this.votesAgainst,
  });

  factory Challenge.fromJson(json) => Challenge(
      id: json["id"] as String,
      title: json["title"] as String,
      body: json["body"] as String,
      status: json["status"] as String,
      publishDate: (json["publishDate"] as Timestamp).toDate(),
      totalVotes: (json["votesFor"] as num).toInt() +
          (json["votesAgainst"] as num).toInt(),
      votesFor: (json["votesFor"] as num).toInt(),
      votesAgainst: (json["votesAgainst"] as num).toInt());

  Json toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'status': status,
        'publishDate': publishDate,
        'votesFor': votesFor,
        'votesAgainst': votesAgainst,
      };
}
