import 'dart:developer';
import 'dart:io';
import 'package:chatzy_web/config.dart';

import 'message_firebase_api.dart';

class MessageController extends GetxController {
  String? currentUserId;
  User? currentUser;
  dynamic storageUser;
  bool isHomePageSelected = true;

  List contactList = [];

  List contactExistList = [];
  int unSeen = 0;
  bool isLoading = false;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  String? groupId;
  Image? contactPhoto;
  XFile? imageFile;
  File? image;
  List selectedContact = [];

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void onReady() async {
    // TODO: implement onReady
    final data = appCtrl.storage.read(session.user);
    if(data != null) {
      currentUserId = data["id"];
      storageUser = data;
    }
    update();
    //contactExistList = await MessageFirebaseApi().getExistUser();
    super.onReady();
  }

  // BOTTOM TAB LAYOUT ICON CLICKED
  void onBottomIconPressed(int index) {
    if (index == 0 || index == 1) {
      isHomePageSelected = true;
      update();
    } else {
      isHomePageSelected = false;
      update();
    }
  }



}
