import 'package:astroverse/utils/vote_type_enum.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Voter {
  final String uid;
  final VoteType? type;
  final String name;
  final DateTime time;

  Voter(
      {required this.uid,
      required this.type,
      required this.name,
      required this.time});

  factory Voter.fromJson(json) => Voter(
        uid: json['uid'] as String,
        type: voteTypeFormString(json['type'] as String),
        name: json['name'] as String,
        time: (json['time'] as Timestamp).toDate(),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'uid': uid,
        'type': type == null ? "" : type!.name,
        'time': Timestamp.fromDate(time),
      };
}
