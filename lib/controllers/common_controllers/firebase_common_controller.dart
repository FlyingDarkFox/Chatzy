import 'dart:developer';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:dio/dio.dart';
import 'package:chatzy_web/config.dart';

import '../../models/status_model.dart';

class FirebaseCommonController extends GetxController {
  List<PhotoUrl> newPhotoList = [];

  //online status update
  void setIsActive() async {
    var user = appCtrl.storage.read(session.user) ?? "";
    if (user != "") {
      await FirebaseFirestore.instance
          .collection(collectionName.users)
          .doc(user["id"])
          .update(
        {
          "status": "Online",
          "isSeen": true,
          "lastSeen": DateTime.now().millisecondsSinceEpoch.toString()
        },
      );
    }
  }

  //last seen update
  void setLastSeen() async {
    var user = appCtrl.storage.read(session.user) ?? "";
    if (user != "") {
      await FirebaseFirestore.instance
          .collection(collectionName.users)
          .doc(user["id"])
          .update(
        {
          "status": "Offline",
          "lastSeen": DateTime.now().millisecondsSinceEpoch.toString()
        },
      );
    }
  }
  //last seen update
  void groupTypingStatus(pId, isTyping) async {
    var user = appCtrl.storage.read(session.user);

    String nameList = "";

    await FirebaseFirestore.instance
        .collection(collectionName.groups)
        .doc(pId)
        .get()
        .then((value) {
      if (value.exists) {
        nameList = value.data()!["status"] ?? "";
        if (nameList != "") {
          String newName = nameList.split(" is typing")[0];
          nameList = "$newName, ${user["name"]}";
        }
      }
    });
    await FirebaseFirestore.instance.collection("groups").doc(pId).update(
      {"status": isTyping ? "$nameList is typing" : ""},
    );
  }

  //typing update
  void setTyping() async {
    var user = appCtrl.storage.read(session.user);
    await FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(user["id"])
        .update(
      {
        "status": "typing...",
        "lastSeen": DateTime.now().millisecondsSinceEpoch.toString(),
      },
    );
  }

  //status delete after 24 hours
  statusDeleteAfter24Hours() async {
    var user = appCtrl.storage.read(session.user) ?? "";
    if (user != "") {
      FirebaseFirestore.instance
          .collection(collectionName.users)
          .doc(user["id"])
          .collection(collectionName.status)
          .get()
          .then((value) async {
        if (value.docs.isNotEmpty) {
          Status status = Status.fromJson(value.docs[0].data());
          List<PhotoUrl> photoUrl = status.photoUrl!;
          await getPhotoUrl(status.photoUrl!).then((list) async {
            List<PhotoUrl> photoUrls = list;
            log("photoUrls : ${photoUrls.length}");
            if (photoUrls.isEmpty) {
              FirebaseFirestore.instance
                  .collection(collectionName.users)
                  .doc(user["id"])
                  .collection(collectionName.status)
                  .doc(value.docs[0].id)
                  .delete();
            } else {
              if (photoUrls.length <= status.photoUrl!.length) {
                log("URL : ${photoUrls.length <= status.photoUrl!.length}");
                var statusesSnapshot = await FirebaseFirestore.instance
                    .collection(collectionName.users)
                    .doc(user["id"])
                    .collection(collectionName.status)
                    .get();
                await FirebaseFirestore.instance
                    .collection(collectionName.users)
                    .doc(user["id"])
                    .collection(collectionName.status)
                    .doc(statusesSnapshot.docs[0].id)
                    .update(
                    {'photoUrl': photoUrl.map((e) => e.toJson()).toList()});
              }
            }
          });
        }
      });
    }
  }

  bool isMoreThan24HoursAgo(DateTime givenTime) {
    // Get the current time
    DateTime currentTime = DateTime.now();

    // Calculate the time difference
    Duration timeDifference = currentTime.difference(givenTime);
    int hour =
    int.parse(appCtrl.usageControlsVal!.statusDeleteTime!.split(" hrs")[0]);
    // Check if the time difference is greater than 24 hours
    return timeDifference.inHours > hour;
  }

  bool isMoreThanMinAgo(DateTime givenTime) {
    // Get the current time
    DateTime currentTime = DateTime.now();

    // Calculate the time difference
    Duration timeDifference = currentTime.difference(givenTime);
    int hour =
    int.parse(appCtrl.usageControlsVal!.statusDeleteTime!.split(" min")[0]);

    // Check if the time difference is greater than 24 hours
    return timeDifference.inMinutes >= hour;
  }

  Future<List<PhotoUrl>> getPhotoUrl(List<PhotoUrl> photoUrl) async {
    for (int i = 0; i < photoUrl.length; i++) {
      newPhotoList = [];
      DateTime dt = DateTime.fromMillisecondsSinceEpoch(
          int.parse(photoUrl[i].expiryDate != null? photoUrl[i].expiryDate!.toString() :DateTime.now().millisecondsSinceEpoch.toString()));
      var date = DateTime.now();

      debugPrint("diff : ${dt.hour}");

      debugPrint("diff : ${date.hour}");
      debugPrint(
          "diff : ${appCtrl.usageControlsVal!.statusDeleteTime!.contains(" hrs")}");
      if (appCtrl.usageControlsVal!.statusDeleteTime!.contains(" hrs")) {

        bool isMoreThan24Hours = isMoreThan24HoursAgo(dt);
        if (!isMoreThan24Hours) {
          newPhotoList.add(photoUrl[i]);
        }
      } else if (appCtrl.usageControlsVal!.statusDeleteTime!.contains(" min")) {
        log("ISIIS:");
        bool isMoreThan24Hours = isMoreThanMinAgo(dt);
        log("isMoreThan24Hours: $isMoreThan24Hours");
        if (!isMoreThan24Hours) {
          newPhotoList.add(photoUrl[i]);
        }
      }
      update();
    }
    update();
    log("NEWLIST : ${newPhotoList.length}");

    return newPhotoList;
  }

  deleteForAllUsers() async {
    final appCtrl = Get.isRegistered<AppController>()
        ? Get.find<AppController>()
        : Get.put(AppController());
    log("appCtrl.user::${appCtrl.user}");
    await FirebaseFirestore.instance
        .collection(collectionName.users)
        .get()
        .then((value) async {
      for (QueryDocumentSnapshot<Map<String, dynamic>> user in value.docs) {
        if (appCtrl.user != null) {
          if (user.id != appCtrl.user['id']) {
            await FirebaseFirestore.instance
                .collection(collectionName.users)
                .doc(user.id)
                .collection(collectionName.status)
                .get()
                .then((statusData) {
              for (QueryDocumentSnapshot<Map<String, dynamic>> statusVal
              in statusData.docs) {
                Status status = Status.fromJson(statusVal.data());
                List<PhotoUrl> photoList = status.photoUrl ?? [];
                List<PhotoUrl> newList = [];

                for (PhotoUrl photoUrl in photoList) {
                  DateTime expiryDate = DateTime.fromMillisecondsSinceEpoch(
                      int.parse(photoUrl.expiryDate ??
                          DateTime.now().millisecondsSinceEpoch.toString()));
                  if (appCtrl.usageControlsVal!.statusDeleteTime!
                      .contains(" hrs")) {
                    bool isMoreThan24Hours = isMoreThan24HoursAgo(expiryDate);
                    if (!isMoreThan24Hours) {
                      newList.add(photoUrl);
                    }
                  } else if (appCtrl.usageControlsVal!.statusDeleteTime!
                      .contains(" min")) {
                    bool isMoreThan24Hours = isMoreThanMinAgo(expiryDate);

                    if (!isMoreThan24Hours) {
                      newList.add(photoUrl);
                    }
                  }
                }
                FirebaseFirestore.instance
                    .collection(collectionName.users)
                    .doc(user.id)
                    .collection(collectionName.status)
                    .doc(statusVal.id)
                    .update({
                  "photoUrl": newPhotoList.map((e) => e.toJson()).toList()
                });
              }
            });
          }
        } else {
          await FirebaseFirestore.instance
              .collection(collectionName.users)
              .doc(user.id)
              .collection(collectionName.status)
              .get()
              .then((statusData) {
            for (QueryDocumentSnapshot<Map<String, dynamic>> statusVal
            in statusData.docs) {
              Status status = Status.fromJson(statusVal.data());
              List<PhotoUrl> photoList = status.photoUrl ?? [];
              List<PhotoUrl> newList = [];

              for (PhotoUrl photoUrl in photoList) {
                DateTime expiryDate = DateTime.fromMillisecondsSinceEpoch(
                    int.parse(photoUrl.expiryDate ??
                        DateTime.now().millisecondsSinceEpoch.toString()));
                if (appCtrl.usageControlsVal!.statusDeleteTime!
                    .contains(" hrs")) {
                  bool isMoreThan24Hours = isMoreThan24HoursAgo(expiryDate);
                  if (!isMoreThan24Hours) {
                    newList.add(photoUrl);
                  }
                } else if (appCtrl.usageControlsVal!.statusDeleteTime!
                    .contains(" min")) {
                  bool isMoreThan24Hours = isMoreThanMinAgo(expiryDate);

                  if (!isMoreThan24Hours) {
                    newList.add(photoUrl);
                  }
                }
              }
              FirebaseFirestore.instance
                  .collection(collectionName.users)
                  .doc(user.id)
                  .collection(collectionName.status)
                  .doc(statusVal.id)
                  .update({
                "photoUrl": newPhotoList.map((e) => e.toJson()).toList()
              });
            }
          });
        }
      }
    });
  }

  //delete all contacts
  deleteAllContacts() async {
    await FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(appCtrl.user["id"])
        .update({"isWebLogin": false});
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

  deleteAllListContact() async {
    await Future.delayed(DurationsClass.s4);
    if (appCtrl.contactList.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection(collectionName.users)
          .doc(appCtrl.user["id"])
          .update({"isWebLogin": false});
      await FirebaseFirestore.instance
          .collection(collectionName.users)
          .doc(appCtrl.user["id"])
          .collection(collectionName.userContact)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          if (value.docs.length != 1) {
            List userList =
            value.docs.getRange(0, value.docs.length - 1).toList();
            userList.asMap().entries.forEach((element) {
              FirebaseFirestore.instance
                  .collection(collectionName.users)
                  .doc(appCtrl.user["id"])
                  .collection(collectionName.userContact)
                  .doc(element.value.id)
                  .delete();
            });
          }
        }
      });
    }
  }

  //send notification
  Future<void> sendNotification(
      {title,
        msg,
        token,
        image,
        dataTitle,
        chatId,
        groupId,
        userContactModel,
        pId,
        pName}) async {
    log('token : $token');

    final data = {
      "notification": {
        "body": msg,
        "title": dataTitle,
      },
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "alertMessage": 'true',
        "title": title,
        "chatId": chatId,
        "groupId": groupId,
        "userContactModel": userContactModel,
        "pId": pId,
        "pName": pName,
        "imageUrl": image,
        "isGroup": false
      },
      "to": "$token"
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization':
      'key=${appCtrl.userAppSettingsVal!.firebaseServerToken}'
    };

    BaseOptions options = BaseOptions(
      connectTimeout: DurationsClass.s5,
      receiveTimeout: DurationsClass.s3,
      headers: headers,
    );

    try {
      final response = await Dio(options)
          .post('https://fcm.googleapis.com/fcm/send', data: data);

      if (response.statusCode == 200) {
        log('Alert push notification send');
      } else {
        log('notification sending failed');
        // on failure do sth
      }
    } catch (e) {
      log('exception $e');
    }
  }

  getAgoraTokenAndChannelName() async {
    var agoraData = appCtrl.storage.read(session.agoraToken);

    try {
      HttpsCallable httpsCallable =
      FirebaseFunctions.instance.httpsCallable("generateToken");

      dynamic result = await httpsCallable.call({
        "appId": agoraData["agoraAppId"],
        "appCertificate": agoraData["appCertificate"]
      });

      if (result.data != null) {
        Map<String, dynamic> response = {
          "agoraToken": result.data['data']["token"],
          "channelName": result.data['data']["channelName"],
        };

        return response;
      } else {
        return null;
      }
    } catch (e) {
      log("ERROR WHILE FETCH CREDENTIALS : $e");
    }
  }
}
