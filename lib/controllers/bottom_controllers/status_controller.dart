import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:chatzy_web/controllers/bottom_controllers/status_firebase_api.dart';
import 'package:dartx/dartx_io.dart';

import '../../config.dart';
import '../../models/status_model.dart';
import '../../screens/auth_screens/layouts/status_view.dart';
import '../../screens/dashboard/chat_message/layouts/text_status.dart';
import '../../utils/alert_utils.dart';
import '../../utils/snack_and_dialogs_utils.dart';
import '../../utils/type_list.dart';
import '../common_controllers/picker_controller.dart';
import 'package:universal_html/html.dart' as html;


class StatusController extends GetxController {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  List<Status> status = [];
  String? groupId, currentUserId, imageUrl;
  Image? contactPhoto;
  dynamic user;
  XFile? imageFile;
  File? image;
  bool isLoading = false;
  List selectedContact = [];
  Stream<QuerySnapshot>? stream;
  List<Status> statusListData = [];
  List<Status> statusData = [];
  DateTime date = DateTime.now();
  Uint8List webImage = Uint8List(8);
  final pickerCtrl = Get.isRegistered<PickerController>()
      ? Get.find<PickerController>()
      : Get.put(PickerController());

  final permissionHandelCtrl = Get.isRegistered<PermissionHandlerController>()
      ? Get.find<PermissionHandlerController>()
      : Get.put(PermissionHandlerController());

  @override
  void onReady() async {
    // TODO: implement onReady
    final data = appCtrl.storage.read(session.user) ?? "";
    if (data != "") {
      currentUserId = data["id"];
      user = data;
    }
    update();

    debugPrint("contactList : ${appCtrl.userContactList}");
    update();

    super.onReady();
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
      var image =  result.files[0].bytes;
      isLoading = true;
      update();
      await addStatus(image, result.files.single.name.toString().contains(".mp4") ? StatusType.video: StatusType.image);

    }
  }


// Dismiss KEYBOARD
  void dismissKeyboard() {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
  }

  //add status
  addStatus(file, StatusType statusType) async {
    isLoading = true;
    update();
    imageUrl = await pickerCtrl.uploadImage(file);
    if(imageUrl != "") {
      update();
      debugPrint("imageUrl : $imageUrl");
      await StatusFirebaseApi().addStatus(imageUrl, statusType.name);
    }else{
      showToast("Error while Uploading Image");
    }
    isLoading = false;
    update();
  }

  //status list

  List statusListWidget(
      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
    List statusList = [];
    for (int a = 0; a < snapshot.data!.docs.length; a++) {
      statusList.add(snapshot.data!.docs[a].data());
    }
    return statusList;
  }

  openImagePreview(status) {
    showDialog(
        context: Get.context!,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                contentPadding: EdgeInsets.zero,
                shape:const  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(AppRadius.r12))),
                backgroundColor: appCtrl.appTheme.black.withOpacity(0.6),

                content: SizedBox(
                    child: SingleChildScrollView(
                        child: Column(children: [
                          StatusScreenView(statusData: status).height(940).width(665),

                        ]))).paddingAll(Insets.i30));
          });
        });
  }

  onTapStatus() {
    alertDialog(
        title: appFonts.addStory,
        list: appArray.addStatusList,
        isLoading: isLoading,
        onTap: (int index) async {

          if (index == 0) {

            dismissKeyboard();

            await documentShare();
          } else {
            Get.back();
            Get.to(() => const TextStatus());
          //  Get.to(() => const TextStatus());
          }
          update();
        });
  }

}
