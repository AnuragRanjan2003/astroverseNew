class Qualification {
  final String body;

  Qualification(this.body);

  Map<String, dynamic> toJson() => {
        'body': body,
      };

  factory Qualification.fromJson(json) =>
      Qualification(json["body"] != null ? json["body"] as String : "");
}
