import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart' as c;
import 'package:flutter/material.dart';

class Messaging extends StatelessWidget {
  final c.User receiver;

  const Messaging({super.key, required this.receiver});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 120),
              child: CometChatMessageList(
                user: receiver,
                hideTimestamp: true,
                waitIcon: const Text(""),
                scrollToBottomOnNewMessages: true,
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: 120,
                  child: CometChatMessageComposer(
                    user: receiver,
                    attachmentIcon: const Icon(Icons.attach_file),
                    attachmentOptions: (context, user, group, id) {
                      final defaultAttachmentOptions =
                          CometChatUIKit.getDataSource().getAttachmentOptions(
                              cometChatTheme, context, id);
                      defaultAttachmentOptions.removeWhere((element) {
                        return element.id == "file" ||
                            element.id == "audio" ||
                            element.id == "photoAndVideo";
                      });

                      return defaultAttachmentOptions;
                    },
                    messageComposerStyle:
                        const MessageComposerStyle(borderRadius: 0),
                  ),
                )),
            c.CometChatMessageHeader(
              user: receiver,
              backButton: (context) => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Future<ActionItem?>? showActionSheet(BuildContext context) {
    ActionItem item1 = ActionItem(
        id: '1',
        title: 'files',
        background: Colors.blue,
        cornerRadius: 20,
        onItemClick: () {
          //any function you want to perform
        });

    ActionItem item2 = ActionItem(
        id: '2',
        title: 'image',
        background: Colors.blue,
        cornerRadius: 20,
        onItemClick: () {});
    return showCometChatActionSheet(
        context: context,
        actionItems: [item1, item2],
        titleStyle: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w500,
            color: cometChatTheme.palette.getAccent()),
        backgroundColor: cometChatTheme.palette.getBackground(),
        iconBackground: cometChatTheme.palette.getAccent100(),
        layoutIconColor: cometChatTheme.palette.getPrimary());
  }
}
