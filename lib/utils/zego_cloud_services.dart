import 'package:astroverse/utils/env_vars.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class ZegoCloudServices {
  Future<void> initCallInvitationService(String uid, String username) async =>
      await ZegoUIKitPrebuiltCallInvitationService().init(
        appID: int.parse(dotenv.get(EnvVars.zegoAppId)),
        appSign: dotenv.get(EnvVars.zegoAppSign),
        userID: uid,
        userName: username,
        plugins: [ZegoUIKitSignalingPlugin()],
        requireConfig: (ZegoCallInvitationData data) {
          var config = ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();
          // Modify your custom configurations here.
          config
            ..turnOnCameraWhenJoining = false
            ..turnOnMicrophoneWhenJoining = true
            ..useSpeakerWhenJoining = true;
          return config;
        },
      );

  Future<void> disposeCallInvitationService() async =>
      await ZegoUIKitPrebuiltCallInvitationService().uninit();

  ZegoSendCallInvitationButton callButton(String receiverId,
          String receiverName) =>
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
