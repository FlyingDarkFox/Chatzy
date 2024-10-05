import 'dart:developer';

import 'package:smooth_corner/smooth_corner.dart';

import '../../../../config.dart';
import '../../message/broadcast_card.dart';
import '../../message/group_message_card.dart';
import '../../message/message_card.dart';
import '../../message/receiver_message_card.dart';

class LoadUser extends StatelessWidget {
  final DocumentSnapshot? document;
  final String? currentUserId, blockBy;
  final IndexController? indexCtrl;

  const LoadUser(
      {Key? key,
      this.document,
      this.currentUserId,
      this.blockBy,
      this.indexCtrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    if (document!["isGroup"] == false && document!["isBroadcast"] == false) {
      if (document!["senderId"] == appCtrl.user['id']) {
        return Container(
          padding: EdgeInsets.symmetric(
              horizontal:
                  Responsive.isMobile(context) ? Insets.i20 : Insets.i30),
          decoration: BoxDecoration(
              backgroundBlendMode: BlendMode.srcIn,
              color: indexCtrl!.chatId == document!["chatId"]
                  ? appCtrl.appTheme.primaryLight1
                  : appCtrl.appTheme.trans,
              border: Border(
                  left: BorderSide(
                      color: indexCtrl!.chatId == document!["chatId"]
                          ? appCtrl.appTheme.primary
                          : appCtrl.appTheme.trans,
                      width: 4))),
          child: ReceiverMessageCard(
              document: document,
              currentUserId: appCtrl.user['id'],
              blockBy: blockBy),
        );
      } else {
        return Container(
          padding: EdgeInsets.symmetric(
              horizontal:
                  Responsive.isMobile(context) ? Insets.i20 : Insets.i30),
          decoration: BoxDecoration(
            backgroundBlendMode: BlendMode.srcIn,
            color: indexCtrl!.chatId == document!["chatId"]
                ? appCtrl.appTheme.primaryLight1
                : appCtrl.appTheme.trans,
              border: Border(
                  left: BorderSide(
                      color: indexCtrl!.chatId == document!["chatId"]
                          ? appCtrl.appTheme.primary
                          : appCtrl.appTheme.trans,
                      width: 4))
          ),
          child: MessageCard(
              blockBy: blockBy,
              document: document,
              currentUserId: currentUserId),
        );
      }
    } else if (document!["isGroup"] == true) {
      List user = document!["receiverId"];
      return user.where((element) => element["id"] == currentUserId).isNotEmpty
          ? Container(
              padding: EdgeInsets.symmetric(
                  horizontal:
                      Responsive.isMobile(context) ? Insets.i20 : Insets.i30),
              decoration: BoxDecoration(
                backgroundBlendMode: BlendMode.srcIn,
                color: indexCtrl!.chatId == document!["groupId"]
                    ? appCtrl.appTheme.primaryLight1
                    : appCtrl.appTheme.trans,
                  border: Border(
                      left: BorderSide(
                          color: indexCtrl!.chatId == document!["groupId"]
                              ? appCtrl.appTheme.primary
                              : appCtrl.appTheme.trans,
                          width: 4))
              ),
              child: GroupMessageCard(
                  document: document, currentUserId: currentUserId))
          : Container();
    } else if (document!["isBroadcast"] == true) {
      return document!["senderId"] == currentUserId
          ? Container(
              padding: EdgeInsets.symmetric(
                  horizontal:
                      Responsive.isMobile(context) ? Insets.i20 : Insets.i30),
              decoration: BoxDecoration(
                backgroundBlendMode: BlendMode.srcIn,
                color: indexCtrl!.chatId == document!["broadcastId"]
                    ? appCtrl.appTheme.primaryLight1
                    : appCtrl.appTheme.trans,
                  border: Border(
                      left: BorderSide(
                          color: indexCtrl!.chatId == document!["broadcastId"]
                              ? appCtrl.appTheme.primary
                              : appCtrl.appTheme.trans,
                          width: 4))
              ),
              child: BroadCastMessageCard(
                document: document,
                currentUserId: currentUserId,
              ))
          : Container(
              padding: EdgeInsets.symmetric(
                  horizontal:
                      Responsive.isMobile(context) ? Insets.i20 : Insets.i30),
              decoration: BoxDecoration(
                backgroundBlendMode: BlendMode.srcIn,
                color: indexCtrl!.chatId == document!["chatId"]
                    ? appCtrl.appTheme.primaryLight1
                    : appCtrl.appTheme.trans,
                  border: Border(
                      left: BorderSide(
                          color: indexCtrl!.chatId == document!["chatId"]
                              ? appCtrl.appTheme.primary
                              : appCtrl.appTheme.trans,
                          width: 4))
              ),
              child: MessageCard(
                  document: document,
                  currentUserId: currentUserId,
                  blockBy: blockBy),
            );
    } else {
      return Container();
    }
  }
}
