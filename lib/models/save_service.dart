import 'package:astroverse/res/strings/backend_strings.dart';
import 'package:json_annotation/json_annotation.dart';

part 'save_service.g.dart';

@JsonSerializable()
class SaveService {
  String id;
  String date;
  String name;
  String imageUrl;

  SaveService(this.id, this.date , this.name , this.imageUrl);

  Map<String, dynamic> toJson() => _$SaveServiceToJson(this);

  factory SaveService.fromJson(json) => _$SaveServiceFromJson(json);
}
