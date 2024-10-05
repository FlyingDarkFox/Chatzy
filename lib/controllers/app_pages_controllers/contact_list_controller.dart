
import 'dart:developer';
import '../../config.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import '../../models/contact_model.dart';

class UserData {
  final int time, userType;
  final Int8List? photoBytes;
  final String id, name, photoURL, aboutUser;
  final String idVariants;
  final List<dynamic>? dialCodePhoneList;

  UserData({
    required this.id,
    required this.idVariants,
    required this.userType,
    required this.aboutUser,
    required this.time,
    required this.name,
    required this.photoURL,
    this.photoBytes,
    this.dialCodePhoneList,
  });

  factory UserData.fromJson(Map<String, dynamic> jsonData) {
    return UserData(
      id: jsonData['id'],
      aboutUser: jsonData['about'],
      idVariants: jsonData['idVars'],
      name: jsonData['name'],
      photoURL: jsonData['url'],
      photoBytes: jsonData['bytes'],
      userType: jsonData['type'],
      time: jsonData['time'],
      dialCodePhoneList: jsonData['dialCodePhoneList'],
    );
  }

  static Map<String, dynamic> toMap(UserData user) => {
    'id': user.id,
    'about': user.aboutUser,
    'idVars': user.idVariants,
    'name': user.name,
    'url': user.photoURL,
    'bytes': user.photoBytes,
    'type': user.userType,
    'time': user.time,
    'dialCodePhoneList': user.dialCodePhoneList,
  };

  static String encode(List<UserData> users) => json.encode(
    users
        .map<Map<String, dynamic>>((user) => UserData.toMap(user))
        .toList(),
  );

  static List<UserData> decode(String users) =>
      (json.decode(users) as List<dynamic>)
          .map<UserData>((item) => UserData.fromJson(item))
          .toList();
}


class FetchContactController with ChangeNotifier {
  int daysToUpdateCache = 7;
  var firebaseUser =
  FirebaseFirestore.instance.collection(collectionName.users);
  List<UserData> localList = [];
  String localUsersSTRING = "";
  List<dynamic> currentUserPhoneNumberVariants = [];
  int? lastSyncedTime;


  syncContactsFromCloud(
      BuildContext context,
      SharedPreferences prefs,
      ) async {

    if(appCtrl.user != null && appCtrl.user != "") {
      log("USER :${appCtrl.user}");
      await FirebaseFirestore.instance
          .collection(collectionName.users)
          .doc(appCtrl.user['id']).collection(collectionName.userContact)
          .get()
          .then((doc) async {
        if (doc.docs.isNotEmpty) {
          if (doc.docs[0].data()['contacts'] != null) {
            alreadyRegisterUser =
                RegisterContactDetail.decode(doc.docs[0].data()['contacts']);
            // alreadyRegisterUser
            //     .sort((a, b) => a.name!.compareTo(b.name!));
            List<RegisterContactDetail> list = [];
            for (var user in alreadyRegisterUser) {
              var b =
              await getFromLocalStorage(prefs, user.phone!);
              if (b == null) {
                list.add(user);
              } else {
                list.add(RegisterContactDetail(
                    phone: user.phone, name: b.name, id: user.id,image: user.image));
              }
            }
            alreadyRegisterUser = list;
            alreadyRegisterUser
                .sort((a, b) => a.name!.compareTo(b.name!));
            notifyListeners();
          }
        }
      }).catchError((e) {
        alreadyRegisterUser = [];
        lastSyncedTime = null;
        notifyListeners();
      });
    }
  }

  addOrUpdateContact(
      {required SharedPreferences prefs,
        required UserData localUserData,
        required bool isNotifyListener}) {
    int ind =
    localList.indexWhere((element) => element.id == localUserData.id);
    if (ind >= 0) {
      if (localList[ind].name.toString() !=
          localUserData.name.toString() ||
          localList[ind].photoURL.toString() !=
              localUserData.photoURL.toString()) {
        localList.removeAt(ind);
        localList.insert(ind, localUserData);
        localList.sort(
                (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        if (isNotifyListener == true) {
          notifyListeners();
        }
        addAndGetLocalData(prefs);
      }
    } else {
      localList.add(localUserData);
      localList
          .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      if (isNotifyListener == true) {
        notifyListeners();
      }
      addAndGetLocalData(prefs);
    }
  }

  Future<UserData?> getFromLocalStorage(
      SharedPreferences prefs, String userid) async {

    int ind =
    localList.indexWhere((element) => element.idVariants == userid);
    if (ind >= 0) {

      UserData localUser = localList[ind];

      if (DateTime.now()
          .difference(DateTime.fromMillisecondsSinceEpoch(
          localUser.time))
          .inDays >
          daysToUpdateCache) {
        QuerySnapshot<Map<String, dynamic>> doc = await firebaseUser
            .where("phone", isEqualTo: localUser.id)
            .get();
        if (doc.docs.isNotEmpty) {
          if (doc.docs[0].data()["isActive"] == true) {
            var userDataModel = UserData(
                aboutUser: doc.docs[0].data()["statusDesc"] ?? "",
                idVariants: doc.docs[0].data()["phone"] ?? [userid],
                id: doc.docs[0].data()["id"],
                userType: 0,
                time: DateTime.now().millisecondsSinceEpoch,
                name: doc.docs[0].data()["name"],
                photoURL: doc.docs[0].data()["image"] ?? "");

            addOrUpdateContact(
                prefs: prefs,

                localUserData: userDataModel,isNotifyListener: true);
            return Future.value(userDataModel);
          }else {
            return Future.value(localUser);
          }
        } else {
          return Future.value(localUser);
        }
      } else {
        return Future.value(localUser);
      }
    } else {
      QuerySnapshot<Map<String, dynamic>> doc =
      await firebaseUser.where("phone", isEqualTo: userid).get();
      if (doc.docs.isNotEmpty) {
        // print("LOADED ${doc.data()![Dbkeys.phone]} SERVER ");
        if(doc.docs[0].data()["isActive"] == true){
          var userDataModel = UserData(
              aboutUser: doc.docs[0].data()["statusDesc"] ?? "",
              idVariants: doc.docs[0].data()["phone"] ,
              id: doc.docs[0].data()["id"],
              dialCodePhoneList: doc.docs[0].data()["dialCodePhoneList"] ?? [userid],
              userType: 0,
              time: DateTime.now().millisecondsSinceEpoch,
              name: doc.docs[0].data()["name"],
              photoURL: doc.docs[0].data()["image"] ?? "");

          addOrUpdateContact(
              prefs: prefs,
              isNotifyListener: false,
              localUserData: userDataModel);
          return Future.value(userDataModel);
        } else {
          return Future.value(null);
        }
      } else {
        return Future.value(null);
      }
    }
  }

  getDataFromFirebase(SharedPreferences prefs, String userid,
      Function(DocumentSnapshot<Map<String, dynamic>> doc) onReturnData) async {
    var doc = await firebaseUser.doc(userid).get();
    if (doc.exists && doc.data() != null) {
      onReturnData(doc);
      addOrUpdateContact(
          isNotifyListener: true,
          prefs: prefs,
          localUserData: UserData(
              id: doc.data()!["id"],
              idVariants: doc.data()!["phone"],
              userType: 0,
              dialCodePhoneList: doc.data()!["dialCodePhoneList"] ?? [userid],
              aboutUser: doc.data()!["statusDesc"],
              time: DateTime.now().millisecondsSinceEpoch,
              name: doc.data()!["name"],
              photoURL: doc.data()!["image"] ?? ""));
    }
  }

  fetchLocalStorageContact(SharedPreferences prefs, BuildContext context,
      ) async {
    localUsersSTRING = prefs.getString('localUsersSTRING') ?? "";
    // String? localUsersDEVICECONTACT =
    //     prefs.getString('localUsersDEVICECONTACT') ?? "";

    if (localUsersSTRING != "") {
      localList = UserData.decode(localUsersSTRING);
      localList
          .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

      await syncContactsFromCloud(context,  prefs);
      searchData = false;
      notifyListeners();
    } else {
      await syncContactsFromCloud(context,  prefs);
      searchData = false;
      notifyListeners();
    }


  }

  addAndGetLocalData(SharedPreferences prefs) async {
    if (searchData == false) {
      localUsersSTRING = UserData.encode(localList);
      await prefs.setString('localUsersSTRING', localUsersSTRING);

    }
  }

  List<RegisterContactDetail> oldStorageData = [];
  List<RegisterContactDetail> alreadyRegisterUser = [];

  Map<String?, String?>? contactsBookContactList = <String, String>{};
  bool searchData = true;

  String getUserNameOrIdQuickly(String userid) {
    if (localList.indexWhere((element) => element.id == userid) >= 0) {
      return localList[
      localList.indexWhere((element) => element.id == userid)]
          .name;
    } else {
      return 'User';
    }
  }
}
