// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extra_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExtraInfo _$ExtraInfoFromJson(Map json) => ExtraInfo(
      posts: json['posts'] as int,
      joiningDate:
          ExtraInfo._dateFromTimeStamp(json['joiningDate'] as Timestamp),
      lastActive: ExtraInfo._dateFromTimeStamp(json['lastActive'] as Timestamp),
      servicesSold: json['servicesSold'] as int,
      moneyGenerated:
          json["moneyGenerate"] != null ? json["moneyGenerated"] as int : 0,
      moneyWithdrawn:
          json["moneyWithdrawn"] != null ? json["moneyWithdrawn"] as int : 0,
    );

Map<String, dynamic> _$ExtraInfoToJson(ExtraInfo instance) => <String, dynamic>{
      'joiningDate': ExtraInfo._dateAsIs(instance.joiningDate),
      'lastActive': ExtraInfo._dateAsIs(instance.lastActive),
      'servicesSold': instance.servicesSold,
      'posts': instance.posts,
      'moneyGenerated': instance.moneyGenerated,
      'moneyWithdrawn': instance.moneyWithdrawn,
    };
