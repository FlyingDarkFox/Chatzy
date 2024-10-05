import 'dart:developer';

import '../../../../config.dart';
import 'group_message_card_layout.dart';

class GroupMessageCard extends StatelessWidget {
  final DocumentSnapshot? document;
  final String? currentUserId;

  const GroupMessageCard({super.key, this.document, this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<IndexController>(builder: (indexCtrl) {
      return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(collectionName.groups)
              .doc(document!["groupId"])
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            } else {
              return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(document!["senderId"])
                      .snapshots(),
                  builder: (context, userSnapShot) {
                    if (userSnapShot.hasData) {
                      return GroupMessageCardLayout(
                              snapshot: snapshot,
                              document: document,
                              currentUserId: currentUserId,
                              userSnapShot: userSnapShot)
                          .inkWell(onTap: () {
                        var data = {
                          "message": document!.data(),
                          "groupData": snapshot.data!.data()
                        };

                        log("data :$data");
                        final chatCtrl =
                            Get.isRegistered<GroupChatMessageController>()
                                ? Get.find<GroupChatMessageController>()
                                : Get.put(GroupChatMessageController());
                        if (Responsive.isMobile(context)) {
                          Get.toNamed(routeName.groupChat, arguments: data);
                        } else {
                          indexCtrl.chatId = document!["groupId"];
                          indexCtrl.chatType = 1;
                          indexCtrl.update();
                        }
                        chatCtrl.data = data;
                        indexCtrl.update();

                        chatCtrl.update();
                        chatCtrl.pId = document!["groupId"];

                        chatCtrl.onReady();
                      });
                    } else {
                      return Container();
                    }
                  }).width(MediaQuery.of(context).size.width);
            }
          });
    });
  }
}
