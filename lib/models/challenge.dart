import 'package:astroverse/components/upgrade_features_bottom_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Challenge {
  final String id;
  final String title;
  final String body;
  final String status;
  final DateTime publishDate;
  final int optionsCount;
  final List<String> optionsName;
  final List<int> optionsVotes;

  Challenge({
    required this.id,
    required this.title,
    required this.body,
    required this.status,
    required this.publishDate,
    required this.optionsCount,
    required this.optionsName,
    required this.optionsVotes,
  });

  factory Challenge.fromJson(json) => Challenge(
      id: json["id"] as String,
      title: json["title"] as String,
      body: json["body"] as String,
      status: json["status"] as String,
      publishDate: (json["publishDate"] as Timestamp).toDate(),
      optionsCount: (json["optionsCount"] as num).toInt(),
      optionsVotes: (json["optionsVotes"] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      optionsName: (json["optionsName"] as List<dynamic>)
          .map((e) => e as String)
          .toList());

  Json toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'status': status,
        'publishDate': publishDate,
        "optionsCount": optionsCount,
        'optionsVotes': optionsVotes,
        "optionsName": optionsName,
      };
}
