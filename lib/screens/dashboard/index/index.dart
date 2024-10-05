import 'dart:developer';
import 'package:chatzy_web/screens/other_screens/pick_up_call/pick_up_call.dart';

import '../../../config.dart';
import 'package:universal_html/html.dart' as html;
import '../../other_screens/setting/setting.dart';
import 'layouts/all_status_.dart';
import 'layouts/drawer.dart';
import 'layouts/drawer_menu.dart';
import 'layouts/selected_body_layout.dart';

class IndexLayout extends StatefulWidget {
  final SharedPreferences? pref;
  const IndexLayout({
    Key? key,this.pref
  }) : super(key: key);

  @override
  State<IndexLayout> createState() => _IndexLayoutState();
}

class _IndexLayoutState extends State<IndexLayout> with WidgetsBindingObserver {
  final indexCtrl = Get.put(IndexController());
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> scaffoldSettingKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initData();
    final FetchContactController registerAvailableContact =
    Provider.of<FetchContactController>(Get.context!, listen: false);
    registerAvailableContact.syncContactsFromCloud(Get.context!,  widget.pref!);
  }

  initData()async{
    FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc( appCtrl.user != null && appCtrl.user != ""? appCtrl.user["id"]: appCtrl.id)
        .collection(collectionName.userContact).snapshots().listen((event) {
       if(event.docs.isNotEmpty){
         final FetchContactController registerAvailableContact =
         Provider.of<FetchContactController>(Get.context!, listen: false);
         registerAvailableContact.syncContactsFromCloud(Get.context!,  widget.pref!);
       }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      firebaseCtrl.setIsActive();
      log("STATE : $state");
    } else {
      firebaseCtrl.setLastSeen();
    }
    log("STATE1 : $state");
    firebaseCtrl.deleteAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<IndexController>(builder: (_) {
      return Consumer<FetchContactController>(
          builder: (context1, contactCtrl, child) {
            log("UID : ${appCtrl.user['id']}");
          return PickupLayout(
            scaffold: MaterialApp(
              debugShowCheckedModeBanner: false,
              home: DirectionalityRtl(
                child: Scaffold(
                    key: scaffoldKey,
                    backgroundColor: appCtrl.appTheme.bg,
                    drawer: Drawer(
                        shape:  RoundedRectangleBorder(
                          borderRadius:BorderRadius.circular(0),
                        ),
                        backgroundColor: appCtrl.appTheme.white,
                        width: Responsive.isMobile(context) ? MediaQuery.of(context).size.width: Sizes.s520,
                        child: indexCtrl.drawerIndex.value == false
                            ? IndexDrawer(
                          onTap: () {
                            indexCtrl.drawerIndex.value =
                            !indexCtrl.drawerIndex.value;
                            scaffoldKey.currentState!.closeDrawer();
                            indexCtrl.update();
                          },
                        )
                            :indexCtrl.settingIndex.value == false
                            ? Setting(
                          onTap: () {
                            indexCtrl.settingIndex.value =
                            !indexCtrl.settingIndex.value;
                            scaffoldKey.currentState!.closeDrawer();
                            indexCtrl.update();
                          },
                        )
                            : AllStatus(firebaseList: appCtrl.firebaseContact)),
                    body:Stack(
                      children: [
                        SafeArea(
                            child: Scaffold(
                                backgroundColor: appCtrl.appTheme.bg,
                                body: StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection(collectionName.users)
                                        .doc( appCtrl.user != null && appCtrl.user != ""? appCtrl.user["id"]: appCtrl.id)
                                        .collection(collectionName.userContact)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {

                                        firebaseCtrl.deleteAllListContact();
                                        if(appCtrl.contactList.isNotEmpty) {

                                          appCtrl.storage.write(
                                              session.contactList,
                                              appCtrl.contactList);
                                        }
                                      }
                                      return Row(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            ValueListenableBuilder<bool>(
                                                valueListenable: indexCtrl.isOpen,
                                                builder: (context, value, child) {
                                                  return DrawerMenu(
                                                    statusTap: () {
                                                      indexCtrl.statusIndex.value =
                                                      !indexCtrl
                                                          .statusIndex.value;
                                                      scaffoldKey.currentState!
                                                          .openDrawer();
                                                    },
                                                    value: value,
                                                    onTap: (result) async {
                                                      log("result : $result");
                                                      if (result == 0) {
                                                        indexCtrl.createGroupCtrl
                                                            .isGroup = false;
                                                        indexCtrl.createGroupCtrl
                                                            .update();
                                                        indexCtrl.firebaseUserList(widget.pref);
                                                      }
                                                      if (result == 1) {
                                                        indexCtrl.createGroupCtrl
                                                            .isGroup = true;
                                                        indexCtrl.createGroupCtrl
                                                            .update();
                                                        indexCtrl.firebaseUserList(widget.pref);
                                                      } else if (result == 2) {
                                                        indexCtrl.drawerIndex.value =
                                                        !indexCtrl
                                                            .drawerIndex.value;
            
                                                        indexCtrl.update();
                                                        scaffoldKey.currentState!
                                                            .openDrawer();
                                                      } else if (result == 3) {
                                                        indexCtrl.settingIndex.value =
                                                        !indexCtrl
                                                            .settingIndex.value;
                                                        indexCtrl.update();
                                                        scaffoldKey.currentState!
                                                            .openDrawer();
                                                      } else if (result == 4) {
                                                        indexCtrl.createGroupCtrl
                                                            .isAddUser = true;
                                                        indexCtrl.createGroupCtrl
                                                            .update();
                                                        indexCtrl.firebaseUserList(widget.pref);
                                                      } else if (result == 5) {
                                                        FirebaseAuth.instance
                                                            .signOut();
                                                        indexCtrl.selectedIndex = 0;
                                                        appCtrl.isLogged = false;
                                                        appCtrl.storage
                                                            .remove("isSignIn");
                                                        appCtrl.storage.remove(
                                                            session.isDarkMode);
                                                        appCtrl.storage
                                                            .remove(session.isLogin);
                                                        appCtrl.storage.remove(
                                                            session.languageCode);
                                                        appCtrl.isLogin = "false";
                                                        html.window.localStorage[
                                                        session.isLogin] =
                                                        "false";
                                                        Get.offAll(
                                                                () => LoginScreen(pref:widget.pref,));
                                                        await FirebaseFirestore.instance
                                                            .collection(collectionName.users)
                                                            .doc(appCtrl.user["id"])
                                                            .collection(collectionName.userContact)
                                                            .get()
                                                            .then((value) {
                                                          if (value.docs.isNotEmpty) {
                                                            value.docs.asMap().entries.forEach((element) {
                                                              FirebaseFirestore.instance
                                                                  .collection(collectionName.users)
                                                                  .doc(appCtrl.user["id"])
                                                                  .collection(collectionName.userContact)
                                                                  .doc(element.value.id)
                                                                  .delete();
                                                            });
                                                          }
                                                        });
                                                      }
                                                    },
                                                  );
                                                }),
                                            if (Responsive.isDesktop(context) ||
                                                Responsive.isDesktop(context))
                                              const SelectedIndexBodyLayout()
                                          ]);
                                    }))),
                      ],
                    )),
              ),
            ),
          );
        }
      );
    });
  }
}
