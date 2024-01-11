import 'package:astroverse/screens/otpScreen/landscape/otp_screen_landscape.dart';
import 'package:astroverse/screens/otpScreen/portrait/otp_screen_portrait.dart';
import 'package:astroverse/screens/phoneAuth/portrait/phone_auth_portrait.dart';
import 'package:astroverse/utils/responsive.dart';
import 'package:flutter/material.dart';

class OtpScreen extends StatelessWidget {
  final PhoneDataParcel parcel;
  const OtpScreen({super.key, required this.parcel});

  @override
  Widget build(BuildContext context) {
    return Responsive(
      portrait: (p0) => OtpScreenPortrait(cons: p0  , dataParcel: parcel,),
      landscape: (p0) => OtpScreenLandscape(cons: p0),
    );
  }
}
