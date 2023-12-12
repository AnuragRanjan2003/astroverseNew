import 'package:astroverse/models/plan.dart';
import 'package:astroverse/utils/geo.dart';

class Plans {
  static const plans = [
    Plan("Basic", 50, "good plan.nice plan.\nmust take.", 0),
    Plan("Premium", 100, "good plan.nice plan.", 1),
  ];

  static const astroPlans = [
    Plan(
      "Free",
      0,
      "good plan.nice plan.must take.",
      VisibilityPlans.locality,
    ),
    Plan(
      "Astro Disha",
      100,
      "good plan.nice plan.must take.",
      VisibilityPlans.city,
    ),
    Plan(
      "Astro Kripa",
      300,
      "good plan.nice plan.must take.",
      VisibilityPlans.state,
    ),
    Plan(
      "Astro Mahima",
      500,
      "good plan.nice plan.must take.",
      VisibilityPlans.all,
    ),
  ];
}
