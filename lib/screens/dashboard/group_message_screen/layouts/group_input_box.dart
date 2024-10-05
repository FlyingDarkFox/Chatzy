import 'dart:developer';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:giphy_get/giphy_get.dart';
import '../../../../config.dart';

class GroupInputBox extends StatelessWidget {
  const GroupInputBox({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GroupChatMessageController>(builder: (chatCtrl) {
      return Row(children: [
        Expanded(
            child: Container(
                width: double.infinity,
                alignment: Alignment.centerLeft,
                height: Sizes.s55,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: const Color(0xff2c2c14).withOpacity(0.08),
                          blurRadius: 4,
                          spreadRadius: 1)
                    ],
                    border: Border.all(
                        color: const Color.fromRGBO(49, 100, 189, 0.1),
                        width: 1),
                    color: appCtrl.appTheme.white),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SvgPicture.asset(eSvgAssets.emojis, height: Sizes.s22)
                          .inkWell(onTap: () {
                        chatCtrl.pickerCtrl.dismissKeyboard();
                        chatCtrl.isShowSticker = !chatCtrl.isShowSticker;
                        log("SHOW ${chatCtrl.isShowSticker}");
                        chatCtrl.update();
                      }).paddingSymmetric(horizontal: Insets.i10),
                      Flexible(
                          child: TextFormField(
                            minLines: 1,
                            maxLines: 5,
                            style: TextStyle(
                                color: appCtrl.appTheme.darkText, fontSize: 15.0),
                            controller: chatCtrl.textEditingController,
                            decoration: InputDecoration.collapsed(
                                hintText: appFonts.writeHere.tr,
                                hintStyle:
                                TextStyle(color: appCtrl.appTheme.greyText)),
                            enableInteractiveSelection: false,
                            keyboardType: TextInputType.text,
                            onTap: () {
                              chatCtrl.isShowSticker = false;
                              chatCtrl.update();
                            },
                            onChanged: (val) {
                              chatCtrl.isShowSticker = false;
                              if (chatCtrl.textEditingController.text.isNotEmpty) {
                                if (val.contains(".gif")) {
                                  chatCtrl.onSendMessage(val, MessageType.gif);
                                  chatCtrl.textEditingController.clear();
                                }
                              }
                            },
                          ).inkWell(onTap: () => chatCtrl.isShowSticker = false)),
                      if (chatCtrl.textEditingController.text.isEmpty)
                        Row(children: [
                          SizedBox(
                            height: Sizes.s50,
                            width: Sizes.s50,
                            child: SpeedDial(
                                childMargin: EdgeInsets.zero,
                                elevation: 0,
                                spacing: 10,
                                backgroundColor: appCtrl.appTheme.white,
                                children: [
                                  SpeedDialChild(
                                      child:  Image.asset(eImageAssets.doc),
                                      labelWidget: Text(appFonts.document.tr)
                                          .paddingSymmetric(vertical: 5, horizontal: 10)
                                          .decorated(
                                          color: appCtrl.appTheme.white,
                                          boxShadow:const [BoxShadow(
                                              color: Color.fromRGBO(49, 100, 189, 0.08),blurRadius: 12, spreadRadius: 2
                                          )],
                                          borderRadius: BorderRadius.circular(6)).marginSymmetric(horizontal: 10),
                                      backgroundColor: appCtrl.appTheme.primary,
                                      onTap: () => chatCtrl.documentShare()),
                                  SpeedDialChild(
                                    child:
                                    const Icon(Icons.camera, color: Colors.white),

                                    backgroundColor: appCtrl.appTheme.primary,
                                    labelWidget: Text(appFonts.camera.tr)
                                        .paddingSymmetric(vertical: 5, horizontal: 10)
                                        .decorated(
                                        color: appCtrl.appTheme.white,

                                        borderRadius: BorderRadius.circular(6)).marginSymmetric(horizontal: 10),
                                    onTap: () {
                                      chatCtrl.getImageFromCamera(context);
                                    },
                                  ),
                                  SpeedDialChild(
                                    child: const Icon(Icons.email, color: Colors.white),

                                    labelWidget: Text('Images & Videos'.tr)
                                        .paddingSymmetric(vertical: 5, horizontal: 10)
                                        .decorated(
                                        color: appCtrl.appTheme.white,

                                        borderRadius: BorderRadius.circular(6)).marginSymmetric(horizontal: 10),
                                    backgroundColor: appCtrl.appTheme.primary,
                                    onTap: () {
                                      chatCtrl.pickerCtrl.imagePickerOption(
                                          Get.context!,
                                          isSingleChat: true);
                                    },
                                  ),
                                ],
                                child: SvgPicture.asset(eSvgAssets.clip)),
                          ),
                          const HSpace(Sizes.s10),
                          InkWell(
                              child: SvgPicture.asset(eSvgAssets.gif),
                              onTap: () async {
                                if (chatCtrl.isShowSticker = true) {
                                  chatCtrl.isShowSticker = false;
                                  chatCtrl.update();
                                }
                                GiphyGif? gif = await GiphyGet.getGif(
                                    tabColor: appCtrl.appTheme.primary,
                                    context: context,
                                    apiKey: appCtrl.userAppSettingsVal!.gifAPI!,
                                    lang: GiphyLanguage.english);
                                if (gif != null) {
                                  chatCtrl.onSendMessage(
                                      gif.images!.original!.url,
                                      MessageType.gif);
                                }
                              })
                        ]),
                      GestureDetector(
                        onTap: () {
                          if(chatCtrl.textEditingController.text.isNotEmpty) {
                            chatCtrl.onSendMessage(
                                chatCtrl.textEditingController.text,
                                chatCtrl.textEditingController.text.contains("https://") ||
                                    chatCtrl.textEditingController.text.contains("http://")
                                    ? MessageType.link
                                    : MessageType.text);
                          }
                        },
                        onLongPress: (){
                          if(chatCtrl.textEditingController.text.isEmpty) {
                            chatCtrl.checkPermission("audio", 0);
                          }
                        },
                        child: Container(
                            height: Sizes.s50,
                            padding: const EdgeInsets.symmetric(
                              vertical: Insets.i10,
                            ),
                            decoration: ShapeDecoration(
                                gradient: RadialGradient(colors: [
                                  appCtrl.isTheme
                                      ? appCtrl.appTheme.primary
                                      .withOpacity(.8)
                                      : appCtrl.appTheme.primary,
                                  appCtrl.appTheme.primary
                                ]),
                                shape: SmoothRectangleBorder(
                                    borderRadius: SmoothBorderRadius(
                                        cornerRadius: 12,
                                        cornerSmoothing: 1))),
                            child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 8.0),
                                child: SvgPicture.asset(
                                    chatCtrl.textEditingController.text.isNotEmpty
                                        ? eSvgAssets.send
                                        : eSvgAssets.microphone,
                                    colorFilter: ColorFilter.mode(
                                        appCtrl.appTheme.sameWhite,
                                        BlendMode.srcIn))))
                            .paddingSymmetric(vertical: Insets.i5)
                            .paddingSymmetric(horizontal: Insets.i10),
                      )
                    ])))
      ]);
    });
  }
}
