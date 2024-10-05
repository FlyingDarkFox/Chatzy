import 'dart:developer';

import 'package:smooth_corner/smooth_corner.dart';

import '../../../../../config.dart';

import '../../../../../controllers/app_pages_controllers/chat_controller.dart';
import '../../../../../widgets/block_report_layout.dart';
import '../../../../../widgets/common_photo_view.dart';
import '../../../../../widgets/gradiant_button_common.dart';
import 'audio_video_layout.dart';
import 'chat_user_images.dart';

class ChatUserProfile extends StatefulWidget {
  const ChatUserProfile({super.key});

  @override
  State<ChatUserProfile> createState() => _ChatUserProfileState();
}

class _ChatUserProfileState extends State<ChatUserProfile> {
  var scrollController = ScrollController();
  int topAlign = 5;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    scrollController = ScrollController()
      ..addListener(() {
        setState(() {});
      });
  }

//----------
  bool get isSliverAppBarExpanded {
    return scrollController.hasClients &&
        scrollController.offset > (130 - kToolbarHeight);
  }

  @override
  Widget build(BuildContext context) {
    if (isSliverAppBarExpanded) {
      topAlign = topAlign + 1;
    } else {
      topAlign = 5;
    }
    return GetBuilder<ChatController>(builder: (chatCtrl) {
      log("CHAT IDD ${chatCtrl.chatId}");
      return  Container(
        color: appCtrl.appTheme.white,
        width: Sizes.s450,
        height: MediaQuery.of(context).size.height ,


        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(
              alignment: Alignment.topRight,
              children: [
            Stack(alignment: Alignment.bottomLeft, children: [
              chatCtrl.pData != null && chatCtrl.pData["image"] != null
                  ? CachedNetworkImage(
                  imageUrl: chatCtrl.pData["image"],
                  imageBuilder: (context, imageProvider) => SmoothContainer(
                      height: Sizes.s240,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25),bottomRight: Radius.circular(25)),
                      foregroundDecoration: BoxDecoration(
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25),bottomRight: Radius.circular(25)),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image:imageProvider)))
                      .inkWell(
                      onTap: () => Get.to(CommonPhotoView(
                          image: chatCtrl.pData["image"]))),
                  placeholder: (context, url) => Container(
                      height: Sizes.s240,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                          vertical: Insets.i10),
                      child: SizedBox(
                          child: Text(
                              chatCtrl.pData["name"] != null
                                  ? chatCtrl.pData["name"].length >
                                  2
                                  ? chatCtrl.pData["name"]
                                  .replaceAll(" ", "")
                                  .substring(0, 2)
                                  .toUpperCase()
                                  : chatCtrl.pData["name"][0]
                                  : "C",
                              style: AppCss.manropeExtraBold30.textColor(appCtrl.appTheme.primary))
                              .paddingAll(Insets.i20)
                              .decorated(color: appCtrl.appTheme.sameWhite, shape: BoxShape.circle)))
                      .decorated(color: appCtrl.appTheme.primary),
                  errorWidget: (context, url, error) => Container(
                      height: Sizes.s240,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: Insets.i8),
                      child: SizedBox(
                          child: Text(
                              chatCtrl.pData["name"] != null
                                  ? chatCtrl.pData["name"].length > 2
                                  ? chatCtrl.pData["name"].replaceAll(" ", "").substring(0, 2).toUpperCase()
                                  : chatCtrl.pData["name"][0]
                                  : "C",
                              style: AppCss.manropeExtraBold30.textColor(appCtrl.appTheme.primary))
                              .paddingAll(Insets.i25)
                              .decorated(color: appCtrl.appTheme.sameWhite, shape: BoxShape.circle)))
                      .decorated(color: appCtrl.appTheme.primary))
                  : const CircularProgressIndicator(),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(chatCtrl.pName != null ? chatCtrl.pName! : "",
                    style: AppCss.manropeBold20
                        .textColor(appCtrl.appTheme.sameWhite)),
                const VSpace(Sizes.s10),
                chatCtrl.pData != null && chatCtrl.pData["image"] != null
                    ? Text(chatCtrl.pData["phone"],
                    style: AppCss.manropeSemiBold14
                        .textColor(appCtrl.appTheme.sameWhite))
                    : Container()
              ]).paddingAll(Insets.i20)
            ]),
            GradiantButtonCommon(
                icon:  eSvgAssets.cross,
                onTap: (){
                  chatCtrl.isUserProfile =false;
                  chatCtrl.update();
                }).paddingAll(Insets.i20)
          ]),
          const VSpace(Sizes.s20),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(appFonts.status.tr,
                style: AppCss.manropeSemiBold14
                    .textColor(appCtrl.appTheme.greyText)),
            const VSpace(Sizes.s8),
            Text(chatCtrl.userData["statusDesc"],
                style:
                AppCss.manropeBold14.textColor(appCtrl.appTheme.darkText)),

          ]).paddingSymmetric(horizontal: Insets.i20)   ,
          Divider(
              height: 1,
              color: appCtrl.appTheme.borderColor,
              thickness: 1)
              .paddingSymmetric(vertical: Insets.i20),
          AudioVideoButtonLayout(

            callTap: () async {
              await chatCtrl.permissionHandelCtrl
                  .getCameraMicrophonePermissions(context)
                  .then((value) {
                if (value == true) {
                  chatCtrl.audioVideoCallTap(false);
                  // chatCtrl.audioVideoCallTap(false);
                }
              });
            },
            videoTap: () async {
              await chatCtrl.permissionHandelCtrl
                  .getCameraMicrophonePermissions(context)
                  .then((value) {
                if (value == true) {
                  chatCtrl.audioVideoCallTap(true);
                  //chatCtrl.audioVideoCallTap(true);
                }
              });
            },
          ),
          const VSpace(Sizes.s20),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [


            ChatUserImagesVideos(chatId: chatCtrl.chatId),
            const VSpace(Sizes.s20),
            BlockReportLayout(
                icon: chatCtrl.isBlock ? eSvgAssets.block : eSvgAssets.unblock,
                name:
                "${chatCtrl.isBlock ? appFonts.unblock.tr : appFonts.block.tr} ${chatCtrl.pName}",
                onTap: () => chatCtrl.blockUser()),
            BlockReportLayout(
                icon: eSvgAssets.dislike,
                name: "${appFonts.report.tr} ${chatCtrl.pName!}",
                onTap: () async {
                  await FirebaseFirestore.instance
                      .collection(collectionName.report)
                      .add({
                    "reportFrom": chatCtrl.userData["id"],
                    "reportTo": chatCtrl.pId,
                    "isSingleChat": true,
                    "timestamp": DateTime.now().millisecondsSinceEpoch
                  }).then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(appFonts.reportSend.tr),
                      backgroundColor: Colors.green,
                    ));
                  });
                }),
            const VSpace(Sizes.s35)

          ]).paddingSymmetric(horizontal: Insets.i20)
        ]),
      );
    });
  }
}
