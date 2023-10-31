// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extra_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExtraInfo _$ExtraInfoFromJson(Map json) => ExtraInfo(
      joiningDate:
          ExtraInfo._dateFromTimeStamp(json['joiningDate'] as Timestamp),
      lastActive: ExtraInfo._dateFromTimeStamp(json['lastActive'] as Timestamp),
      servicesSold: json['servicesSold'] as int,
    );

Map<String, dynamic> _$ExtraInfoToJson(ExtraInfo instance) => <String, dynamic>{
      'joiningDate': ExtraInfo._dateAsIs(instance.joiningDate),
      'lastActive': ExtraInfo._dateAsIs(instance.lastActive),
      'servicesSold': instance.servicesSold,
    };
