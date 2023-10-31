import 'package:astroverse/models/user.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallInvitationPage extends StatelessWidget {
  final User sender;
  final User receiver;
  final int appId;
  final String appSign;

  const CallInvitationPage({
    super.key,
    required this.sender,
    required this.appId,
    required this.appSign,
    required this.receiver,
  });

  @override
  Widget build(BuildContext context) {
    return ZegoSendCallInvitationButton(
      isVideoCall: false,
      resourceID: "zegouikit_call", // For offline call notification
      invitees: [
        ZegoUIKitUser(
          id: receiver.uid,
          name: receiver.name,
        ),
      ],
    );
  }
}
