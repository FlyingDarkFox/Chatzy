import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:camera/camera.dart';

import 'package:dartx/dartx_io.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:universal_html/html.dart' as html;

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:http/http.dart' as http;

import '../../config.dart';
import '../../screens/dashboard/chat_message/layouts/file_bottom_sheet.dart';
import '../../screens/dashboard/chat_message/layouts/receiver/receiver_message.dart';
import '../../screens/dashboard/chat_message/layouts/sender/sender_message.dart';
import '../../screens/dashboard/chat_message/layouts/single_clear_dialog.dart';
import '../../screens/dashboard/index/layouts/audio_recording_plugin.dart';
import '../../screens/dashboard/index/layouts/delete_alert.dart';
import '../../utils/type_list.dart';
import '../../widgets/reaction_pop_up/emoji_picker_widget.dart';
import '../common_controllers/picker_controller.dart';
import 'chat_message_api.dart';

class ChatController extends GetxController {
  String? pId,
      id,
      chatId,
      pName,
      groupId,
      imageUrl,
      peerNo,
      status,
      statusLastSeen,
      videoUrl,
      blockBy;
  List message = [];
  int isSelectedHover = 0;
  dynamic pData, allData, userData;
  CameraController? cameraController;
  Uint8List webImage = Uint8List(8);
  Future<void>? initializeControllerFuture;
  List<File> selectedImages = [];
  UserContactModel? userContactModel;
  bool positionStreamStarted = false;
  bool isUserAvailable = true,
      isCamera = false,
      isHover = false,
      isUserProfile = false;
  XFile? imageFile;
  XFile? videoFile;
  dynamic selectedWallpaper;

  String? audioFile, wallPaperType;
  String selectedImage = "";
  final picker = ImagePicker();
  File? selectedFile;
  File? image;
  File? video;
  int? count;
  StreamSubscription? messageSub;
  List<QueryDocumentSnapshot<Map<String, dynamic>>> allMessages = [];
  bool isLoading = false;
  bool enableReactionPopup = false, isChatSearch = false;
  bool showPopUp = false;
  bool isShowSticker = false;
  bool isFilter = false;
  List selectedIndexId = [];
  List clearChatId = [], searchChatId = [];

  bool typing = false, isBlock = false;
  final pickerCtrl = Get.isRegistered<PickerController>()
      ? Get.find<PickerController>()
      : Get.put(PickerController());
  final permissionHandelCtrl = Get.isRegistered<PermissionHandlerController>()
      ? Get.find<PermissionHandlerController>()
      : Get.put(PermissionHandlerController());
  TextEditingController textEditingController = TextEditingController();
  TextEditingController txtChatSearch = TextEditingController();
  ScrollController listScrollController = ScrollController();
  FocusNode focusNode = FocusNode();
  late encrypt.Encrypter cryptor;
  dynamic data;
  final iv = encrypt.IV.fromLength(8);
  List<DateTimeChip> localMessage = [];

  @override
  void onReady() {
    // TODO: implement onReady

    groupId = '';
    isLoading = false;
    imageUrl = '';
    userData = appCtrl.storage.read(session.user);

    log("data : $data");
    log("userData : $userData");
    if(data != null) {
      if (data == "No User") {
        isUserAvailable = false;
      } else {
        userContactModel = data["data"];
        pId = userContactModel!.uid;
        pName = userContactModel!.username;
        chatId = data["chatId"];
        isUserAvailable = true;
        update();
      }
    }
    update();
    getChatData();

    super.onReady();
  }

  //get chat data
  getChatData() async {
    if (chatId != "0") {
      await FirebaseFirestore.instance
          .collection(collectionName.users)
          .doc(appCtrl.user["id"])
          .collection(collectionName.chats)
          .where("chatId", isEqualTo: chatId)
          .get()
          .then((value) {
        if(value.docs.isNotEmpty) {
          allData = value.docs[0].data();
          clearChatId = allData["clearChatId"] ?? [];
          update();
        }
      });
    } else {
      onSendMessage(appFonts.noteEncrypt.tr, MessageType.note);
    }

    seenMessage();
    messageSub = FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(appCtrl.user["id"])
        .collection(collectionName.messages)
        .doc(chatId)
        .collection(collectionName.chat)
        .snapshots()
        .listen((event) async {
      allMessages = event.docs;
      update();

      ChatMessageApi().getLocalMessage();

      isLoading = false;
      update();
    });
    await FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(pId)
        .get()
        .then((value) {
      pData = value.data();

      update();
      log("get L : $pData");
    });
    log("allData : $allData");

    if (allData != null) {
      if (allData["backgroundImage"] != null ||
          allData["backgroundImage"] != "") {
        FirebaseFirestore.instance
            .collection(collectionName.users)
            .doc(userData["id"])
            .get()
            .then((value) {
          if (value.exists) {
            allData["backgroundImage"] = value.data()!["backgroundImage"];
          }
        });
        update();
      }
    } else {
      allData = {};
      allData["backgroundImage"] = "";
      allData["isBlock"] = false;
    }
    log("CHECK BACK : ${allData["backgroundImage"]}");
    update();

    if (data["message"] != null) {
      //PhotoUrl photoUrl = PhotoUrl.fromJson(data["message"]);
      log("ARH : ${data["message"]}");
      onSendMessage(
          data["message"].statusType == StatusType.text.name
              ? data["message"].statusText!
              : data["message"].image!,
          data["message"].statusType == StatusType.image.name
              ? MessageType.image
              : data["message"].statusType == StatusType.text.name
                  ? MessageType.text
                  : MessageType.video);
    }
  }

  showBottomSheet() => EmojiPickerWidget(
      onSelected: (emoji) {
        textEditingController.text + emoji;
      });

  //update typing status
  setTyping() async {
    textEditingController.addListener(() {
      if (textEditingController.text.isNotEmpty) {
        firebaseCtrl.setTyping();
        typing = true;
      }
      if (textEditingController.text.isEmpty && typing == true) {
        firebaseCtrl.setIsActive();
        typing = false;
      }
    });
  }

  //seen all message
  seenMessage() async {
    if (allData != null) {
      await FirebaseFirestore.instance
          .collection(collectionName.users)
          .doc(appCtrl.user["id"])
          .collection(collectionName.messages)
          .doc(chatId)
          .collection(collectionName.chat)
          .where("receiver", isEqualTo: appCtrl.user["id"])
          .get()
          .then((value) {
        log("RECEIVER : ${value.docs.length}");
        value.docs.asMap().entries.forEach((element) async {
          await FirebaseFirestore.instance
              .collection(collectionName.users)
              .doc(appCtrl.user["id"])
              .collection(collectionName.messages)
              .doc(chatId)
              .collection(collectionName.chat)
              .doc(element.value.id)
              .update({"isSeen": true});
        });
      });
      await FirebaseFirestore.instance
          .collection(collectionName.users)
          .doc(userData["id"])
          .collection(collectionName.chats)
          .where("chatId", isEqualTo: chatId)
          .get()
          .then((value) async {
        if (value.docs.isNotEmpty) {
          await FirebaseFirestore.instance
              .collection(collectionName.users)
              .doc(userData["id"])
              .collection(collectionName.chats)
              .doc(value.docs[0].id)
              .update({"isSeen": true});
        }
      });

      await FirebaseFirestore.instance
          .collection(collectionName.users)
          .doc(pId)
          .collection(collectionName.messages)
          .doc(chatId)
          .collection(collectionName.chat)
          .where("receiver", isEqualTo: appCtrl.user["id"])
          .get()
          .then((value) {
        log("RECEIVER : ${value.docs.length}");
        value.docs.asMap().entries.forEach((element) async {
          await FirebaseFirestore.instance
              .collection(collectionName.users)
              .doc(pId)
              .collection(collectionName.messages)
              .doc(chatId)
              .collection(collectionName.chat)
              .doc(element.value.id)
              .update({"isSeen": true});
        });
      });
      await FirebaseFirestore.instance
          .collection(collectionName.users)
          .doc(pId)
          .collection(collectionName.chats)
          .where("chatId", isEqualTo: chatId)
          .get()
          .then((value) async {
        if (value.docs.isNotEmpty) {
          await FirebaseFirestore.instance
              .collection(collectionName.users)
              .doc(pId)
              .collection(collectionName.chats)
              .doc(value.docs[0].id)
              .update({"isSeen": true});
        }
      });
    }
  }

  //share document
  documentShare() async {
    pickerCtrl.dismissKeyboard();
    Get.back();

    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      isLoading = true;
      update();
      Get.forceAppUpdate();
      File file = File(result.files.single.path.toString());
      String fileName =
          "${file.name}-${DateTime.now().millisecondsSinceEpoch.toString()}";
      log("file : $file");
      Reference reference = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = reference.putFile(file);
      TaskSnapshot snap = await uploadTask;
      String downloadUrl = await snap.ref.getDownloadURL();
      isLoading = true;
      update();
      log("fileName : $downloadUrl");
      onSendMessage(
          "${result.files.single.name}-BREAK-$downloadUrl",
          result.files.single.path.toString().contains(".mp4")
              ? MessageType.video
              : result.files.single.path.toString().contains(".mp3")
                  ? MessageType.audio
                  : MessageType.doc);
    }
  }

  getImageFromCamera(context) async {
    final perm =
        await html.window.navigator.permissions!.query({"name": "camera"});
    await availableCameras().onError((error, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.toString()),
        backgroundColor: appCtrl.appTheme.redColor,
      ));
      return [];
    }).then((value) {
      if (value.isNotEmpty) {
        log("value  $value");
        if (perm.state == "denied") {
          return [];
        } else {
          isCamera = true;
          cameras = value;
          update();
          cameraController = CameraController(
            // Get a specific camera from the list of available cameras.
            cameras[0],
            // Define the resolution to use.
            ResolutionPreset.medium,
          );

          // Next, initialize the controller. This returns a Future.
          initializeControllerFuture = cameraController!.initialize();
          update();
          return value;
        }
      }
    });
    log("cameras : $cameras");
  }

//block user
  blockUser() async {
    DateTime now = DateTime.now();
    String? newChatId =
        chatId == "0" ? now.microsecondsSinceEpoch.toString() : chatId;
    chatId = newChatId;
    update();

    if (allData["isBlock"] == true) {
      Encrypted encrypteded = encryptFun("You unblock this contact");
      String encrypted = encrypteded.base64;

      ChatMessageApi().saveMessage(
          newChatId,
          pId,
          encrypted,
          MessageType.messageType,
          DateTime.now().millisecondsSinceEpoch.toString(),
          userData["id"]);

      await ChatMessageApi().saveMessageInUserCollection(
        userData["id"],
        pId,
        newChatId,
        encrypted,
        userData["id"],
        userData["name"],
        MessageType.messageType,
        isBlock: false,
      );
    } else {
      Encrypted encrypteded = encryptFun("You block this contact");
      String encrypted = encrypteded.base64;

      ChatMessageApi().saveMessage(
          newChatId,
          pId,
          encrypted,
          MessageType.messageType,
          DateTime.now().millisecondsSinceEpoch.toString(),
          userData["id"]);

      await ChatMessageApi().saveMessageInUserCollection(
        userData["id"],
        pData["id"],
        newChatId,
        encrypted,
        userData["id"],
        userData["name"],
        MessageType.messageType,
        isBlock: true,
      );
    }
    getChatData();
  }

// UPLOAD SELECTED IMAGE TO FIREBASE
  Future uploadFile() async {
    imageFile = pickerCtrl.imageFile;
    update();
    isLoading = true;
    update();
    if (imageFile!.name.contains(".mp4")) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
        content: const Text("Only png accept"),
        backgroundColor: appCtrl.appTheme.redColor,
      ));
    } else {
      var image = await imageFile!.readAsBytes();

      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      webImage = image;
      Reference reference = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = reference.putData(webImage);
      uploadTask.then((res) {
        res.ref.getDownloadURL().then((downloadUrl) {
          log("chat_con : ${imageFile!.name}");
          String type = imageFile!.name;
          log("chat_con : ${imageFile!}");
          imageUrl = downloadUrl;
          imageFile = null;
          isLoading = false;
          log("imageUrl : $imageUrl");
          onSendMessage(imageUrl!,
              type.contains(".mp4") ? MessageType.video : MessageType.image);
          update();
        }, onError: (err) {
          isLoading = false;
          update();
          Fluttertoast.showToast(msg: 'Image is Not Valid');
        });
      });
    }
  }

// UPLOAD SELECTED IMAGE TO FIREBASE
  Future uploadMultipleFile(File imageFile, MessageType messageType) async {
    imageFile = imageFile;
    update();

    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    var file = File(imageFile.path);
    UploadTask uploadTask = reference.putFile(file);
    uploadTask.then((res) {
      res.ref.getDownloadURL().then((downloadUrl) async {
        imageUrl = downloadUrl;
        isLoading = false;
        onSendMessage(imageUrl!, messageType);
        update();
      }, onError: (err) {
        isLoading = false;
        update();
        Fluttertoast.showToast(msg: 'Image is Not Valid');
      });
    });
  }

  uploadCameraImage() async {
    var image = await imageFile!.readAsBytes();

    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    webImage = image;
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = reference.putData(webImage);

    uploadTask.then((res) {
      res.ref.getDownloadURL().then((downloadUrl) async {
        imageUrl = downloadUrl;
        isLoading = false;
        onSendMessage(imageUrl!, MessageType.image);
        update();
      }, onError: (err) {
        isLoading = false;
        update();
        Fluttertoast.showToast(msg: 'Image is Not Valid');
      });
    });
    cameraController!.dispose();
  }

  //send video after recording or pick from media
  videoSend() async {
    update();
    videoFile = pickerCtrl.videoFile;
    update();
    log("videoFile : $videoFile");
    const Duration(seconds: 2);
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    var file = File(videoFile!.path);

    UploadTask uploadTask = reference.putFile(file);

    uploadTask.then((res) {
      res.ref.getDownloadURL().then((downloadUrl) {
        videoUrl = downloadUrl;
        isLoading = false;
        onSendMessage(videoUrl!, MessageType.video);
        update();
      }, onError: (err) {
        isLoading = false;
        update();
        Fluttertoast.showToast(msg: 'Image is Not Valid');
      });
    }).then((value) {
      videoFile = null;
      pickerCtrl.videoFile = null;

      pickerCtrl.video = null;
      videoUrl = "";
      update();
      pickerCtrl.update();
    });
  }

  //pick up contact and share
  saveContactInChat(value) async {
    if (value != null) {
      FirebaseContactModel contact = value;
      log("ccc : $contact");
      String? photo;
      isLoading = true;
      await FirebaseFirestore.instance
          .collection(collectionName.users)
          .where("phone", isEqualTo: contact.phone)
          .get()
          .then((user) {
        if (user.docs.isNotEmpty) {
          photo = user.docs[0].data()["image"] ?? "";
        }
      });
      update();
      onSendMessage('${contact.name}-BREAK-${contact.phone}-BREAK-$photo',
          MessageType.contact);
    }
    update();
  }

  //audio and video call tap
  audioVideoCallTap(isVideoCall) async {
    await ChatMessageApi()
        .audioAndVideoCallApi(toData: pData, isVideoCall: isVideoCall);
  }

  //audio recording
  void audioRecording(String type, int index) {
    showModalBottomSheet(
      context: Get.context!,
      isDismissible: false,
      backgroundColor: appCtrl.appTheme.trans,
      builder: (BuildContext bc) {
        return Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: appCtrl.appTheme.white,
                borderRadius: BorderRadius.circular(10)),
            child: AudioRecordingPlugin(type: type, index: index));
      },
    ).then((value) async {
      Uri blobUri = Uri.parse(value);
      http.Response response = await http.get(blobUri);
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference reference = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = reference.putData(
          response.bodyBytes, SettableMetadata(contentType: 'video/mp4'));
      showDialog<
          void>(
          context:
          Get.context!,
          barrierDismissible:
          false,
          builder:
              (BuildContext context) {
            return  SimpleDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
                // side: BorderSide(width: 5, color: Colors.green)),
                backgroundColor: Colors.white,
                children: <Widget>[
                  Center(
                    child: StreamBuilder(
                        stream: uploadTask.snapshotEvents,
                        builder: (BuildContext context, snapshot) {
                          if (snapshot.hasData) {
                            final TaskSnapshot snap = uploadTask.snapshot;

                            return openUploadDialog(
                              context: context,
                              percent: bytesTransferred(snap) / 100,
                              title: "Sending",
                              subtitle: "${((((snap.bytesTransferred / 1024) / 1000) * 100).roundToDouble()) / 100}/${((((snap.totalBytes / 1024) / 1000) * 100).roundToDouble()) / 100} MB",
                            );
                          } else {
                            return openUploadDialog(
                              context: context,
                              percent: 0.0,
                              title: "Sending",
                              subtitle: '',
                            );
                          }
                        }),
                  ),
                ]);
          });

      TaskSnapshot snap = await uploadTask;
      String downloadUrl = await snap.ref.getDownloadURL();
      log("audioFile : $downloadUrl");
      log("audioFile : ${bytesTransferred(snap) / 100 ==1}");
if(bytesTransferred(snap) / 100 ==1){
  Get.back();
}
      onSendMessage(downloadUrl, MessageType.audio);
      log("audioFile : $downloadUrl");
    });
  }

  // SEND MESSAGE CLICK

  // SEND MESSAGE CLICK
  void onSendMessage(String content, MessageType type) async {
    // isLoading = true;
    update();
    Get.forceAppUpdate();
    Encrypted encrypteded = encryptFun(content);
    String encrypted = encrypteded.base64;
log("localMessage : ${localMessage.length}");
    if (content != "" || content != null) {
      textEditingController.clear();
      final now = DateTime.now();
      String? newChatId =
          chatId == "0" ? now.microsecondsSinceEpoch.toString() : chatId;
      chatId = newChatId;
      update();
      imageUrl = "";
      String time = DateTime.now().millisecondsSinceEpoch.toString();
      update();
      log("allData:: $allData");
      MessageModel messageModel = MessageModel(
          blockBy: allData != null ? allData["blockBy"] : "",
          blockUserId: allData != null ? allData["blockUserId"] : "",
          chatId: chatId,
          content: encrypted,
          docId: time,
          isBlock: false,
          isBroadcast: false,
          isFavourite: false,
          isSeen: false,
          messageType: "sender",
          receiver: pId,
          sender: appCtrl.user["id"],
          timestamp: time,
          type: type.name);
      bool isEmpty =
          localMessage.where((element) => element.time == "Today").isEmpty;
      if (isEmpty) {
        List<MessageModel>? message = [];
        if (message.isNotEmpty) {
          message.add(messageModel);
          message[0].docId = time;
        } else {
          message = [messageModel];
          message[0].docId = time;
        }
        DateTimeChip dateTimeChip =
            DateTimeChip(time: getDate(time), message: message);
        localMessage.add(dateTimeChip);
        update();
      } else {
        int index =
            localMessage.indexWhere((element) => element.time == "Today");

        if (!localMessage[index].message!.contains(messageModel)) {
          localMessage[index].message!.add(messageModel);
        }

      }
      update();
      Get.forceAppUpdate();
      log("localMessage q: ${localMessage.length}");

      if (allData != null && allData != "") {
        if (allData["isBlock"] == true) {
          if (allData["blockUserId"] == pId) {
            ScaffoldMessenger.of(Get.context!).showSnackBar(
                SnackBar(content: Text(appFonts.unblockUser(pName))));
          } else {
            await ChatMessageApi()
                .saveMessage(
                    newChatId, pId, encrypted, type, time, userData["id"])
                .then((snap) async {
              isLoading = false;
              update();
              Get.forceAppUpdate();
              await ChatMessageApi().saveMessageInUserCollection(
                  pData["id"],
                  userData["id"],
                  newChatId,
                  encrypted,
                  userData["id"],
                  pName,
                  type);
            }).then((value) {
              isLoading = false;
              update();
              Get.forceAppUpdate();
            });
          }
          isLoading = false;
          update();
          Get.forceAppUpdate();
        } else {
          await ChatMessageApi()
              .saveMessage(
                  newChatId,
                  pId,
                  encrypted,
                  type,
                  DateTime.now().millisecondsSinceEpoch.toString(),
                  userData["id"])
              .then((value) async {
            await ChatMessageApi()
                .saveMessage(newChatId, pId, encrypted, type,
                    DateTime.now().millisecondsSinceEpoch.toString(), pId)
                .then((snap) async {
              isLoading = false;
              update();
              Get.forceAppUpdate();

              await ChatMessageApi().saveMessageInUserCollection(userData["id"],
                  pId, newChatId, encrypted, userData["id"], pName, type);
              await ChatMessageApi().saveMessageInUserCollection(pId, pId,
                  newChatId, encrypted, userData["id"], userData["name"], type);
            }).then((value) {
              isLoading = false;
              update();
              Get.forceAppUpdate();
            });
          });
        }
        isLoading = false;
        update();
        Get.forceAppUpdate();
      } else {
        isLoading = false;
        update();
        Get.forceAppUpdate();

        await ChatMessageApi()
            .saveMessage(
                newChatId,
                pId,
                encrypted,
                type,
                DateTime.now().millisecondsSinceEpoch.toString(),
                userData["id"])
            .then((value) async {
          await ChatMessageApi()
              .saveMessage(newChatId, pId, encrypted, type,
                  DateTime.now().millisecondsSinceEpoch.toString(), pId)
              .then((snap) async {
            isLoading = false;
            update();
            Get.forceAppUpdate();

            await ChatMessageApi().saveMessageInUserCollection(userData["id"],
                pId, newChatId, encrypted, userData["id"], pName, type);
            await ChatMessageApi().saveMessageInUserCollection(pId, pId,
                newChatId, encrypted, userData["id"], userData["name"], type);
          }).then((value) {
            isLoading = false;
            update();
            Get.forceAppUpdate();
            getChatData();
          });
        });
      }
    }

    if (chatId != "0") {
      await FirebaseFirestore.instance
          .collection(collectionName.users)
          .doc(userData["id"])
          .collection(collectionName.chats)
          .where("chatId", isEqualTo: chatId)
          .get()
          .then((value) {
        allData = value.docs[0].data();

        update();
      });
    }
    log("chatId :: R$chatId");
    await FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(appCtrl.user["id"])
        .collection(collectionName.messages)
        .doc(chatId)
        .collection(collectionName.chat)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        allMessages = value.docs;
        update();
        ChatMessageApi().getLocalMessage();
        update();
      }
    });
    log("allMessages : $allMessages");
    seenMessage();
    await FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(pId)
        .get()
        .then((value) {
      pData = value.data();

      update();
    });
    if (pData["pushToken"] != "") {
      firebaseCtrl.sendNotification(
          title: "Single Message",
          msg: messageTypeCondition(type, content),
          chatId: chatId,
          token: pData["pushToken"],
          pId: pId,
          pName: appCtrl.user["name"],
          userContactModel: userContactModel,
          image: userData["image"],
          dataTitle: appCtrl.user["name"]);
    }
    isLoading = false;
    if (allData == null) {
      getChatData();
    }
    update();
    Get.forceAppUpdate();
  }

  //delete chat layout
  buildPopupDialog(docId) async {
    await showDialog(
        context: Get.context!,
        builder: (_) => DeleteAlert(
              docId: docId,
            ));
  }

  wallPaperConfirmation(image) async {
    Get.generalDialog(
      pageBuilder: (context, anim1, anim2) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return GetBuilder<ChatController>(builder: (chatCtrl) {
              return Align(
                  alignment: Alignment.center,
                  child: Container(
                      height: 250,
                      color: appCtrl.appTheme.white,
                      margin: const EdgeInsets.symmetric(
                          horizontal: Insets.i10, vertical: Insets.i15),
                      padding: const EdgeInsets.symmetric(
                          horizontal: Insets.i10, vertical: Insets.i15),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appFonts.setWallpaper.tr,
                            style: AppCss.manropeblack14
                                .textColor(appCtrl.appTheme.darkText),
                          ),
                          ListTile(
                            title: Text('${appFonts.setForChat.tr} "$pName"'),
                            leading: Radio(
                              value: "Person Name",
                              groupValue: wallPaperType,
                              onChanged: (String? value) {
                                wallPaperType = value;
                                update();
                              },
                            ),
                          ),
                          ListTile(
                            title:  Text(appFonts.forAllChat.tr),
                            leading: Radio(
                              value: "For All",
                              groupValue: wallPaperType,
                              onChanged: (String? value) {
                                wallPaperType = value;
                                update();
                              },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                  child: ButtonCommon(
                                title: appFonts.cancel.tr,
                                onTap: () => Get.back(),
                                style: AppCss.manropeMedium14
                                    .textColor(appCtrl.appTheme.white),
                              )),
                              const HSpace(Sizes.s10),
                              Expanded(
                                  child: ButtonCommon(
                                      onTap: () async {
                                        Get.back();
                                        log("wallPaperType : $image");
                                        if (wallPaperType == "Person Name") {
                                          await FirebaseFirestore.instance
                                              .collection(collectionName.users)
                                              .doc(userData["id"])
                                              .collection(collectionName.chats)
                                              .where("chatId",
                                                  isEqualTo: chatId)
                                              .limit(1)
                                              .get()
                                              .then((userChat) {
                                            if (userChat.docs.isNotEmpty) {
                                              FirebaseFirestore.instance
                                                  .collection(
                                                      collectionName.users)
                                                  .doc(userData["id"])
                                                  .collection(
                                                      collectionName.chats)
                                                  .doc(userChat.docs[0].id)
                                                  .update({
                                                'backgroundImage': image
                                              });
                                            }
                                          });
                                        } else {
                                          FirebaseFirestore.instance
                                              .collection(collectionName.users)
                                              .doc(userData["id"])
                                              .update(
                                                  {'backgroundImage': image});
                                        }
                                        chatCtrl.allData["backgroundImage"] =
                                            image;
                                        chatCtrl.update();
                                      },
                                      title: appFonts.ok.tr,
                                      style: AppCss.manropeMedium14
                                          .textColor(appCtrl.appTheme.white))),
                            ],
                          )
                        ],
                      )));
            });
          }),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
            position: Tween(begin: const Offset(0, -1), end: const Offset(0, 0))
                .animate(anim1),
            child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  Widget timeLayout(DateTimeChip document) {

    List<MessageModel> newMessageList = document.message!.reversed.toList();

    return Column(
      children: [
        Text(
            document.time!.contains("-other")
                ? document.time!.split("-other")[0]
                : document.time!,
            style:
            AppCss.manropeMedium14.textColor(appCtrl.appTheme.darkText))
            .marginSymmetric(vertical: Insets.i5),
        ...newMessageList.asMap().entries.map((e) {
          return buildItem(
              e.key,
              e.value,
              e.value.docId,
              document.time!.contains("-other")
                  ? document.time!.split("-other")[0]
                  : document.time!);
        }).toList()
      ],
    );
  }

  // BUILD ITEM MESSAGE BOX FOR RECEIVER AND SENDER BOX DESIGN
  Widget buildItem(int index, MessageModel document, documentId, title) {
    if (document.sender == userData["id"]) {
      return SenderMessage(
          document: document,
          index: index,
          docId: document.docId,
          title: title)
          .inkWell(onTap: () {
        enableReactionPopup = false;
        showPopUp = false;
        selectedIndexId = [];
        update();
      });
    } else if (document.sender != userData["id"]) {
      // RECEIVER MESSAGE
      return document.type! == MessageType.messageType.name
          ? Container()
          : document.isBlock!
          ? Container()
          : ReceiverMessage(
        document: document,
        index: index,
        docId: document.docId,
        title: title,
      ).inkWell(onTap: () {
        enableReactionPopup = false;
        showPopUp = false;
        selectedIndexId = [];
        update();
        log("enable : $enableReactionPopup");
      });
    } else {
      return Container();
    }
  }

  // ON BACK PRESS
  Future<bool> onBackPress() {
    FirebaseFirestore.instance
        .collection(collectionName.messages)
        .doc(chatId)
        .collection(collectionName.chat)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        if (value.docs.length == 1) {
          FirebaseFirestore.instance
              .collection(collectionName.messages)
              .doc(chatId)
              .collection(collectionName.chat)
              .doc(value.docs[0].id)
              .delete();
        }
      }
    });
    return Future.value(false);
  }

  //ON LONG PRESS
  onLongPressFunction(docId) {
    showPopUp = true;
    enableReactionPopup = true;

    if (!selectedIndexId.contains(docId)) {
      if (showPopUp == false) {
        selectedIndexId.add(docId);
      } else {
        selectedIndexId = [];
        selectedIndexId.add(docId);
      }
      update();
    }
    update();
  }

  Widget searchTextField() {
    return TextField(
      controller: txtChatSearch,
      onChanged: (val) async {
        count = null;
        searchChatId = [];
        selectedIndexId = [];
        message.asMap().entries.forEach((e) {
          if (decryptMessage(e.value.data()["content"])
              .toLowerCase()
              .contains(val)) {
            if (!searchChatId.contains(e.key)) {
              searchChatId.add(e.key);
            } else {
              searchChatId.remove(e.key);
            }
          }
          update();
        });
      },
      autofocus: true,
      //Display the keyboard when TextField is displayed
      cursorColor: appCtrl.appTheme.darkText,
      style: AppCss.manropeMedium14.textColor(appCtrl.appTheme.darkText),
      textInputAction: TextInputAction.search,
      //Specify the action button on the keyboard
      decoration: InputDecoration(
        //Style of TextField
        enabledBorder: UnderlineInputBorder(
            //Default TextField border
            borderSide: BorderSide(color: appCtrl.appTheme.darkText)),
        focusedBorder: UnderlineInputBorder(
            //Borders when a TextField is in focus
            borderSide: BorderSide(color: appCtrl.appTheme.darkText)),
        hintText: 'Search', //Text that is displayed when nothing is entered.
      ),
    );
  }


  //share media
  shareMedia(BuildContext context) {
    showModalBottomSheet(
        barrierColor: appCtrl.appTheme.trans,
        backgroundColor: appCtrl.appTheme.trans,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppRadius.r25))),
        builder: (BuildContext context) {
          // return your layout

          return const FileBottomSheet();
        });
  }


  //location share
  locationShare() async {
    isLoading = true;
    update();
    pickerCtrl.dismissKeyboard();
    Get.back();

    await permissionHandelCtrl.getCurrentPosition().then((value) async {
      isLoading = true;
      update();
      log("value : $value");
      var locationString =
          'https://www.google.com/maps/search/?api=1&query=${value!.latitude},${value.longitude}';
      isLoading = false;
      update();
      onSendMessage(locationString, MessageType.location);
      return null;
    });
  }


//clear dialog
  clearChatConfirmation() async {
    Get.generalDialog(
      pageBuilder: (context, anim1, anim2) {
        return const SingleClearDialog();
      },
    );
  }


  Future<void> checkPermission( String type, int index) async {
      final permission =
      await html.window.navigator.permissions?.query({'name': 'microphone'});
      log("permission : ${permission!.state}");
      if (permission.state == 'prompt' || permission.state == "denied") {
        WidgetsFlutterBinding.ensureInitialized();
        dynamic value =
        await html.window.navigator.getUserMedia(audio: true, video: true);
        log("AUDIO : $value");
      }else{

        audioRecording(type, index);
      }

  }


}
