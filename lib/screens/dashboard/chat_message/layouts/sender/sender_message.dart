import 'package:chatzy_web/screens/dashboard/chat_message/layouts/sender/sender_image.dart';

import '../../../../../config.dart';
import '../../../../../controllers/app_pages_controllers/chat_controller.dart';
import '../../../../../utils/type_list.dart';
import '../../../../../widgets/common_link_layout.dart';
import '../../../../../widgets/common_note_encrypt.dart';
import '../../../../../widgets/reaction_pop_up/reaction_config.dart';
import '../../../../../widgets/reaction_pop_up/reaction_pop_up.dart';
import '../../gif_layout.dart';
import '../../on_tap_function_class.dart';
import '../audio_doc.dart';
import '../contact_layout.dart';
import '../location_layout.dart';
import '../video_doc.dart';
import 'content.dart';

class SenderMessage extends StatefulWidget {
  final MessageModel? document;
  final int? index;
  final String? docId, title;

  const SenderMessage(
      {super.key, this.document, this.index, this.docId, this.title});

  @override
  State<SenderMessage> createState() => _SenderMessageState();
}

class _SenderMessageState extends State<SenderMessage> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(builder: (chatCtrl) {
      return Stack(alignment: Alignment.topLeft, children: [
        MouseRegion(
          onHover: (val) {
            chatCtrl.isHover = true;
            chatCtrl.isSelectedHover = widget.index!;
            chatCtrl.update();
          },
          onExit: (exit) {
            chatCtrl.isHover = false;
            chatCtrl.update();
          },
          onEnter: (enter) {
            chatCtrl.isHover = true;
            chatCtrl.update();
          },
          child: Container(
              color: chatCtrl.selectedIndexId.contains(widget.docId)
                  ? appCtrl.appTheme.primary.withOpacity(.08)
                  : appCtrl.appTheme.trans,
              margin: const EdgeInsets.only(bottom: 2.0),
              padding: EdgeInsets.only(
                  top: chatCtrl.selectedIndexId.contains(widget.docId)
                      ? Insets.i10
                      : 0,
                  left: Insets.i10,
                  right: Insets.i10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (chatCtrl.isHover == true &&
                          chatCtrl.isSelectedHover == widget.index)
                        Row(
                          children: [
                            PopupMenuButton(
                                color: appCtrl.appTheme.white,
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: appCtrl.appTheme.greyText
                                  ,
                                ),
                                onSelected: (result) async {

                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(AppRadius.r8),
                                ),
                                itemBuilder: (ctx) =>
                                [
                                  _buildPopupMenuItem(
                                      appFonts.deleteChat.tr,
                                      0,
                                          () =>
                                          chatCtrl.buildPopupDialog(
                                              widget.docId)),
                                  _buildPopupMenuItem(appFonts.star.tr, 1,
                                          () async {
                                        int index = chatCtrl.localMessage
                                            .indexWhere((element) {
                                          return element.time!.contains("-")
                                              ? element.time!
                                              .split("-")[0] ==
                                              widget.title
                                              : element.time ==
                                              widget.title;
                                        });

                                        int messageIndex = chatCtrl
                                            .localMessage[index].message!
                                            .indexWhere((element) =>
                                        element.docId == widget.docId);

                                        if (chatCtrl
                                            .localMessage[index]
                                            .message![messageIndex]
                                            .isFavourite != null) {
                                          chatCtrl
                                              .localMessage[index]
                                              .message![messageIndex]
                                              .isFavourite = null;
                                          chatCtrl
                                              .localMessage[index]
                                              .message![messageIndex]
                                              .favouriteId = null;
                                        } else {
                                          chatCtrl
                                              .localMessage[index]
                                              .message![messageIndex]
                                              .isFavourite = true;
                                          chatCtrl
                                              .localMessage[index]
                                              .message![messageIndex]
                                              .favouriteId = appCtrl.user["id"];
                                        }
                                        chatCtrl.update();
                                        await FirebaseFirestore.instance
                                            .collection(collectionName.users)
                                            .doc(appCtrl.user["id"])
                                            .collection(collectionName.messages)
                                            .doc(chatCtrl.chatId)
                                            .collection(collectionName.chat)
                                            .doc(widget.docId)
                                            .update({
                                          "isFavourite": true,
                                          "favouriteId": appCtrl.user["id"]
                                        });
                                        await FirebaseFirestore.instance
                                            .collection(collectionName.users)
                                            .doc(chatCtrl.pId)
                                            .collection(collectionName.messages)
                                            .doc(chatCtrl.chatId)
                                            .collection(collectionName.chat)
                                            .doc(widget.docId)
                                            .update({
                                          "isFavourite": true,
                                          "favouriteId": appCtrl.user["id"]
                                        });
                                      }),
                                ]),

                            Icon(Icons.emoji_emotions,
                              color: appCtrl.appTheme.white, size: Sizes.s15,)
                                .paddingAll(Insets.i2).decorated(
                                shape: BoxShape.circle,
                                color: appCtrl.appTheme.greyText.withOpacity(
                                    .5)).paddingSymmetric(
                                horizontal: Insets.i10)
                                .inkWell(onTap: () {
                              chatCtrl.showPopUp = true;
                              chatCtrl.enableReactionPopup = true;

                              if (!chatCtrl.selectedIndexId.contains(
                                  widget.docId)) {
                                if (chatCtrl.showPopUp == false) {
                                  chatCtrl.selectedIndexId.add(widget.docId);
                                } else {
                                  chatCtrl.selectedIndexId = [];
                                  chatCtrl.selectedIndexId.add(widget.docId);
                                }
                                chatCtrl.update();
                              }
                              chatCtrl.update();
                            }),
                          ],
                        ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            if (widget.document!.type == MessageType.text.name)
                            // Text
                              Content(
                                  onTap: () =>
                                      OnTapFunctionCall()
                                          .contentTap(chatCtrl, widget.docId),
                                  onLongPress: () =>
                                      chatCtrl
                                          .onLongPressFunction(widget.docId),
                                  document: widget.document)
                                  .paddingOnly(bottom: Insets.i5),
                            if (widget.document!.type == MessageType.image.name)
                              SenderImage(
                                  onPressed: () =>
                                      OnTapFunctionCall().imageTap(
                                          chatCtrl, widget.docId,
                                          widget.document),
                                  document: widget.document,
                                  onLongPress: () =>
                                      chatCtrl
                                          .onLongPressFunction(widget.docId)),
                            if (widget.document!.type ==
                                MessageType.contact.name)
                              ContactLayout(
                                  onTap: () =>
                                      OnTapFunctionCall()
                                          .contentTap(chatCtrl, widget.docId),
                                  onLongPress: () =>
                                      chatCtrl.onLongPressFunction(
                                          widget.docId),
                                  document: widget.document)
                                  .paddingSymmetric(vertical: Insets.i8),
                            if (widget.document!.type ==
                                MessageType.location.name)
                              LocationLayout(

                                  document: widget.document,
                                  onLongPress: () =>
                                      chatCtrl.onLongPressFunction(
                                          widget.docId),
                                  onTap: () =>
                                      OnTapFunctionCall().locationTap(
                                          chatCtrl, widget.docId,
                                          widget.document)),
                            if (widget.document!.type == MessageType.video.name)
                              VideoDoc(
                                  document: widget.document,
                                  onLongPress: () =>
                                      chatCtrl.onLongPressFunction(
                                          widget.docId),
                                  onTap: () =>
                                      OnTapFunctionCall().locationTap(
                                          chatCtrl, widget.docId,
                                          widget.document)),
                            if (widget.document!.type == MessageType.audio.name)
                              AudioDoc(
                                  document: widget.document,
                                  onLongPress: () =>
                                      chatCtrl.onLongPressFunction(
                                          widget.docId),
                                  onTap: () =>
                                      OnTapFunctionCall()
                                          .contentTap(chatCtrl, widget.docId)),
                            if (widget.document!.type == MessageType.doc.name)
                              (decryptMessage(widget.document!.content)
                                  .contains(
                                  ".pdf"))
                                  ? PdfLayout(
                                  onTap: () =>
                                      OnTapFunctionCall().pdfTap(
                                          chatCtrl, widget.docId,
                                          widget.document),
                                  document: widget.document,
                                  onLongPress: () =>
                                      chatCtrl.onLongPressFunction(
                                          widget.docId))
                                  : (decryptMessage(widget.document!.content)
                                  .contains(".doc"))
                                  ? DocxLayout(
                                  document: widget.document,
                                  onTap: () =>
                                      OnTapFunctionCall().docTap(
                                          chatCtrl,
                                          widget.docId,
                                          widget.document),
                                  onLongPress: () =>
                                      chatCtrl
                                          .onLongPressFunction(widget.docId))
                                  : (decryptMessage(widget.document!.content)
                                  .contains(".xlsx") ||
                                  decryptMessage(widget.document!.content)
                                      .contains(".xls"))
                                  ? ExcelLayout(
                                  onTap: () =>
                                      OnTapFunctionCall()
                                          .excelTap(chatCtrl, widget.docId,
                                          widget.document),
                                  onLongPress: () =>
                                      chatCtrl
                                          .onLongPressFunction(widget.docId),
                                  document: widget.document
                              )
                                  : (decryptMessage(widget.document!.content)
                                  .contains(".jpg") ||
                                  decryptMessage(widget.document!.content)
                                      .contains(".png") ||
                                  decryptMessage(widget.document!.content)
                                      .contains(".heic") ||
                                  decryptMessage(widget.document!.content)
                                      .contains(".jpeg"))
                                  ? DocImageLayout(
                                  document: widget.document,
                                  onTap: () =>
                                      OnTapFunctionCall()
                                          .docImageTap(
                                          chatCtrl, widget.docId,
                                          widget.document),
                                  onLongPress: () =>
                                      chatCtrl.onLongPressFunction(
                                          widget.docId))
                                  : Container(),
                            if(widget.document!.type == MessageType.link.name)

                              CommonLinkLayout(
                                  document: widget.document,
                                  onTap: () => OnTapFunctionCall().onTapLink(
                                      chatCtrl, widget.docId, widget.document),
                                  onLongPress: () =>
                                      chatCtrl
                                          .onLongPressFunction(widget.docId)),
                            if (widget.document!.type == MessageType.gif.name)

                              GifLayout(
                                onTap: () =>
                                    OnTapFunctionCall()
                                        .contentTap(chatCtrl, widget.docId),
                                onLongPress: () =>
                                    chatCtrl.onLongPressFunction(widget.docId),
                                document: widget.document,
                              )
                          ]),
                    ],
                  ),
                  if (widget.document!.type == MessageType.messageType.name)
                    Align(
                      alignment: Alignment.center,
                      child: Text(decryptMessage(widget.document!.content))
                          .paddingSymmetric(
                          horizontal: Insets.i8, vertical: Insets.i10)
                          .decorated(
                          color: appCtrl.appTheme.borderColor,
                          borderRadius: BorderRadius.circular(AppRadius.r8))
                          .alignment(Alignment.center),
                    ).paddingOnly(bottom: Insets.i8),
                  if (widget.document!.type == MessageType.note.name)
                    const Align(
                      alignment: Alignment.center,
                      child: CommonNoteEncrypt(),
                    ).paddingOnly(bottom: Insets.i8)
                ],
              )),
        ),
        if (chatCtrl.enableReactionPopup &&
            chatCtrl.selectedIndexId.contains(widget.docId))
          SizedBox(
              height: Sizes.s48,
              child: ReactionPopup(
                reactionPopupConfig: ReactionPopupConfiguration(
                    shadow:
                    BoxShadow(color: Colors.grey.shade400, blurRadius: 20)),
                onEmojiTap: (val) =>
                    OnTapFunctionCall()
                        .onEmojiSelect(
                        chatCtrl, widget.docId, val, widget.title),
                showPopUp: chatCtrl.showPopUp,
              ))
      ]);
    });
  }
}

PopupMenuItem _buildPopupMenuItem(String title, int position,
    GestureTapCallback? onTap) {
  return PopupMenuItem(
    onTap: onTap,
    value: position,
    child: Row(
      children: [
        Text(
          title,
          style:
          AppCss.manropeMedium14.textColor(appCtrl.appTheme.darkText),
        )
      ],
    ),
  );
}