import 'package:intl/intl.dart';
import '../../../../config.dart';

class BroadCastMessageCard extends StatelessWidget {
  final DocumentSnapshot? document;
  final String? currentUserId;

  const BroadCastMessageCard({super.key, this.document, this.currentUserId})
     ;

  @override
  Widget build(BuildContext context) {
    String nameList ="";
    List selectedContact = document!["receiverId"];
    selectedContact.asMap().forEach((key, value) {
      if (nameList != "") {
        nameList = "$nameList, ${value["name"]}";
      } else {
        nameList = value["name"];
      }
    });
    return GetBuilder<IndexController>(
      builder: (indexCtrl) {
        return Column(children: [
          Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                Row(children: [
                  Container(
                      height: Sizes.s52,
                      width: Sizes.s52,
                      decoration: BoxDecoration(
                          color: appCtrl.appTheme.primaryLight1,
                          shape: BoxShape.circle),
                      child: SvgPicture.asset(eSvgAssets.broadCast,
                          height: Sizes.s25,
                          width: Sizes.s25,
                          fit: BoxFit.scaleDown,
                          colorFilter: ColorFilter.mode(appCtrl.appTheme.primary,BlendMode.srcIn))),
                  const HSpace(Sizes.s12),
                  SizedBox(
                    width: Sizes.s150,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(/*document!["name"] != "Broadcast" && document!["name"] != "" ?*/ document!["name"] ?? nameList /*: nameList*/ ,overflow: TextOverflow.ellipsis,
                              style: AppCss.manropeblack14
                                  .textColor(appCtrl.appTheme.black)),
                          const VSpace(Sizes.s5),
                          Text( document!["lastMessage"] != ""? decryptMessage(document!["lastMessage"]) : "",
                              overflow: TextOverflow.ellipsis,
                              style: AppCss.manropeMedium14
                                  .textColor(appCtrl.appTheme.darkText))
                        ])
                  )
                ]),
                Text(
                        DateFormat('hh:mm a').format(
                            DateTime.fromMillisecondsSinceEpoch(
                                int.parse(document!['updateStamp']))),
                        style: AppCss.manropeMedium12
                            .textColor(

                            indexCtrl.chatId == document!["broadcastId"] ? appCtrl.appTheme.primary : appCtrl.appTheme.darkText))
                    .paddingOnly(top: Insets.i8)
              ])
              .paddingSymmetric(vertical: Insets.i15)
              .inkWell(onTap: () {
            var data = {
              "broadcastId": document!["broadcastId"],
              "data": document!.data(),
            };

            final chatCtrl =
            Get.isRegistered<BroadcastChatController>()
                ? Get.find<BroadcastChatController>()
                : Get.put(BroadcastChatController());
            if (Responsive.isMobile(context)) {
              Get.toNamed(routeName.broadcastChat, arguments: data);
            } else {
              indexCtrl.chatId = document!["broadcastId"];
              indexCtrl.chatType = 1;
              indexCtrl.update();
            }
            chatCtrl.data = data;
            indexCtrl.update();

            chatCtrl.update();
            chatCtrl.pId = document!["broadcastId"];

            chatCtrl.onReady();
          }).paddingSymmetric(vertical: Insets.i15),
          Divider(height: 1, thickness: 1, color: appCtrl.appTheme.borderColor)
        ]);
      }
    );
  }
}
