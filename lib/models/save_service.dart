import 'package:json_annotation/json_annotation.dart';

part 'save_service.g.dart';

@JsonSerializable()
class SaveService {
  String id;
  String date;

  SaveService(this.id, this.date);

  Map<String, dynamic> toJson() => _$SaveServiceToJson(this);

  factory SaveService.fromJson(json) => _$SaveServiceFromJson(json);
}
