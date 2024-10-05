
import 'dart:developer';

import '../../../../config.dart';
import '../../../../controllers/bottom_controllers/message_firebase_api.dart';
import '../../../../widgets/common_empty_layout.dart';
import 'load_user.dart';

class MessageLayout extends StatelessWidget {
  const MessageLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<IndexController>(builder: (indexCtrl) {
      log("indexCtrl.message :${indexCtrl.message.length}");
      return Column(
        children: [
          if (indexCtrl.userText.text.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return LoadUser(
                    document: indexCtrl.searchMessage[index],
                    blockBy: indexCtrl.user["id"],
                    currentUserId: indexCtrl.user["id"],indexCtrl: indexCtrl,);
              },
              itemCount: indexCtrl.searchMessage.length,
            ),
          if (!indexCtrl.userText.text.isNotEmpty)
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection(collectionName.users)
                    .doc(indexCtrl.user["id"])
                    .collection(collectionName.chats)
                    .orderBy("updateStamp", descending: true)
                    .limit(15)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return CommonEmptyLayout(
                        gif: eImageAssets.noChat,
                        title: appFonts.noChat.tr,
                        desc: appFonts.thereIsNoChat.tr);
                  } else if (!snapshot.hasData) {
                    return Center(
                        child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          appCtrl.appTheme.primary),
                    )).height(MediaQuery.of(context).size.height);
                  } else {
                    indexCtrl.message =
                        MessageFirebaseApi().chatListWidget(snapshot);

                    return !snapshot.hasData
                        ? Center(
                                child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        appCtrl.appTheme.primary)))
                            .height(MediaQuery.of(context).size.height)
                            .expanded()
                        : indexCtrl.message.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                padding:EdgeInsets.zero,
                                itemBuilder: (context, index) {
                                  return LoadUser(
                                      indexCtrl: indexCtrl,
                                      document: indexCtrl.message[index],
                                      blockBy: indexCtrl.user["id"],
                                      currentUserId: indexCtrl.user["id"]);
                                },
                                itemCount: indexCtrl.message.length,
                              )
                            : CommonEmptyLayout(
                                gif: eImageAssets.noChat,
                                title: appFonts.noChat.tr,
                                desc: appFonts.thereIsNoChat.tr);
                  }
                }),
        ],
      );
    });
  }
}
