import 'package:astroverse/screens/createService/landscape/create_post_landscape.dart';
import 'package:astroverse/screens/createService/portrait/create_service_portrait.dart';
import 'package:astroverse/utils/responsive.dart';
import 'package:flutter/material.dart';

class CreateServiceScreen extends StatelessWidget {
  const CreateServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive(
      portrait: (p0) => CreateServicePortrait(cons: p0),
      landscape: (p0) => CreateServiceLandscape(cons: p0),
    );
  }
}
