import 'package:astroverse/res/strings/backend_strings.dart';

class DeletedService {
  String id;
  final String date;
  final String name;
  final String imageUrl;
  final String status;

  DeletedService({required this.id,
    required this.date,
    required this.name,
    required this.imageUrl,
    required this.status});

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'date': date,
        'name': name,
        'imageUrl': imageUrl,
        'status': status,
      };

  factory DeletedService.fromJson(json) =>
      DeletedService(
        id: json['id'] as String,
        date: json['date'] as String,
        name: json['name'] as String,
        imageUrl: json['imageUrl'] == null
            ? BackEndStrings.defaultServiceImage
            : json["imageUrl"] as String,
        status: json["status"] as String,
      );
}
