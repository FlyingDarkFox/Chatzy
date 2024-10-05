
import 'dart:developer';

import '../../config.dart';
import '../../screens/other_screens/create_group/create_group.dart';
import '../app_pages_controllers/create_group_controller.dart';

class IndexController extends GetxController {
  ValueNotifier<bool> isOpen = ValueNotifier(true);
  ValueNotifier<bool> drawerIndex = ValueNotifier(true);
  ValueNotifier<bool> settingIndex = ValueNotifier(true);
  ValueNotifier<bool> statusIndex = ValueNotifier(true);

  int selectedIndex = 0;
  List message =[];
  List searchMessage =[];
  String? chatId;
  String pageName = "dashboard";
  dynamic user;
  List statusList = [];
  int isSelectedHover = 0,chatType = 0;
  bool isTextShow = false,isSingleChat = false;

  TextEditingController userText = TextEditingController();

  final ScrollController scrollController = ScrollController();

  var dashCtrl = Get.isRegistered<DashboardController>()
      ? Get.find<DashboardController>()
      : Get.put(DashboardController());
/*  var statusCtrl = Get.isRegistered<StatusController>()
      ? Get.find<StatusController>()
      : Get.put(StatusController());*/
  var createGroupCtrl = Get.isRegistered<CreateGroupController>()
      ? Get.find<CreateGroupController>()
      : Get.put(CreateGroupController());


  @override
  void onReady() {
    // TODO: implement onReady
    dashCtrl.update();
    user = appCtrl.storage.read(session.user);
    update();

    appCtrl.isRTL = appCtrl.storage.read(session.isRTL)?? false;
    appCtrl.update();
    firebaseCtrl.statusDeleteAfter24Hours();
    firebaseCtrl.deleteForAllUsers();
    getAdminPermission();
    super.onReady();
  }

  textShow() async {
    await Future.delayed(DurationsClass.s2);
    isTextShow = true;
    update();
  }

  getAdminPermission() async {
    final usageControls = await FirebaseFirestore.instance
        .collection(collectionName.config)
        .doc(collectionName.usageControls)
        .get();

    appCtrl.usageControlsVal = UsageControlModel.fromJson(usageControls.data()!);


    appCtrl.storage.write(session.usageControls, usageControls.data());
    update();
    final userAppSettings = await FirebaseFirestore.instance
        .collection(collectionName.config)
        .doc(collectionName.userAppSettings)
        .get();

    appCtrl.userAppSettingsVal = UserAppSettingModel.fromJson(userAppSettings.data()!);
    final agoraToken = await FirebaseFirestore.instance
        .collection(collectionName.config)
        .doc(collectionName.agoraToken)
        .get();
    await   appCtrl.storage.write(session.agoraToken, agoraToken.data());
    update();
  }


//
  firebaseUserList(prefs) {
    showDialog(
        context: Get.context!,
        barrierDismissible: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                contentPadding: EdgeInsets.zero,

                shape: const RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(AppRadius.r12))),
                backgroundColor: appCtrl.appTheme.trans,
                content: SizedBox(
                    child: SingleChildScrollView(
                        child: Column(children: [
                          GroupChat(prefs: prefs,).height(940).width(Sizes.s400),
                        ]))).paddingAll(Insets.i30));
          });
        }).then((value) {
    });
  }

   onSearch(val) async{
    message.asMap().entries.forEach((element) {
      if(element.value["name"].toString().toLowerCase().contains(val)){
        if(!searchMessage.contains(element.value)) {
          searchMessage.add(element.value);
        }
      }
    });
    update();
  }

  //status list

  List statusListWidget(
      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
    List statusList = [];
    for (int a = 0; a < snapshot.data!.docs.length; a++) {
      if (!statusList.contains(snapshot.data!.docs[a].data())) {
        statusList.add(snapshot.data!.docs[a].data());
      }
    }
    return statusList;
  }

/*
//
  firebaseUserList(prefs) {
    showDialog(
        context: Get.context!,
        barrierDismissible: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                contentPadding: EdgeInsets.zero,

                shape: const RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(AppRadius.r12))),
                backgroundColor: appCtrl.appTheme.transparentColor,
                content: SizedBox(
                    child: SingleChildScrollView(
                        child: Column(children: [
                          GroupChat(prefs: prefs,).height(940).width(Sizes.s400),
                        ]))).paddingAll(Insets.i30));
          });
        }).then((value) {
    });
  }

  getFirebaseData()async{
    await Future.delayed(DurationsClass.s3);
    if(appCtrl.contactList.isNotEmpty){
      createGroupCtrl.getFirebaseContact();
    }

  }


  textShow() async {
    await Future.delayed(DurationsClass.s2);
    isTextShow = true;
    update();
  }*/
}
