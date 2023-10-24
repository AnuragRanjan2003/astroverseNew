import 'package:astroverse/controllers/location_controller.dart';
import 'package:astroverse/controllers/main_controller.dart';
import 'package:astroverse/screens/main/landscape/main_screen_landscape.dart';
import 'package:astroverse/screens/main/portrait/main_screen_portrait.dart';
import 'package:astroverse/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import '../../controllers/auth_controller.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final main = Get.put(MainController());
    final AuthController auth = Get.find();
    ZegoUIKitPrebuiltCallInvitationService().init(
      appID: int.parse(dotenv.get("ZEGOAPPID")),
      appSign: dotenv.get("ZEGOAPPSIGN"),
      userID: auth.user.value!.uid,
      userName: auth.user.value!.name,
      plugins: [ZegoUIKitSignalingPlugin()],
      requireConfig: (ZegoCallInvitationData data) {
        var config = (data.invitees.length > 1)
            ? ZegoCallType.videoCall == data.type
            ? ZegoUIKitPrebuiltCallConfig.groupVideoCall()
            : ZegoUIKitPrebuiltCallConfig.groupVoiceCall()
            : ZegoCallType.videoCall == data.type
            ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
            : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();

        // Modify your custom configurations here.
        config
          ..turnOnCameraWhenJoining = false
          ..turnOnMicrophoneWhenJoining = false
          ..useSpeakerWhenJoining = true;
        return config;
      },
    );

    Get.put(LocationController());
    main.setUser(auth.user.value);
    return Responsive(
        portrait: (cons) => MainScreenPortrait(cons: cons),
        landscape: (cons) => MainScreenLandscape(cons: cons));
  }
}
