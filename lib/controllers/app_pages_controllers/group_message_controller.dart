import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/cupertino.dart';

import '../../config.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

import '../../widgets/alert_message_common.dart';
import '../common_controllers/picker_controller.dart';

class GroupMessageController extends GetxController{
  Uint8List webImage = Uint8List(8);
  List selectedContact = [];
  dynamic selectedData;
  List newContact = [];
  List contactList = [];
  final formKey = GlobalKey<FormState>();
  File? image;
  XFile? imageFile;
  bool isGroup = true;
  dynamic user;
  int counter = 0;
  bool isLoading = false ,isAddUser = false;

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

  // Dismiss KEYBOARD
  void dismissKeyboard() {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
  }

  //image picker option
  imagePickerOption(BuildContext context,
      {isGroup = false, isSingleChat = false, isCreateGroup = false})async {
    await getImage(ImageSource.gallery).then((value) {


    });
  }


// GET IMAGE FROM GALLERY
  Future getImage(source) async {

    final ImagePicker picker = ImagePicker();
    imageFile = (await picker.pickImage(source: ImageSource.gallery))!;
    log("wallpaper1File : $imageFile");

    if (imageFile!.name.contains("png") ||
        imageFile!.name.contains("jpg") ||
        imageFile!.name.contains("jpeg")) {
      var image = await imageFile!.readAsBytes();
      webImage = image;

      Image image1 = Image.memory(webImage);
      log("image1 : $image1");
      update();
    }
  }


// UPLOAD SELECTED IMAGE TO FIREBASE
  Future uploadFile() async {
    isLoading = true;
    update();
    imageFile = pickerCtrl.imageFile;
    update();
    log("crate_group_con  $webImage");

    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
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



  onCreateBroadcast() async{
    final user = appCtrl.storage.read(session.user);
    isLoading = true;
    update();
    String broadcastId = DateTime.now().millisecondsSinceEpoch.toString();

    Encrypted encrypteded = encryptFun(
        "You created this broadcast");
    String encrypted = encrypteded.base64;


    await checkChatAvailable();
    await Future.delayed(DurationsClass.s6);
    log("newContact SS: ${newContact.length}");
    isLoading = false;
    update();
    await FirebaseFirestore.instance
        .collection(collectionName.broadcast)
        .doc(broadcastId)
        .set({
      "name": txtGroupName.text,
      "users": newContact,
      "broadcastId": broadcastId,
      "createdBy": user,
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
    });

    log("CREATE BROADCAST");

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
      "name": txtGroupName.text,
      "updateStamp": DateTime.now().millisecondsSinceEpoch.toString()
    }).then((value) {
      selectedContact = [];

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
        .then((value) async {
      var data = {
        "broadcastId": broadcastId,
        "data": value.docs[0].data(),
        "newContact": newContact,
      };

      log("newContact :$data");

      isLoading = false;
      update();
      Get.toNamed(routeName.broadcastChat, arguments: data);

    });
  }

  //select user function
  selectUserTap(RegisterContactDetail value) {
    var data = {
      "id": value.id,
      "name": value.name,
      "phone": value.phone,
      "image": value.image
    };
    bool exists = selectedContact.any((file) => file["phone"] == data["phone"]);
    log("exists : $exists");
    if (exists) {
      selectedContact.removeWhere(
            (element) => element["phone"] == data["phone"],
      );
    } else {
      if (selectedContact.length <
          appCtrl.usageControlsVal!.groupMembersLimit!) {
        selectedContact.add(data);
      } else {
        flutterAlertMessage(
            msg:
            "You can added only ${isGroup ? appCtrl.usageControlsVal!.groupMembersLimit! : appCtrl.usageControlsVal!.broadCastMembersLimit!} Members in the group");
      }
    }

    update();
  }

  //check chat available with contacts
  Future<List> checkChatAvailable() async {
    newContact = [];
    int count = 0;
    int dddd = 0;
    final user = appCtrl.storage.read(session.user);
    selectedContact.asMap().entries.forEach((e) async {
      count++;
      await FirebaseFirestore.instance
          .collection(collectionName.users)
          .doc(user["id"])
          .collection(collectionName.chats)
          .where("isOneToOne", isEqualTo: true)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          dddd++;
          value.docs.asMap().entries.forEach((element) {
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

            update();
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
    log("count : $count");
    log("dddd : $dddd");
    return newContact;
  }

    onTapGroupProfile(profileCtrl) {
    showDialog(
        context: Get.context!,
        builder: (context) {
          return  AlertDialog(
              contentPadding: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(AppRadius.r8))),
              backgroundColor: appCtrl.appTheme.white,
              titlePadding: const EdgeInsets.all(Insets.i20),
              title: Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(appFonts.addPhoto.tr,
                              style: AppCss.manropeBold16.textColor(appCtrl.appTheme.darkText)),
                          Icon(CupertinoIcons.multiply, color: appCtrl.appTheme.darkText).inkWell(onTap: ()=> Get.back())
                        ]
                    ),
                    const VSpace(Sizes.s15),
                    Divider(color: appCtrl.appTheme.darkText.withOpacity(0.1),height: 1,thickness: 1)
                  ]
              ),
              content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children:[
                    Row(
                        children: [
                          Image.asset(eImageAssets.gallery,height: Sizes.s44),
                          const HSpace(Sizes.s15),
                          Text(appFonts.selectFromGallery.tr,style: AppCss.manropeBold14.textColor(appCtrl.appTheme.darkText))
                        ]
                    ).inkWell(onTap:(){
                      pickerCtrl.getImage(ImageSource.gallery);
                      Get.back();
                    }).paddingOnly(bottom: Insets.i30),
                    Row(
                        children: [
                          Image.asset(eImageAssets.camera,height: Sizes.s44),
                          const HSpace(Sizes.s15),
                          Text(appFonts.openCamera.tr,style: AppCss.manropeBold14.textColor(appCtrl.appTheme.darkText))
                        ]
                    ).inkWell(onTap:(){
                      pickerCtrl.getImage(ImageSource.camera);
                      Get.back();
                    }).paddingOnly(bottom: Insets.i30),
                    if(profileCtrl != '')
                      Row(
                          children: [
                            Image.asset(eImageAssets.anonymous,height: Sizes.s44),
                            const HSpace(Sizes.s15),
                            Text(appFonts.removePhoto.tr,style: AppCss.manropeBold14.textColor(appCtrl.appTheme.darkText))
                          ]
                      ).inkWell(onTap:(){
                        Get.back();

                        update();
                      })
                  ]
              ).padding(horizontal: Sizes.s20,bottom: Insets.i20));
        }
    );
  }


  @override
  void onReady() {
    var data = Get.arguments ?? "";

    isGroup = data['isGroup']?? true;
    selectedContact =data['selectedContact'];

    update();
    // TODO: implement onReady
    super.onReady();
  }

}