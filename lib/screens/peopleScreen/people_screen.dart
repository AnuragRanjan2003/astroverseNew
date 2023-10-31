import 'package:astroverse/screens/peopleScreen/landscape/people_screen_landscape.dart';
import 'package:astroverse/screens/peopleScreen/portrait/people_screen_portrait.dart';
import 'package:astroverse/utils/responsive.dart';
import 'package:flutter/material.dart';

class PeopleScreen extends StatelessWidget {
  const PeopleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive(
      portrait: (p0) => PeopleScreenPortrait(cons: p0),
      landscape: (p0) => PeopleScreenLandscape(cons: p0),
    );
  }
}
