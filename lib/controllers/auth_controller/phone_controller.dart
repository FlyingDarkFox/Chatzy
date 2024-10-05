import 'dart:async';
import 'dart:developer';

import 'package:country_list_pick/support/code_countries_en.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

import 'package:universal_html/html.dart' as html;
import 'package:chatzy_web/config.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';


class PhoneController extends GetxController {
  bool mobileNumber = false;
  TextEditingController phone = TextEditingController();
  String dialCode = "";
  bool isCorrect = false;
  SharedPreferences? pref;
  bool visible = false, error = true;
  Timer timer = Timer(const Duration(seconds: 1), () {});
  double val = 0;
  bool displayFront = true;
  bool flipXAxis = true;
  bool isOtp = false;
  final formKey = GlobalKey<FormState>();
  bool showFrontSide = true;
  var otpCtrl = Get.isRegistered<OtpController>()
      ? Get.find<OtpController>()
      : Get.put(OtpController());

  PhoneNumber number = PhoneNumber(isoCode: 'IN');

  // CHECK VALIDATION

  void checkValidation() async {
    if (phone.text.isNotEmpty) {
      if (phone.text == "9612345678") {
        FirebaseFirestore.instance
            .collection(collectionName.users)
            .where("phone", isEqualTo: "${dialCode}9612345678")
            .limit(1)
            .get()
            .then((value) async {
          if (value.docs.isNotEmpty) {
            if (value.docs[0].data()["name"] == "") {
              await appCtrl.storage.write(session.user, value.docs[0].data());
              appCtrl.user = value.docs[0].data();
              Get.offAll(() =>  IndexLayout(pref: pref,));
              final indexCtrl = Get.isRegistered<IndexController>()
                  ? Get.find<IndexController>()
                  : Get.put(IndexController());
              indexCtrl.drawerIndex.value = !indexCtrl.drawerIndex.value;
              indexCtrl.update();
              await appCtrl.storage.write(session.isIntro, true);
              Get.forceAppUpdate();
              html.window.localStorage[session.isLogin] = "true";
              html.window.localStorage[session.id] = value.docs[0].data()['id'];

              await appCtrl.storage.write(session.isLogin, true);

              appCtrl.isLogged = true;
            } else {
              await appCtrl.storage.write(session.user, value.docs[0].data());
              homeNavigation(value.docs[0].data());
            }
           // homeNavigation(value.docs[0].data());
          }
        }).catchError((err) {
          log("get : $err");
        });
      } else {
        dismissKeyboard();
        mobileNumber = false;
        isOtp = true;
        update();
        otpCtrl.pref = pref;
        otpCtrl.update();
        log("DDDD:$dialCode //${phone.text}");
        log("DDDD:$dialCode //${phone.text}");
        otpCtrl.onVerifyCode(phone.text, dialCode);
        /*  Get.to(() => Otp(), transition: Transition.downToUp,
            arguments: phone.text);*/
      }
    } else {
      mobileNumber = true;
    }
    update();
  }

  //navigate to dashboard
  homeNavigation(user) async {
    appCtrl.storage.write(session.id, user["id"]);
    log("HOME : ${user["pushToken"]}");
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
    });

    Get.offAll(() =>  IndexLayout(pref: pref,));
    sendToken(user["pushToken"]);
  }

  sendToken(token) async {
    final data = {
      "notification": {"body": "webLogin", "title": "webLogin"},
      "priority": "high",
      "data": {"alertMessage": 'true'},
      "to": "$token"
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization':
          'key=AAAAZKdZubc:APA91bF11bMvDQsrzA4VEbIrJRZnSlJr_BMWqYN19rn7r4eoasOb8iMhCXd9HQsgO3E4MFHPaD4v8D9EX-wAgVZaoVUZ558WUzU9TFBbXIE6zVhzSLFK16WrDikMaCyDXrWXAcEJA_tW'
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

//   Dismiss KEYBOARD

  void dismissKeyboard() {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
  }

  @override
  void onReady() async {
    // TODO: implement onReady
    await Future.delayed(DurationsClass.ms150);
    visible = true;
    //dismissKeyboard();
    FocusManager.instance.primaryFocus?.unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    final String systemLocales =
    WidgetsBinding.instance.platformDispatcher.locale.countryCode!;
    List country = countriesEnglish;
    int index =
    country.indexWhere((element) => element['code'] == systemLocales);
    dialCode = country[index]['dial_code'];
    log("CODE :$dialCode");

    update();

    super.onReady();
  }
}
