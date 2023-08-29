import 'package:astroverse/screens/upiscreen/portrait/enter_upi_portrait.dart';
import 'package:flutter/material.dart';

import '../../utils/responsive.dart';

class EnterUpiScreen extends StatelessWidget {
  const EnterUpiScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Responsive(
      portrait: (p0) => EnterUpiPortrait(cons: p0),
      landscape: (p0) => EnterUpiPortrait(cons: p0),
    );
  }
}
