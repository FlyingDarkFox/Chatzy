import '../../../../../config.dart';
import '../../gif_layout.dart';


class ReceiverMessage extends StatefulWidget {
  final MessageModel? document;
  final int? index;
  final String? docId, title;
  final bool isGroup;

  const ReceiverMessage({super.key,
    this.index,
    this.document,
    this.docId,
    this.isGroup = false,
    this.title});

  @override
  State<ReceiverMessage> createState() => _ReceiverMessageState();
}

class _ReceiverMessageState extends State<ReceiverMessage> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(builder: (chatCtrl) {
      return Stack(alignment: Alignment.topCenter, children: [
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
              margin: const EdgeInsets.only(bottom: Insets.i10),
              padding: EdgeInsets.only(
                  left: Insets.i20,
                  right: Insets.i20,
                  top: chatCtrl.selectedIndexId.contains(widget.docId)
                      ? Insets.i10
                      : 0),
              child:
              Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                ReceiverChatImage(id: chatCtrl.pId),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: <Widget>[
                              // MESSAGE BOX FOR TEXT
                              if (widget.document!.type ==
                                  MessageType.text.name)
                                ReceiverContent(
                                    onLongPress: () =>
                                        chatCtrl
                                            .onLongPressFunction(widget.docId),
                                    document: widget.document,
                                    onTap: () =>
                                        OnTapFunctionCall()
                                            .contentTap(
                                            chatCtrl, widget.docId)),

                              // MESSAGE BOX FOR IMAGE
                              if (widget.document!.type ==
                                  MessageType.image.name)
                                ReceiverImage(
                                    onTap: () =>
                                        OnTapFunctionCall().imageTap(
                                            chatCtrl,
                                            widget.docId,
                                            widget.document),
                                    document: widget.document,
                                    onLongPress: () =>
                                        chatCtrl
                                            .onLongPressFunction(widget.docId)),

                              if (widget.document!.type ==
                                  MessageType.contact.name)
                                ContactLayout(
                                    isReceiver: true,
                                    onTap: () =>
                                        OnTapFunctionCall()
                                            .contentTap(chatCtrl, widget.docId),
                                    onLongPress: () =>
                                        chatCtrl
                                            .onLongPressFunction(widget.docId),
                                    document: widget.document),
                              if (widget.document!.type ==
                                  MessageType.location.name)
                                LocationLayout(
                                    isReceiver: true,
                                    document: widget.document,
                                    onLongPress: () =>
                                        chatCtrl
                                            .onLongPressFunction(widget.docId),
                                    onTap: () =>
                                        OnTapFunctionCall()
                                            .locationTap(chatCtrl, widget.docId,
                                            widget.document)),

                              if (widget.document!.type ==
                                  MessageType.video.name)
                                VideoDoc(
                                    document: widget.document,
                                    onLongPress: () =>
                                        chatCtrl
                                            .onLongPressFunction(widget.docId),
                                    isReceiver: true,
                                    onTap: () =>
                                        OnTapFunctionCall()
                                            .locationTap(chatCtrl, widget.docId,
                                            widget.document)),
                              if (widget.document!.type ==
                                  MessageType.audio.name)
                                AudioDoc(
                                    isReceiver: true,
                                    document: widget.document,
                                    onTap: () =>
                                        OnTapFunctionCall()
                                            .contentTap(chatCtrl, widget.docId),
                                    onLongPress: () =>
                                        chatCtrl.onLongPressFunction(
                                            widget.docId)),
                              if (widget.document!.type == MessageType.doc.name)
                                (decryptMessage(widget.document!.content)
                                    .contains(
                                    ".pdf"))
                                    ? PdfLayout(
                                    isReceiver: true,
                                    document: widget.document,
                                    onTap: () =>
                                        OnTapFunctionCall().pdfTap(
                                            chatCtrl, widget.docId,
                                            widget.document),
                                    onLongPress: () =>
                                        chatCtrl.onLongPressFunction(
                                            widget.docId))
                                    : (decryptMessage(widget.document!.content)
                                    .contains(".doc"))
                                    ? DocxLayout(
                                    isReceiver: true,
                                    document: widget.document,
                                    onTap: () =>
                                        OnTapFunctionCall().docTap(
                                            chatCtrl, widget.docId,
                                            widget.document),
                                    onLongPress: () =>
                                        chatCtrl
                                            .onLongPressFunction(widget.docId))
                                    : (decryptMessage(widget.document!.content)
                                    .contains(".xlsx"))
                                    ? ExcelLayout(
                                  isReceiver: true,
                                  onTap: () =>
                                      OnTapFunctionCall().excelTap(
                                          chatCtrl,
                                          widget.docId,
                                          widget.document),
                                  onLongPress: () =>
                                      chatCtrl
                                          .onLongPressFunction(widget.docId),
                                  document: widget.document,
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
                                    isReceiver: true,
                                    onTap: () =>
                                        OnTapFunctionCall()
                                            .docImageTap(
                                            chatCtrl,
                                            widget.docId,
                                            widget.document),
                                    document: widget.document,
                                    onLongPress: () =>
                                        chatCtrl
                                            .onLongPressFunction(widget.docId))
                                    : Container(),
                              if(widget.document!.type == MessageType.link.name)

                                CommonLinkLayout(
                                    isReceiver: true,
                                    document: widget.document,
                                    onTap: () =>
                                        OnTapFunctionCall().onTapLink(
                                            chatCtrl, widget.docId,
                                            widget.document),
                                    onLongPress: () =>
                                        chatCtrl
                                            .onLongPressFunction(widget.docId)),
                              if (widget.document!.type == MessageType.gif.name)
                                GifLayout(
                                    onTap: () =>
                                        OnTapFunctionCall()
                                            .contentTap(chatCtrl, widget.docId),
                                    document: widget.document,
                                    onLongPress: () =>
                                        chatCtrl.onLongPressFunction(
                                            widget.docId))
                            ],
                          ),
                          if (chatCtrl.isHover == true &&
                              chatCtrl.isSelectedHover == widget.index)
                            Row(
                              children: [
                                PopupMenuButton(
                                    color: appCtrl.appTheme.white,
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: appCtrl.appTheme.greyText,
                                    ),
                                    onSelected: (result) async {},
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
                                      _buildPopupMenuItem(
                                          appFonts.star.tr, 1, () async {
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
                                        element.docId ==
                                            widget.docId);

                                        if (chatCtrl
                                            .localMessage[index]
                                            .message![messageIndex]
                                            .isFavourite !=
                                            null) {
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
                                              .favouriteId =
                                          appCtrl.user["id"];
                                        }
                                        chatCtrl.update();
                                        await FirebaseFirestore.instance
                                            .collection(
                                            collectionName.users)
                                            .doc(appCtrl.user["id"])
                                            .collection(
                                            collectionName.messages)
                                            .doc(chatCtrl.chatId)
                                            .collection(collectionName.chat)
                                            .doc(widget.docId)
                                            .update({
                                          "isFavourite": true,
                                          "favouriteId": appCtrl.user["id"]
                                        });
                                        await FirebaseFirestore.instance
                                            .collection(
                                            collectionName.users)
                                            .doc(chatCtrl.pId)
                                            .collection(
                                            collectionName.messages)
                                            .doc(chatCtrl.chatId)
                                            .collection(collectionName.chat)
                                            .doc(widget.docId)
                                            .update({
                                          "isFavourite": true,
                                          "favouriteId": appCtrl.user["id"]
                                        });
                                      }),
                                    ]),
                                Icon(
                                  Icons.emoji_emotions,
                                  color: appCtrl.appTheme.white,
                                  size: Sizes.s15,
                                )
                                    .paddingAll(Insets.i2)
                                    .decorated(
                                    shape: BoxShape.circle,
                                    color: appCtrl.appTheme.greyText
                                        .withOpacity(.5))
                                    .paddingSymmetric(horizontal: Insets.i10)
                                    .inkWell(onTap: () {
                                  chatCtrl.showPopUp = true;
                                  chatCtrl.enableReactionPopup = true;

                                  if (!chatCtrl.selectedIndexId
                                      .contains(widget.docId)) {
                                    if (chatCtrl.showPopUp == false) {
                                      chatCtrl.selectedIndexId
                                          .add(widget.docId);
                                    } else {
                                      chatCtrl.selectedIndexId = [];
                                      chatCtrl.selectedIndexId
                                          .add(widget.docId);
                                    }
                                    chatCtrl.update();
                                  }
                                  chatCtrl.update();
                                }),
                              ],
                            ),
                        ],
                      ),
                      if (widget.document!.type == MessageType.messageType.name)
                        Align(
                            alignment: Alignment.center,
                            child: Text(decryptMessage(
                                widget.document!.content))
                                .paddingSymmetric(
                                horizontal: Insets.i8,
                                vertical: Insets.i10)
                                .decorated(
                                color: appCtrl.appTheme.primary
                                    .withOpacity(.2),
                                borderRadius:
                                BorderRadius.circular(AppRadius.r8))
                                .alignment(Alignment.center))
                            .paddingOnly(bottom: Insets.i8)
                    ])
              ])),
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
          style: AppCss.manropeMedium14.textColor(appCtrl.appTheme.darkText),
        )
      ],
    ),
  );
}
