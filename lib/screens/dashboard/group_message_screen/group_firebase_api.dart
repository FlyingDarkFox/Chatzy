import 'dart:developer';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:encrypt/encrypt.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../../config.dart';
import '../../../controllers/app_pages_controllers/create_group_controller.dart';
import '../../../controllers/app_pages_controllers/group_message_controller.dart';

class GroupFirebaseApi {
  late encrypt.Encrypter cryptor;
  final iv = encrypt.IV.fromLength(8);

  //create group
  createGroup(CreateGroupController groupCtrl,context) async {
    Map<String, dynamic>? arg;
    groupCtrl.dismissKeyboard();
    groupCtrl.isLoading = true;
    groupCtrl.update();
    final user = appCtrl.storage.read(session.user);
    groupCtrl.update();
    var userData = {
      "id": user["id"],
      "name": user["name"],
      "phone": user["phone"],
      "image": user["image"]
    };
    groupCtrl.selectedContact.add(userData);
    groupCtrl.imageFile = groupCtrl.pickerCtrl.imageFile;
    log("groupCtrl.imageFile :${groupCtrl.imageFile}");
    if (groupCtrl.imageFile != null) {
      await groupCtrl.uploadFile();
    }
    groupCtrl.update();
    final now = DateTime.now();
    String id = now.microsecondsSinceEpoch.toString();
    log("time :$id");

    await Future.delayed(DurationsClass.s3);

    await FirebaseFirestore.instance
        .collection(collectionName.groups)
        .doc(id)
        .set({
      "name": groupCtrl.txtGroupName.text,
      "image": groupCtrl.imageUrl,
      "users": groupCtrl.selectedContact,
      "groupId": id,
      "status": "",
      "createdBy": user,
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
    });

    Encrypted encrypteded = encryptFun(
        "${user["id"] == appCtrl.user["id"] ? "You" : user["name"]} created this group");
    String encrypted = encrypteded.base64;

    Encrypted newEncrypteded = encryptFun(
        "${user["name"]} created this group");
    String encrypted1 = newEncrypteded.base64;
 String time =DateTime.now().millisecondsSinceEpoch.toString();
log("timeSTAMP :$time");
log("timeSTAMP :${groupCtrl.selectedContact}");
    groupCtrl.selectedContact.asMap().entries.forEach((e) async {
      log("ISSS :${e.value["id"]}");
      
      FirebaseFirestore.instance
          .collection("users")
          .doc(e.value["id"])
          .collection("groupMessage")
          .doc(id)
          .collection("chat")
          .doc(time)
          .set({
        'sender': user["id"],
        'senderName': user["name"],
        'receiver': groupCtrl.selectedContact,
        'content':  appCtrl.user["id"] == e.value["id"] ?  encrypted:newEncrypteded,
        "groupId": id,
        'type': MessageType.messageType.name,
        'messageType': "sender",
        'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      });
    });
    await FirebaseFirestore.instance
        .collection("groups")
        .doc(id)
        .get()
        .then((value) async {
      groupCtrl.selectedContact.map((e) {
        FirebaseFirestore.instance
            .collection("users")
            .doc(e["id"])
            .collection("chats")
            .add({
          "isSeen": false,
          'receiverId': groupCtrl.selectedContact,
          "senderId": user["id"],
          'chatId': "",
          'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
          "lastMessage": appCtrl.user["id"] == e["id"] ?  encrypted:newEncrypteded,
          "messageType": MessageType.messageType.name,
          "isGroup": true,
          "isBlock": false,
          "isBroadcast": false,
          "isBroadcastSender": false,
          "isOneToOne": false,
          "blockBy": "",
          "blockUserId": "",
          "name": groupCtrl.txtGroupName.text,
          "groupId": id,
          "updateStamp": DateTime.now().millisecondsSinceEpoch.toString()
        });
      }).toList();
      groupCtrl.selectedContact = [];
      groupCtrl.txtGroupName.text = "";
      groupCtrl.isLoading = false;
      groupCtrl.imageUrl = "";
      groupCtrl.image = null;
      groupCtrl.imageFile = null;
      groupCtrl.update();
      arg = value.data();
    });
    log("back");
    dynamic messageData;
    log("back : $arg");
    Get.back();
    Get.back();
    groupCtrl.imageUrl = "";
    groupCtrl.imageFile = null;
    groupCtrl.image = null;
    FirebaseFirestore.instance
        .collection("users")
        .doc(userData["id"])
        .collection("chats")
        .where("groupId", isEqualTo: id)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        messageData = value.docs[0].data();
      }
    }).then((value) {
      groupCtrl.isLoading = false;
      groupCtrl.update();
      var data = {"message": messageData, "groupData": arg};
      var indexCtrl = Get.isRegistered<IndexController>()
          ? Get.find<IndexController>()
          : Get.put(IndexController());
      log("data :$data");
      final chatCtrl =
      Get.isRegistered<GroupChatMessageController>()
          ? Get.find<GroupChatMessageController>()
          : Get.put(GroupChatMessageController());
      if (Responsive.isMobile(context)) {
        Get.toNamed(routeName.groupChat, arguments: data);
      } else {
        indexCtrl.chatId = id;
        indexCtrl.chatType = 1;
        indexCtrl.update();
      }
      chatCtrl.data = data;
      indexCtrl.update();

      chatCtrl.update();
      chatCtrl.pId = id;

      chatCtrl.onReady();
    });
  }
}
