import 'package:astroverse/screens/askLocationScreen/portrait/ask_location_screen.dart';
import 'package:flutter/material.dart';

import '../../utils/responsive.dart';

class AskLocationScreen extends StatelessWidget {
  const AskLocationScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Responsive(
      portrait: (p0) => AskLocationPortrait(cons: p0),
      landscape: (p0) => AskLocationPortrait(cons: p0),
    );
  }
}
