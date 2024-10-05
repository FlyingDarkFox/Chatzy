
import 'package:chatzy_web/config.dart';
import 'package:localstorage/localstorage.dart';

class SettingController extends GetxController {
  List settingList = [];
  dynamic user;

  @override
  void onReady() {
    // TODO: implement onReady
    settingList = appArray.settingList;
    user = appCtrl.storage.read(session.user) ?? "";
    update();
    super.onReady();
  }


  //on setting tap
  onSettingTap(index) async {
    if (index == 0) {
      language();
    } else if (index == 1) {
      appCtrl.isRTL = !appCtrl.isRTL;
      appCtrl.update();
      await appCtrl.storage.write(session.isRTL, appCtrl.isRTL);
      Get.forceAppUpdate();
    } else if (index == 2) {
      appCtrl.isTheme = !appCtrl.isTheme;

      appCtrl.update();
      ThemeService().switchTheme(appCtrl.isTheme);
      await appCtrl.storage.write(session.isDarkMode, appCtrl.isTheme);
    } else if (index == 3) {
      deleteUser();
    } else {
      var user = appCtrl.storage.read(session.user);

      await FirebaseFirestore.instance
          .collection(collectionName.users)
          .doc(user["id"])
          .update({
        "status": "Offline",
        "lastSeen": DateTime.now().millisecondsSinceEpoch.toString()
      });
      FirebaseAuth.instance.signOut();
      await appCtrl.storage.remove(session.user);
      await appCtrl.storage.remove(session.id);
      await appCtrl.storage.remove(session.isDarkMode);
      await appCtrl.storage.remove(session.isRTL);
      await appCtrl.storage.remove(session.languageCode);
      await appCtrl.storage.remove(session.languageCode);
      Get.offAllNamed(routeName.phoneWrap);

    }
  }

  deleteUser() async {
    await showDialog(
      context: Get.context!,
      builder: (_) => AlertDialog(
        actionsPadding: const EdgeInsets.symmetric(
            vertical: Insets.i15, horizontal: Insets.i15),
        backgroundColor: appCtrl.appTheme.white,
        title: Text(appFonts.deleteAccount.tr),
        content: Text(
          appFonts.deleteAccount.tr,
          style: AppCss.manropeMedium14
              .textColor(appCtrl.appTheme.darkText)
              .textHeight(1.3),
        ),
        actions: [
          SizedBox(
            width: Sizes.s80,
            child: Text(
              appFonts.cancel.tr,
              textAlign: TextAlign.center,
              style:
                  AppCss.manropeMedium14.textColor(appCtrl.appTheme.white),
            )
                .paddingSymmetric(horizontal: Insets.i15, vertical: Insets.i8)
                .decorated(
                    color: appCtrl.appTheme.primary,
                    borderRadius: BorderRadius.circular(AppRadius.r25)),
          ).inkWell(onTap: () => Get.back()),
          SizedBox(
            width: Sizes.s80,
            child: Text(
              appFonts.ok.tr,
              textAlign: TextAlign.center,
              style:
                  AppCss.manropeMedium14.textColor(appCtrl.appTheme.white),
            )
                .paddingSymmetric(horizontal: Insets.i15, vertical: Insets.i8)
                .decorated(
                    color: appCtrl.appTheme.primary,
                    borderRadius: BorderRadius.circular(AppRadius.r25)),
          ).inkWell(onTap: () async {
            await FirebaseFirestore.instance
                .collection(collectionName.calls)
                .doc(appCtrl.user["id"])
                .delete();
            await FirebaseFirestore.instance
                .collection(collectionName.users)
                .doc(appCtrl.user["id"])
                .collection(collectionName.status)
                .get()
                .then((value) {
              for (QueryDocumentSnapshot<Map<String, dynamic>> ds
              in value.docs) {
                Status status = Status.fromJson(ds.data());
                List<PhotoUrl> photoUrl = status.photoUrl ?? [];
                for (var list in photoUrl) {
                  if (list.statusType == StatusType.image.name ||
                      list.statusType == StatusType.video.name) {
                    FirebaseStorage.instance
                        .refFromURL(list.image!)
                        .delete();
                  }
                }
              }
            });
            await FirebaseFirestore.instance
                .collection(collectionName.users)
                .doc(appCtrl.user["id"])
                .collection(collectionName.chats)
                .get()
                .then((value) {
              for (DocumentSnapshot ds in value.docs) {
                ds.reference.delete();
              }
            });
            await FirebaseFirestore.instance
                .collection(collectionName.users)
                .doc(appCtrl.user["id"])
                .collection(collectionName.messages)
                .get()
                .then((value) {
              for (QueryDocumentSnapshot<Map<String, dynamic>> ds
              in value.docs) {
                if (ds.data()["type"] == MessageType.image.name ||
                    ds.data()["type"] == MessageType.audio.name ||
                    ds.data()["type"] == MessageType.video.name ||
                    ds.data()["type"] == MessageType.doc.name ||
                    ds.data()["type"] == MessageType.gif.name ||
                    ds.data()["type"] == MessageType.imageArray.name) {
                  String url = decryptMessage(ds.data()["content"]);
                  FirebaseStorage.instance
                      .refFromURL(url.contains("-BREAK-")
                      ? url.split("-BREAK-")[0]
                      : url)
                      .delete();
                }
                ds.reference.delete();
              }
            });
            await FirebaseFirestore.instance
                .collection(collectionName.users)
                .doc(appCtrl.user["id"])
                .collection(collectionName.groupMessage)
                .get()
                .then((value) {
              for (QueryDocumentSnapshot<Map<String, dynamic>> ds
              in value.docs) {
                if (ds.data()["type"] == MessageType.image.name ||
                    ds.data()["type"] == MessageType.audio.name ||
                    ds.data()["type"] == MessageType.video.name ||
                    ds.data()["type"] == MessageType.doc.name ||
                    ds.data()["type"] == MessageType.gif.name ||
                    ds.data()["type"] == MessageType.imageArray.name) {
                  String url = decryptMessage(ds.data()["content"]);
                  FirebaseStorage.instance
                      .refFromURL(url.contains("-BREAK-")
                      ? url.split("-BREAK-")[0]
                      : url)
                      .delete();
                }
                ds.reference.delete();
              }
            });

            await FirebaseFirestore.instance
                .collection(collectionName.users)
                .doc(appCtrl.user["id"])
                .collection(collectionName.broadcastMessage)
                .get()
                .then((value) {
              for (QueryDocumentSnapshot<Map<String, dynamic>> ds
              in value.docs) {
                if (ds.data()["type"] == MessageType.image.name ||
                    ds.data()["type"] == MessageType.audio.name ||
                    ds.data()["type"] == MessageType.video.name ||
                    ds.data()["type"] == MessageType.doc.name ||
                    ds.data()["type"] == MessageType.gif.name ||
                    ds.data()["type"] == MessageType.imageArray.name) {
                  String url = decryptMessage(ds.data()["content"]);
                  FirebaseStorage.instance
                      .refFromURL(url.contains("-BREAK-")
                      ? url.split("-BREAK-")[0]
                      : url)
                      .delete();
                }
                ds.reference.delete();
              }
            });

            await FirebaseFirestore.instance
                .collection(collectionName.users)
                .doc(appCtrl.user["id"])
                .delete();
            await appCtrl.storage.remove(session.isDarkMode);
            await appCtrl.storage.remove(session.isRTL);
            await appCtrl.storage.remove(session.languageCode);
            await appCtrl.storage.remove(session.languageCode);
            await appCtrl.storage.remove(session.user);
            await appCtrl.storage.remove(session.id);
            FirebaseAuth.instance.signOut();

            update();
            appCtrl.pref!.remove('storageUserString');
            appCtrl.user = null;
            appCtrl.pref = null;
            final LocalStorage storage = LocalStorage('localUsersSTRING');
            await storage.clear();

            Get.offAllNamed(routeName.phoneWrap,
                arguments: appCtrl.pref);
          })
        ],
      ),
    );
  }
}
