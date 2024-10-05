import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/services.dart';

import 'package:get_storage/get_storage.dart';
import '../../config.dart';
import '../../models/contact_model.dart';
import '../../models/data_model.dart';
import '../../models/firebase_contact_model.dart';
import '../../models/status_model.dart';
import '../../models/usage_control_model.dart';
import '../../models/user_setting_model.dart';
import '../../screens/other_screens/language.dart';


class AppController extends GetxController {
  AppTheme _appTheme = AppTheme.fromType(ThemeType.light);
  final storage = GetStorage();
  //List<FirebaseContactModel> contactList = [];
  List<RegisterContactDetail> contactList = [];
  List<FirebaseContactModel> userContactList = [];
  List firebaseContact =[];
  List<Status> statusList = [];
  AppTheme get appTheme => _appTheme;
  int selectedIndex = 0;
  bool isTheme = false;
  bool isLogged = false;
  bool isBiometric = false;
  String isLogin = "false";
  bool isRTL = false,isLoading =false;
  String languageVal = "in";
  List drawerList = [];
  int currVal = 1;
  String deviceName = "";
  String device = "";
  UserAppSettingModel? userAppSettingsVal;
  UsageControlModel? usageControlsVal;
  dynamic user;
  String? id;
  String dialCode = "";
  SharedPreferences? pref;
  var deviceData = <String, dynamic>{};

//list of bottommost page
  List<Widget> widgetOptions = <Widget>[];

  //update theme
  updateTheme(theme) {
    _appTheme = theme;
    Get.forceAppUpdate();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    getData();

    initPlatformState();
    update();
    getAdminPermission();


    super.onReady();
  }

  //get data from storage
  getData() async {

    //theme check
    bool loadThemeFromStorage = storage.read(session.isDarkMode) ?? false;
    if (loadThemeFromStorage) {
      isTheme = true;
    } else {
      isTheme = false;
    }

    log("contactList : $contactList");

    update();
    await storage.write(session.isDarkMode, isTheme);
    ThemeService().switchTheme(isTheme);
    user = appCtrl.storage.read(session.user);
    update();
    Get.forceAppUpdate();
  }

  getAdminPermission() async {
    final usageControls = await FirebaseFirestore.instance
        .collection(collectionName.config)
        .doc(collectionName.usageControls)
        .get();

    usageControlsVal = UsageControlModel.fromJson(usageControls.data()!);


    appCtrl.storage.write(session.usageControls, usageControls.data());
    update();
    final userAppSettings = await FirebaseFirestore.instance
        .collection(collectionName.config)
        .doc(collectionName.userAppSettings)
        .get();

    userAppSettingsVal = UserAppSettingModel.fromJson(userAppSettings.data()!);
    final agoraToken = await FirebaseFirestore.instance
        .collection(collectionName.config)
        .doc(collectionName.agoraToken)
        .get();
    await   appCtrl.storage.write(session.agoraToken, agoraToken.data());

    update();
  }

  Future<void> initPlatformState() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    try {
      if (kIsWeb) {
        deviceData = _readWebBrowserInfo(await deviceInfoPlugin.webBrowserInfo);
      } else {
        if (Platform.isAndroid) {
          AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
          deviceName = androidInfo.model;
          device = "android";
        } else if (Platform.isIOS) {
          IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
          deviceName = iosInfo.utsname.machine.toString();
          device = "ios";
        }
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }
    update();
  }

  Map<String, dynamic> _readWebBrowserInfo(WebBrowserInfo data) {
    return <String, dynamic>{
      'browserName': describeEnum(data.browserName),
      'appCodeName': data.appCodeName,
      'appName': data.appName,
      'appVersion': data.appVersion,
      'deviceMemory': data.deviceMemory,
      'language': data.language,
      'languages': data.languages,
      'platform': data.platform,
      'product': data.product,
      'productSub': data.productSub,
      'userAgent': data.userAgent,
      'vendor': data.vendor,
      'vendorSub': data.vendorSub,
      'hardwareConcurrency': data.hardwareConcurrency,
      'maxTouchPoints': data.maxTouchPoints,
    };
  }
}

language() async {
  Get.generalDialog(
    pageBuilder: (context, anim1, anim2) {
      return Align(
        alignment: Alignment.center,
        child: Container(
          height: Sizes.s280,
          decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(AppRadius.r8)),
          margin: const EdgeInsets.symmetric(horizontal: Insets.i50),
          child: LanguageScreen(),
        ),
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return SlideTransition(
          position: Tween(begin: const Offset(0, -1), end: const Offset(0, 0))
              .animate(anim1),
          child: child
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}
