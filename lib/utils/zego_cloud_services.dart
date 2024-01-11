import 'dart:developer';

import 'package:astroverse/utils/env_vars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class ZegoCloudServices {
  static const _duration = 10 * 60;

  Future<void> initCallInvitationService(
          String uid,
          String username,
          ZegoUIKitPrebuiltCallController? controller,
          BuildContext context) async =>
      await ZegoUIKitPrebuiltCallInvitationService().init(
        appID: int.parse(dotenv.get(EnvVars.zegoAppId)),
        appSign: dotenv.get(EnvVars.zegoAppSign),
        userID: uid,
        userName: username,
        controller: controller,
        plugins: [ZegoUIKitSignalingPlugin()],
        requireConfig: (ZegoCallInvitationData data) {
          var config = ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();
          // Modify your custom configurations here.
          config
            ..turnOnCameraWhenJoining = false
            ..turnOnMicrophoneWhenJoining = true
            ..useSpeakerWhenJoining = true
            ..onError = (e) {
              log(e.code.toString(), name: "ZEGO ERROR");
              if (e.code == 107026) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Receiver is currently offline")));
              }
            };
          config.durationConfig
            ..isVisible = true
            ..onDurationUpdate = (Duration duration) {
              if (duration.inSeconds > _duration) {
                log("END CALL", name: "CALL");
                controller?.hangUp(context);
              }
            };

          return config;
        },
      );

  Future<void> disposeCallInvitationService() async =>
      await ZegoUIKitPrebuiltCallInvitationService().uninit();

  ZegoSendCallInvitationButton callButton(
          String receiverId, String receiverName) =>
      ZegoSendCallInvitationButton(
        isVideoCall: false,
        resourceID: "zegouikit_call", // For offline call notification
        invitees: [
          ZegoUIKitUser(
            id: receiverId,
            name: receiverName,
          ),
        ],
      );
}
