import 'package:astroverse/utils/vote_type_enum.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Voter {
  final String uid;
  final int type;
  final String name;
  final DateTime time;

  Voter(
      {required this.uid,
      required this.type,
      required this.name,
      required this.time});

  factory Voter.fromJson(json) => Voter(
        uid: json['uid'] as String,
        type: (json['type'] as num).toInt(),
        name: json['name'] as String,
        time: (json['time'] as Timestamp).toDate(),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'uid': uid,
        'type': type,
        'time': Timestamp.fromDate(time),
      };
}
