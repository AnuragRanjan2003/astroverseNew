import 'package:astroverse/models/plan.dart';
import 'package:astroverse/utils/geo.dart';

class Plans {
  static const plans = [
    Plan("Free", 0, "default plan", 0, 1, 0, 0),
    Plan("Basic", 50, "good plan.nice plan.\nmust take.", 1, 1, 0, 0),
    Plan("Premium", 100, "good plan.nice plan.", 2, 1, 0, 0),
  ];

  static const astroPlans = [
    Plan(
      "Free",
      0,
      "good plan.nice plan.must take.",
      VisibilityPlans.locality,
      1,
      1,
      10.0,
    ),
    Plan(
      "Astro Disha",
      100,
      "good plan.nice plan.must take.",
      VisibilityPlans.city,
      1,
      1,
      10.0,
    ),
    Plan(
      "Astro Kripa",
      300,
      "good plan.nice plan.must take.",
      VisibilityPlans.state,
      1,
      1,
      10.0,
    ),
    Plan(
      "Astro Mahima",
      500,
      "good plan.nice plan.must take.",
      VisibilityPlans.all,
      1,
      1,
      10.0,
    ),
  ];
}
