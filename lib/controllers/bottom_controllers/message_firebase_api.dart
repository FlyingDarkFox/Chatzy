import 'dart:developer';

import '../../../config.dart';
import '../app_pages_controllers/chat_controller.dart';
import 'message_controller.dart';

class MessageFirebaseApi {
  String? currentUserId;
  final messageCtrl = Get.isRegistered<MessageController>()
      ? Get.find<MessageController>()
      : Get.put(MessageController());


  //check contact in firebase and if not exists
  saveContact(UserContactModel userModel) async {
    bool isRegister = false;

    await FirebaseFirestore.instance
        .collection(collectionName.users)
        .where("phone", isEqualTo: userModel.phoneNumber)
        .limit(1)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        isRegister = true;
        userModel.uid = value.docs[0].id;
      } else {
        isRegister = false;
      }
    });

    final data = appCtrl.storage.read(session.user);
    currentUserId = data["id"];

    UserContactModel userContact = userModel;
    if (isRegister) {
      log("val: ${userContact.uid}");
      await FirebaseFirestore.instance
          .collection(collectionName.users)
          .doc(currentUserId)
          .collection("chats")
          .where("isOneToOne", isEqualTo: true)
          .get()
          .then((value) {
        var indexCtrl = Get.isRegistered<IndexController>()
            ? Get.find<IndexController>()
            : Get.put(IndexController());
        bool isEmpty = value.docs
            .where((element) =>
                element.data()["senderId"] == userContact.uid ||
                element.data()["receiverId"] == userContact.uid)
            .isNotEmpty;
        if (!isEmpty) {
          var data = {"chatId": "0", "data": userContact, "message": null};
          indexCtrl.chatId = "0";
          indexCtrl.chatType = 0;
          indexCtrl.update();
          final chatCtrl = Get.isRegistered<ChatController>()
              ? Get.find<ChatController>()
              : Get.put(ChatController());

          chatCtrl.data = data;

          chatCtrl.update();
          chatCtrl.onReady();

          //  Get.toNamed(routeName.chat, arguments: data);
        } else {
          value.docs.asMap().entries.forEach((element) {
            if (element.value.data()["senderId"] == userContact.uid ||
                element.value.data()["receiverId"] == userContact.uid) {
              var data = {
                "chatId": element.value.data()["chatId"],
                "data": userContact,
                "message": null
              };
              indexCtrl.chatId = element.value.data()["chatId"];
              indexCtrl.chatType = 0;
              indexCtrl.update();
              final chatCtrl = Get.isRegistered<ChatController>()
                  ? Get.find<ChatController>()
                  : Get.put(ChatController());

              chatCtrl.data = data;

              chatCtrl.update();
              chatCtrl.onReady();

              // Get.toNamed(routeName.chat,arguments: data);
            }
          });

          //
        }
      });
    } else {
      String telephoneUrl = "tel:${userModel.phoneNumber}";

      if (await canLaunchUrl(Uri.parse(telephoneUrl))) {
        await launchUrl(Uri.parse(telephoneUrl));
      } else {
        throw "Can't phone that number.";
      }
    }
  }

  //chat list

  List chatListWidget(
      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
    List message = [];
    for (int a = 0; a < snapshot.data!.docs.length; a++) {
      message.add(snapshot.data!.docs[a]);
    }
    return message;
  }
}
