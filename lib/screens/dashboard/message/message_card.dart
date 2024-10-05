import 'dart:developer';
import 'package:chatzy_web/screens/dashboard/message/sub_title_layout.dart';
import 'package:chatzy_web/screens/dashboard/message/trailing_layout.dart';

import '../../../../config.dart';
import 'image_layout.dart';

class MessageCard extends StatelessWidget {
  final DocumentSnapshot? document;
  final String? currentUserId, blockBy;

  const MessageCard(
      {super.key, this.document, this.currentUserId, this.blockBy});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<IndexController>(builder: (indexCtrl) {
      return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(collectionName.users)
              .doc(document!["senderId"])
              .snapshots(),
          builder: (context, snapshot) {
            return snapshot.data != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                            Row(children: [
                              ImageLayout(id: document!["senderId"]),
                              const HSpace(Sizes.s12),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        (snapshot.hasData &&
                                                snapshot.data!.exists &&
                                                snapshot.data!.data() != null)
                                            ? snapshot.data!.data()!["name"]
                                            : document!['name'],
                                        style: AppCss.manropeblack18.textColor(
                                            appCtrl.appTheme.darkText)),
                                    const VSpace(Sizes.s6),
                                    const VSpace(Sizes.s5),
                                    document!["lastMessage"] != null &&
                                            document!["lastMessage"] != ""
                                        ? SubTitleLayout(
                                            document: document,
                                            name: snapshot.data!["name"],
                                            blockBy: blockBy)
                                        : Container()
                                  ])
                            ]),
                            TrailingLayout(
                                    currentUserId: currentUserId,
                                    document: document)
                                .width(Sizes.s55)
                          ])
                          .width(MediaQuery.of(context).size.width)
                          .paddingSymmetric(vertical: Insets.i15)
                          .inkWell(onTap: () async {
                        UserContactModel? userContact;
                        await FirebaseFirestore.instance
                            .collection(collectionName.users)
                            .doc(document!["senderId"])
                            .get()
                            .then((value) {
                          if (value.exists) {
                            log("IMAGE :${value.data()!["image"]}");
                            userContact = UserContactModel(
                                username: value.data()!['name'],
                                uid: document!["senderId"],
                                phoneNumber: value.data()!["phone"],
                                image: value.data()!["image"] ?? "",
                                isRegister: true);
                            var data = {
                              "chatId": document!["chatId"],
                              "data": userContact,
                              "message": null
                            };
                            if (Responsive.isMobile(context)) {
                              Get.toNamed(routeName.chat, arguments: data);
                            } else {
                              indexCtrl.chatId = document!["chatId"];
                              indexCtrl.chatType = 0;
                              indexCtrl.update();
                            }
                            final chatCtrl = Get.isRegistered<ChatController>()
                                ? Get.find<ChatController>()
                                : Get.put(ChatController());

                            chatCtrl.data = data;

                            chatCtrl.update();
                            chatCtrl.onReady();
                          }
                        });
                      }),
                      Divider(
                          height: 1,
                          color: appCtrl.appTheme.borderColor,
                          thickness: 1)
                    ],
                  )
                : Container();
          });
    });
  }
}
