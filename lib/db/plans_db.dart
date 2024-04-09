import 'package:astroverse/models/plan.dart';
import 'package:astroverse/utils/geo.dart';

class Plans {
  static const plans = [
    Plan(
        name: "Free",
        price: 0,
        content: "default plan",
        value: 0,
        postPerDay: 1,
        servicesPerDay: 0,
        maxServicePrice: 0),
    Plan(
        name: "Basic",
        price: 50,
        content: "good plan.nice plan.\nmust take.",
        value: 1,
        postPerDay: 1,
        servicesPerDay: 0,
        maxServicePrice: 0),
    Plan(
        name: "Premium",
        price: 100,
        content: "good plan.nice plan.",
        value: 2,
        postPerDay: 1,
        servicesPerDay: 0,
        maxServicePrice: 0),
  ];

  static const astroPlans = [
    Plan(
      name: "Free",
      price: 0,
      content: "good plan.nice plan.must take.",
      value: VisibilityPlans.locality,
      postPerDay: 1,
      servicesPerDay: 1,
      maxServicePrice: 0.0,
    ),
    Plan(
      name: "Astro Disha",
      price: 100,
      content: "good plan.nice plan.must take.",
      value: VisibilityPlans.city,
      postPerDay: 10,
      servicesPerDay: 10,
      maxServicePrice: 100.0,
    ),
    Plan(
      name: "Astro Kripa",
      price: 300,
      content: "good plan.nice plan.must take.",
      value: VisibilityPlans.state,
      postPerDay: 50,
      servicesPerDay: 50,
      maxServicePrice: 1000.0,
    ),
    Plan(
      name: "Astro Mahima",
      price: 500,
      content: "good plan.nice plan.must take.",
      value: VisibilityPlans.all,
      postPerDay: 100,
      servicesPerDay: 100,
      maxServicePrice: 10000,
    ),
  ];
}
