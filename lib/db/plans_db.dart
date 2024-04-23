import 'package:astroverse/models/plan.dart';
import 'package:astroverse/utils/geo.dart';

class Plans {
  static const plans = [
    Plan(
        name: "Free",
        identifier: "user_free",
        price: 0,
        content: "default plan",
        value: 0,
        postPerDay: 1,
        servicesPerDay: 0,
        maxServicePrice: 0),
    // Plan(
    //     name: "Basic",
    //     identifier: "user_basic",
    //     price: 0,
    //     content: "default plan",
    //     value: 1,
    //     postPerDay: 1,
    //     servicesPerDay: 0,
    //     maxServicePrice: 0),
    Plan(
        name: "Premium",
        identifier: "user_premium",
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
      identifier: "astro_free",
      price: 0,
      content: "good plan.nice plan.must take.",
      value: VisibilityPlans.locality,
      postPerDay: 1,
      servicesPerDay: 1,
      maxServicePrice: 0.0,
    ),
    Plan(
      name: "Astro Disha",
      identifier: "astro_disha",
      price: 100,
      content: "good plan.nice plan.must take.",
      value: VisibilityPlans.city,
      postPerDay: 10,
      servicesPerDay: 10,
      maxServicePrice: 100.0,
    ),
    Plan(
      name: "Astro Kripa",
      identifier: "astro_kripa",
      price: 300,
      content: "good plan.nice plan.must take.",
      value: VisibilityPlans.state,
      postPerDay: 50,
      servicesPerDay: 50,
      maxServicePrice: 1000.0,
    ),
    Plan(
      name: "Astro Mahima",
      identifier: "astro_mahima",
      price: 500,
      content: "good plan.nice plan.must take.",
      value: VisibilityPlans.all,
      postPerDay: 100,
      servicesPerDay: 100,
      maxServicePrice: 10000,
    ),
  ];
}
