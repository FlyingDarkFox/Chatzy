import 'dart:async';
import 'dart:developer';

import 'package:chatzy_web/config.dart';
import 'package:universal_html/html.dart' as html;

import '../../utils/general_utils.dart';
import '../bottom_controllers/index_controller.dart';

class OtpController extends GetxController {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final focusNode = FocusNode();
  Duration myDuration = const Duration(seconds: 60);
  TextEditingController otp = TextEditingController();
  double val = 0;
  bool isCodeSent = false, isLoading = false, isCountDown = true;
  String? verificationCode, mobileNumber, dialCodeVal;
  bool isValid = false;
  Timer? countdownTimer;
  SharedPreferences? pref;
  ConfirmationResult? result;

  @override
  void onReady() {
    // TODO: implement onReady
    mobileNumber = Get.arguments;

    update();
    super.onReady();
  }

  void startTimer() {
    countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  void setCountDown() {
    const reduceSecondsBy = 1;
    final seconds = myDuration.inSeconds - reduceSecondsBy;
    if (seconds < 0) {
      isCountDown = false;
      verificationCode =null;
      countdownTimer!.cancel();
    } else {
      myDuration = Duration(seconds: seconds);
    }
    update();
  }

  resendCode() async {
    isLoading = true;
    update();

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '${dialCodeVal ?? "+91"}${mobileNumber.toString()}',
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) async {

        verificationCode = verificationId;
        var phoneUser = FirebaseAuth.instance.currentUser;
        debugPrint("log 3 $phoneUser");

        isLoading = false;
        update();
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
    update();
  }

// Dismiss KEYBOARD
  void dismissKeyboard() {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
  }

  //navigate to dashboard
  homeNavigation(user) async {
    appCtrl.storage.write(session.id, user["id"]);
    await appCtrl.storage.write(session.user, user);
    await appCtrl.storage.write(session.isIntro, true);
    Get.forceAppUpdate();
    html.window.localStorage[session.isLogin] = "true";
    await appCtrl.storage.write(session.isLogin, true);
    html.window.localStorage[session.id] = user['id'];
    appCtrl.isLogged = true;
    await appCtrl.storage.write("isSignIn", appCtrl.isLogged);
    await FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(user["id"])
        .update({
      'status': "Online",
      "isActive": true,
      "isWebLogin": true,
      'phoneRaw': mobileNumber,
      'phone': (dialCodeVal! + mobileNumber!).trim(),
      "dialCodePhoneList":
      phoneList(phone: mobileNumber, dialCode: dialCodeVal)
    });

    Get.offAll(() =>  IndexLayout(pref: pref!,));
    final phoneCtrl = Get.isRegistered<PhoneController>()
        ? Get.find<PhoneController>()
        : Get.put(PhoneController());
    phoneCtrl.isOtp = false;
appCtrl.dialCode = dialCodeVal.toString();
appCtrl.storage.write("dialCode", dialCodeVal);
    phoneCtrl.update();
  }

  //show toast
  void showToast(message, Color color) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: color,
        textColor: appCtrl.appTheme.white,
        fontSize: 16.0);
  }

  //on verify code
  void onVerifyCode(phone, dialCode)async {
    mobileNumber = phone;
    dialCodeVal = dialCode;
    isCodeSent = true;
    log("dialCode : $dialCode");
    log("dialCode : $mobileNumber");
    isLoading = true;
    update();

    //   Change country code
verificationCompleted(PhoneAuthCredential phoneAuthCredential) async {}

    verificationFailed(FirebaseAuthException authException) {
      showToast(authException.message, appCtrl.appTheme.redColor);
      isCodeSent = false;
      update();
    }

    codeSent(String verificationId, [int? forceResendingToken]) async {
      verificationCode = verificationId;
      log("codeSent : $verificationCode");
      startTimer();
      update();
    }

    codeAutoRetrievalTimeout(String verificationId) {
      verificationCode = verificationId;
      update();
      log("codeAutoRetrievalTimeout : $verificationCode");
    }

// Change country code

    firebaseAuth.verifyPhoneNumber(
        phoneNumber: "$dialCode$mobileNumber",
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);

  /*  FirebaseAuth auth = FirebaseAuth.instance;
     result = await auth.signInWithPhoneNumber("$dialCode$mobileNumber");*/
    isLoading = false;/*
    print("OTP Sent to $dialCode$mobileNumber");
    print("OTP Sent to ${result!.verificationId}");
    print("OTP Sent to ${result!.confirm(result!.verificationId)}");*/
    update();
  }

  //on form submit
  void onFormSubmitted() async {
    dismissKeyboard();
    isLoading = true;
    update();

    log("verificationCode : $verificationCode");
    log("verificationCode : $dialCodeVal");
    PhoneAuthCredential authCredential = PhoneAuthProvider.credential(
        verificationId: verificationCode!, smsCode: otp.text);
/*
    UserCredential value = await result!.confirm(otp.text);
    log("userCred : $value");
    if (value.user != null) {
      User user = value.user!;
      try {
        FirebaseFirestore.instance
            .collection(collectionName.users)
            .where("phone", isEqualTo: "$dialCodeVal$mobileNumber")
            .limit(1)
            .get()
            .then((value) async {
          log("value : ${value.docs.length}");
          if (value.docs.isNotEmpty) {
            await appCtrl.storage.write(session.user, value.docs[0].data());
            appCtrl.user = value.docs[0].data();
            if (value.docs[0].data()["name"] == "") {
              Get.offAll(() =>  IndexLayout(pref: pref));
              final indexCtrl = Get.isRegistered<IndexController>()
                  ? Get.find<IndexController>()
                  : Get.put(IndexController());
              indexCtrl.drawerIndex.value = !indexCtrl.drawerIndex.value;
              indexCtrl.update();
              indexCtrl.drawerIndex.value = !indexCtrl.drawerIndex.value;
              indexCtrl.update();
              await appCtrl.storage.write(session.isIntro, true);
              Get.forceAppUpdate();
              html.window.localStorage[session.isLogin] = "true";
              await appCtrl.storage.write(session.isLogin, true);

              appCtrl.isLogged = true;
            } else {
              await appCtrl.storage.write(session.user, value.docs[0].data());
              homeNavigation(value.docs[0].data());
            }
          } else {
            log("check1 : ${value.docs.isEmpty}");
            await userRegister(user);
            dynamic resultData = await getUserData(user);
            await appCtrl.storage.write(session.user, resultData);
            appCtrl.user = resultData;
            if (resultData["name"] == "") {
              Get.offAll(() => const IndexLayout());
              final indexCtrl = Get.isRegistered<IndexController>()
                  ? Get.find<IndexController>()
                  : Get.put(IndexController());
              indexCtrl.drawerIndex.value = !indexCtrl.drawerIndex.value;
              indexCtrl.update();
              indexCtrl.drawerIndex.value = !indexCtrl.drawerIndex.value;
              indexCtrl.update();
              await appCtrl.storage.write(session.isIntro, true);
              Get.forceAppUpdate();
              html.window.localStorage[session.isLogin] = "true";
              await appCtrl.storage.write(session.isLogin, true);

              appCtrl.isLogged = true;
            } else {
              await appCtrl.storage.write(session.user, resultData);
              homeNavigation(resultData);
            }
          }
          isLoading = false;
          update();
        }).catchError((err) {
          log("get : $err");
        });
      } on FirebaseAuthException catch (e) {
        log("get firebase : $e");
      }
    } else {
      isLoading = false;
      update();
      showToast(appFonts.otpError.tr, appCtrl.appTheme.redColor);
    }
 */   firebaseAuth
        .signInWithCredential(authCredential)
        .then((UserCredential value) async {
      log("userCred : $value");
      if (value.user != null) {
        User user = value.user!;
        try {
          FirebaseFirestore.instance
              .collection(collectionName.users)
              .where("phone", isEqualTo: "$dialCodeVal$mobileNumber")
              .limit(1)
              .get()
              .then((value) async {
            log("value : ${value.docs.length}");
            if (value.docs.isNotEmpty) {
              await appCtrl.storage.write(session.user, value.docs[0].data());
              appCtrl.user = value.docs[0].data();
              if (value.docs[0].data()["name"] == "") {
                Get.offAll(() =>  IndexLayout(pref: pref));
                final indexCtrl = Get.isRegistered<IndexController>()
                    ? Get.find<IndexController>()
                    : Get.put(IndexController());
                indexCtrl.drawerIndex.value = !indexCtrl.drawerIndex.value;
                indexCtrl.update();
                indexCtrl.drawerIndex.value = !indexCtrl.drawerIndex.value;
                indexCtrl.update();
                await appCtrl.storage.write(session.isIntro, true);
                Get.forceAppUpdate();
                html.window.localStorage[session.isLogin] = "true";
                await appCtrl.storage.write(session.isLogin, true);

                appCtrl.isLogged = true;
              } else {
                await appCtrl.storage.write(session.user, value.docs[0].data());
                homeNavigation(value.docs[0].data());
              }
            } else {
              log("check1 : ${value.docs.isEmpty}");
              await userRegister(user);
              dynamic resultData = await getUserData(user);
              await appCtrl.storage.write(session.user, resultData);
              appCtrl.user = resultData;
              if (resultData["name"] == "") {
                Get.offAll(() => const IndexLayout());
                final indexCtrl = Get.isRegistered<IndexController>()
                    ? Get.find<IndexController>()
                    : Get.put(IndexController());
                indexCtrl.drawerIndex.value = !indexCtrl.drawerIndex.value;
                indexCtrl.update();
                indexCtrl.drawerIndex.value = !indexCtrl.drawerIndex.value;
                indexCtrl.update();
                await appCtrl.storage.write(session.isIntro, true);
                Get.forceAppUpdate();
                html.window.localStorage[session.isLogin] = "true";
                await appCtrl.storage.write(session.isLogin, true);

                appCtrl.isLogged = true;
              } else {
                await appCtrl.storage.write(session.user, resultData);
                homeNavigation(resultData);
              }
            }
            isLoading = false;
            update();
          }).catchError((err) {
            log("get : $err");
          });
        } on FirebaseAuthException catch (e) {
          log("get firebase : $e");
        }
      } else {
        isLoading = false;
        update();
        showToast(appFonts.otpError.tr, appCtrl.appTheme.redColor);
      }
    }).catchError((error) {
      isLoading = false;
      update();
      log("err : ${error.toString()}");
      showToast(error.toString(), appCtrl.appTheme.redColor);
    });
  }

  //get data
  Future<Object?> getUserData(User user) async {
    final result = await FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(user.uid)
        .get();
    dynamic resultData;
    if (result.exists) {
      Map<String, dynamic>? data = result.data();
      resultData = data;
      return resultData;
    }
    return resultData;
  }

  //user register
  userRegister(User user) async {
    log(" : $user");
    try {
      final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
      firebaseMessaging
          .getToken(
              vapidKey:
                  "BBKJYiUfPDUN3LBUhj_FrePobiElc6t1Wvl-usFvvKCdbr08xY4WKCZYs6VrHf1upTFVT0Fa8gWqenytBYcLeRs")
          .then((token) async {
        await FirebaseFirestore.instance
            .collection(collectionName.users)
            .doc(user.uid)
            .set({
          'chattingWith': null,
          'id': user.uid,
          'image': user.photoURL ?? "",
          'name': user.displayName ?? "",
          'pushToken': token,
          'status': "Offline",
          "typeStatus": "Offline",
          "phoneRaw": mobileNumber,
          "email": user.email,
          "deviceName": appCtrl.deviceName,
          "phone": (dialCodeVal! + mobileNumber!).trim(),
          "dialCodePhoneList":
          phoneList(phone: mobileNumber, dialCode: dialCodeVal),
          "isActive": true,
          "device": appCtrl.device,
          "statusDesc": "Hello, I am using Chatter"
        }).catchError((err) {
          log("fir : $err");
        });
      });
    } on FirebaseAuthException catch (e) {
      log("firebase : $e");
    }
  }
}
