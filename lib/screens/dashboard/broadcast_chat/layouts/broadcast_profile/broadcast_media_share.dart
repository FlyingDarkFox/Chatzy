import 'dart:developer';

import '../../../../../config.dart';
import '../../../../../widgets/media_share_layout.dart';


class BroadcastMediaShare extends StatelessWidget {
  final String? chatId;
  final chatCtrl = Get.put(BroadcastChatController());

  BroadcastMediaShare({super.key, this.chatId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BroadcastChatController>(builder: (chatCtrl) {
      return StreamBuilder(
        stream: FirebaseFirestore.instance .collection(collectionName.users)
            .doc(appCtrl.user["id"])
            .collection(collectionName.broadcastMessage)
            .doc(chatId)
            .collection(collectionName.chat)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List messages = [];
            List docs = [];
            List links = [];
            if (snapshot.data!.docs.isNotEmpty) {
              snapshot.data!.docs.asMap().entries.forEach((e) {
                log("MESSAGE LIST ${e.value.data()}");
                if (e.value.data()["type"] == MessageType.image.name ||
                    e.value.data()["type"] == MessageType.video.name) {
                  messages.add(e.value.data());
                } else if (e.value.data()["type"] == MessageType.doc.name) {
                  docs.add(e.value.data());
                } else if (e.value.data()["type"] == MessageType.link.name) {
                  links.add(e.value.data());
                }
              });
            }
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...chatCtrl.mediaList
                      .asMap()
                      .entries
                      .map(
                          (e) => MediaShareLayout(
                          index: e.key,
                          list: chatCtrl.mediaList,
                          title: e.value,
                          mediaCount: e.key == 0
                              ? messages.length.toString()
                              : e.key == 1
                              ? docs.length.toString()
                              : links.length.toString(),
                        )
                  )
                      ,
                  Divider(
                      height: 1,
                      thickness: 1,
                      color: appCtrl.appTheme.borderColor)
                      .paddingSymmetric(vertical: Insets.i20),
                ]);
          } else {
            return Container();
          }
        },
      );
    });
  }
}