import 'dart:developer';
import 'dart:io';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:encrypt/encrypt.dart';
import 'package:flutter/foundation.dart';

import '../../config.dart';
import '../../screens/other_screens/create_group/layouts/create_group.dart';
import '../../utils/snack_and_dialogs_utils.dart';
import '../common_controllers/picker_controller.dart';

class CreateGroupController extends GetxController {

  List selectedContact = [];
  dynamic selectedData;
  List newContact = [];
  List contactList = [];
  final formKey = GlobalKey<FormState>();
  File? image;
  XFile? imageFile;
  bool isLoading = false, isGroup = true, isAddUser = false;
  dynamic user;
  int counter = 0;
  Uint8List webImage = Uint8List(8);

  late encrypt.Encrypter cryptor;
  final iv = encrypt.IV.fromLength(8);
  String imageUrl = "";
  TextEditingController txtGroupName = TextEditingController();
  final pickerCtrl = Get.isRegistered<PickerController>()
      ? Get.find<PickerController>()
      : Get.put(PickerController());
  final permissionHandelCtrl = Get.isRegistered<PermissionHandlerController>()
      ? Get.find<PermissionHandlerController>()
      : Get.put(PermissionHandlerController());

  //refresh and get contact
  Future<void> refreshContacts() async {
    isLoading = true;
    update();
    user = appCtrl.storage.read(session.user) ?? "";

    update();
    //getFirebaseContact();
  }

  //get firebase register contact list
  getFirebaseContact() async {

    user = appCtrl.storage.read(session.user) ?? "";

    update();
    log("COUNTER: $counter");
    if (counter == 0) {
      contactList = [];
      update();
      appCtrl.contactList.asMap().entries.forEach((contact) {
        List currentUserDialCode = user['dialCodePhoneList'] ?? [];

        if (currentUserDialCode.isNotEmpty) {
          int currentIndex = currentUserDialCode
              .indexWhere((element) => element == contact.value.phone);

          if (currentIndex < 1) {
            counter++;
            update();
            FirebaseFirestore.instance
                .collection(collectionName.users)
                .get()
                .then((value) {
              value.docs.asMap().entries.forEach((element) {
                List dialCode = element.value.data()["dialCodePhoneList"] ?? [];
                if (dialCode.isNotEmpty) {
                  int index = dialCode
                      .indexWhere((elements) => elements == contact.value.phone);
                  if (index > 1) {
                    debugPrint("CCC : ${element.value.data()}");
                    if (element.value.data()["isActive"] == true) {
                      if (!contactList.contains(element.value.data())) {
                        contactList.add(element.value.data());
                      }
                      update();
                    }
                    update();
                  }
                }
              });

              update();
            });
            update();
          }
        } else {
          counter++;

          update();
          FirebaseFirestore.instance
              .collection(collectionName.users)
              .get()
              .then((value) {
            value.docs.asMap().entries.forEach((element) {
              List dialCode = element.value.data()["dialCodePhoneList"] ?? [];
              if (dialCode.isNotEmpty) {
                int index = dialCode
                    .indexWhere((element) => element == contact.value.phone);
                if (index > 1) {
                  log("CCC : $index");
                  if (element.value.data()["isActive"] == true) {
                    if (!contactList.contains(element.value.data())) {
                      contactList.add(element.value.data());
                    }
                  }
                  update();
                }
              }
            });

            update();
          });
          update();
        }
      });
    }
    isLoading = false;
    update();
  }

// UPLOAD SELECTED IMAGE TO FIREBASE
  Future uploadFile() async {
    isLoading = true;
    update();
    imageFile = pickerCtrl.imageFile;
    update();
    log("crate_group_con  $imageFile");
    var image = await imageFile!.readAsBytes();

    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    webImage = image;
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = reference.putData(webImage);
    await uploadTask.then((res) {
      res.ref.getDownloadURL().then((downloadUrl) {
        imageUrl = downloadUrl;
        isLoading = false;
        update();
      }, onError: (err) {
        update();
        Fluttertoast.showToast(msg: 'Image is Not Valid');
      });
    });
  }

// Dismiss KEYBOARD
  void dismissKeyboard() {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
  }

  //add group bottom sheet
  addGroupBottomSheet(context) async {
    final user = appCtrl.storage.read(session.user);
    log("isGroup : $selectedContact");
    if (isGroup) {
    //  Get.toNamed(routeName.groupTitleScreen,arguments: {"isGroup":isGroup,"selectedContact":selectedContact});

      showModalBottomSheet(
          isScrollControlled: true,
          context: Get.context!,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
          ),
          builder: (BuildContext context) {
            // return your layout
            return const CreateGroup();
          });
    } else {
      isLoading = true;
      update();
      final now = DateTime.now();
      String broadcastId = now.microsecondsSinceEpoch.toString();

      Encrypted encrypteded = encryptFun("You created this broadcast");
      String encrypted = encrypteded.base64;


      await checkChatAvailable();
      log("newContact : $newContact");
      await Future.delayed(DurationsClass.s3);
      await FirebaseFirestore.instance
          .collection(collectionName.broadcast)
          .doc(broadcastId)
          .set({
        "users": newContact,
        "broadcastId": broadcastId,
        "createdBy": user,
        'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      });

      FirebaseFirestore.instance.collection(collectionName.users).doc(appCtrl.user["id"])
          .collection(collectionName.broadcastMessage)
          .doc(broadcastId)
          .collection(collectionName.chat)
          .add({
        'sender': user["id"],
        'senderName': user["name"],
        'receiver': newContact,
        'content': encrypted,
        "broadcastId": broadcastId,
        'type': MessageType.messageType.name,
        'messageType': "sender",
        "status": "",
        'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      });

      await FirebaseFirestore.instance
          .collection(collectionName.users)
          .doc(user["id"])
          .collection(collectionName.chats)
          .add({
        'receiver': null,
        'broadcastId': broadcastId,
        'receiverId': newContact,
        'senderId': user["id"],
        'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
        "lastMessage": encrypted,
        "isBroadcast": true,
        "isGroup": false,
        "isBlock": false,
        "name": "Broadcast",
        "updateStamp": DateTime.now().millisecondsSinceEpoch.toString()
      }).then((value) {
        selectedContact = [];
        newContact = [];
        update();
      });

      isLoading = false;
      update();
      Get.back();
      FirebaseFirestore.instance
          .collection(collectionName.users)
          .doc(user["id"])
          .collection(collectionName.chats)
          .where("broadcastId", isEqualTo: broadcastId)
          .get()
          .then((value) {
        var data = {"broadcastId": broadcastId, "data": value.docs[0].data()};
        var indexCtrl = Get.isRegistered<IndexController>()
            ? Get.find<IndexController>()
            : Get.put(IndexController());

        indexCtrl.chatId = broadcastId;
        indexCtrl.chatType = 2;
        indexCtrl.update();
        final chatCtrl = Get.isRegistered<BroadcastChatController>()
            ? Get.find<BroadcastChatController>()
            : Get.put(BroadcastChatController());

        chatCtrl.data = data;
        indexCtrl.update();
        chatCtrl.update();

        chatCtrl.onReady();
      });
    }
  }

  //check chat available with contacts
  Future<List> checkChatAvailable() async {
    final user = appCtrl.storage.read(session.user);
    selectedContact.asMap().entries.forEach((e) async {
      log("e.value : ${e.value["chatId"]}");
      await FirebaseFirestore.instance
          .collection(collectionName.users)
          .doc(user["id"])
          .collection(collectionName.chats)
          .where("isOneToOne", isEqualTo: true)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          value.docs.asMap().entries.forEach((element) {
            log("element.value : ${element.value.data()}");
            log("exist : ${element.value.data()["senderId"] == user["id"] && element.value.data()["receiverId"] == e.value["id"] || element.value.data()["senderId"] == e.value["id"] && element.value.data()["receiverId"] == user["id"]}");
            if (element.value.data()["senderId"] == user["id"] &&
                    element.value.data()["receiverId"] == e.value["id"] ||
                element.value.data()["senderId"] == e.value["id"] &&
                    element.value.data()["receiverId"] == user["id"]) {
              e.value["chatId"] = element.value.data()["chatId"];
              update();
              if (!newContact.contains(e.value)) {
                newContact.add(e.value);
              }
            } else {
              e.value["chatId"] = null;
              if (!newContact.contains(e.value)) {
                newContact.add(e.value);
              }
            }
          });
        } else {
          e.value["chatId"] = null;
          if (!newContact.contains(e.value)) {
            newContact.add(e.value);
          }
        }
        update();
      });
    });

    return newContact;
  }

  //select user function
  selectUserTap(RegisterContactDetail value) {
    log("value : $value");
    if (isAddUser) {
      Get.back();
      var indexCtrl = Get.isRegistered<IndexController>()
          ? Get.find<IndexController>()
          : Get.put(IndexController());
      UserContactModel userContact = UserContactModel(
          username: value.name,
          uid: value.id,
          phoneNumber: value.phone,
          image: value.image,
          isRegister: true);
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
    } else {
      var data = {
        "id": value.id,
        "name": value.name,
        "phone": value.phone,
        "image": value.image
      };
      bool exists =
          selectedContact.any((file) => file["phone"] == data["phone"]);
      log("exists : $exists");
      if (exists) {
        selectedContact.removeWhere(
          (element) => element["phone"] == data["phone"],
        );
      } else {
        if (selectedContact.length < 10) {
          selectedContact.add(data);
        } else {
          snackBarMessengers(
              message:
                  "You can added only ${isGroup ? appCtrl.usageControlsVal!.groupMembersLimit! : appCtrl.usageControlsVal!.broadCastMembersLimit!} Members in the group");
        }
      }

      update();
    }
  }



  @override
  void onReady() {
// TODO: implement onReady
    super.onReady();
  }
}
