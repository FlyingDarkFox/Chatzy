import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:chatzy_web/config.dart';


class DashboardController extends GetxController
    with GetSingleTickerProviderStateMixin {
  int selectedIndex = 0;
  int selectedPopTap = 0;
  TabController? controller;
  late int iconCount = 0;
  Timer? timer;
  List<ContactModel> contactList = [];

  List bottomList = [];
  dynamic user;


  TextEditingController searchText = TextEditingController();
  TextEditingController userText = TextEditingController();


  List actionList = [];
  List statusAction = [];
  List callsAction = [];
  ConnectivityResult connectionStatus = ConnectivityResult.none;
  final Connectivity connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> connectivitySubscription;


  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
     List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      log('Couldn\'t check connectivity status', error: e);
      return;
    }

    return updateConnectionStatus(result as ConnectivityResult);
  }

  Future<void> updateConnectionStatus(ConnectivityResult result) async {
    connectionStatus = result;
    update();
  }

  //on tap select
  onTapSelect(val) async {
    selectedIndex = val;
    update();
  }


  @override
  void onReady() async {
    // TODO: implement onReady
    await Future.delayed(DurationsClass.ms150);
    bottomList = appArray.bottomList;
    actionList = appArray.actionList;
    statusAction = appArray.statusAction;
    callsAction = appArray.callsAction;
    controller = TabController(length: bottomList.length, vsync: this);
    firebaseCtrl.setIsActive();
    controller!.addListener(() {
      selectedIndex = controller!.index;
      update();
    });
    user = appCtrl.storage.read(session.user);
    appCtrl.update();

    update();
    await Future.delayed(DurationsClass.s3);
    //checkContactList();
    super.onReady();
  }


  @override
  void dispose() {
    // TODO: implement dispose
    timer!.cancel();
    super.dispose();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

}
