import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'extra_info.g.dart';

@JsonSerializable(anyMap: true)
class ExtraInfo {
  @JsonKey(fromJson: _dateFromTimeStamp, toJson: _dateAsIs)
  final DateTime joiningDate;

  @JsonKey(fromJson: _dateFromTimeStamp, toJson: _dateAsIs)
  final DateTime lastActive;

  final int servicesSold;

  final int posts;

  final int moneyGenerated;
  final int moneyWithdrawn;

  ExtraInfo(
      {required this.posts,
      required this.joiningDate,
      required this.lastActive,
      required this.moneyGenerated,
      required this.moneyWithdrawn,
      required this.servicesSold});

  Map<String, dynamic> toJson() => _$ExtraInfoToJson(this);

  factory ExtraInfo.fromJson(json) => _$ExtraInfoFromJson(json);

  static DateTime _dateFromTimeStamp(Timestamp timestamp) =>
      DateTime.parse(timestamp.toDate().toString());

  static DateTime _dateAsIs(DateTime dateTime) => dateTime;
}
