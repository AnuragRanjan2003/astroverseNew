class Plan {
  final String name;
  final String identifier;
  final int price;
  final String content;
  final int value;
  final int postPerDay;
  final int servicesPerDay;
  final double maxServicePrice;

  const Plan({
    required this.name,
    required this.identifier,
    required this.price,
    required this.content,
    required this.value,
    required this.postPerDay,
    required this.servicesPerDay,
    required this.maxServicePrice,
  });
}
