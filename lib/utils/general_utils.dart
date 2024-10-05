import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'package:chatzy_web/utils/type_list.dart';
import 'package:encrypt/encrypt.dart' as encrypted;
import 'package:encrypt/encrypt.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../config.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

import '../main.dart';

var loadingCtrl = Get.find<AppController>();

String trans(String val) {
  if (val.isNotEmpty) {
    return val.tr;
  }
  return val;
}


List phoneList({
  String? phone,
  String? dialCode,
}) {
  List list = [
    '+${dialCode!.substring(1)}$phone',
    '+${dialCode.substring(1)}-$phone',
    '${dialCode.substring(1)}-$phone',
    '${dialCode.substring(1)}$phone',
    '0${dialCode.substring(1)}$phone',
    '0$phone',
    '$phone',
    '+$phone',
    '+${dialCode.substring(1)}--$phone',
    '00$phone',
    '00${dialCode.substring(1)}$phone',
    '+${dialCode.substring(1)}-0$phone',
    '+${dialCode.substring(1)}0$phone',
    '${dialCode.substring(1)}0$phone',
  ];
  return list;
}


List arrayFilter(List val) {
  if (val.isNotEmpty) {
    List newArray = [];
    for (int i = 0; i < val.length; i++) {
      if (val[i] != null) {
        newArray.add(val[i]);
      }
    }
    return newArray;
  } else {
    return [];
  }

  //ex : helper.array_filter(data);
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() =>
      replaceAll(RegExp(' +'), ' ')
          .split(' ')
          .map((str) => str.toCapitalized())
          .join(' ');
}

//phone number split
String phoneNumberExtension(phoneNumber) {
  String phone = phoneNumber;
  if (phone.length > 10) {
    if (phone.contains(" ")) {
      phone = phone.replaceAll(" ", "");
    }
    if (phone.contains(" ")) {
      phone = phone.replaceAll("  ", "");
    }
  }
  return phone;
}

const double degrees2Radians = math.pi / 180.0;

/// Constant factor to convert and angle from radians to degrees.
const double radians2Degrees = 180.0 / math.pi;

/// Convert [radians] to degrees.
double degrees(double radians) => radians * radians2Degrees;

/// Convert [degrees] to radians.
double radians(double degrees) => degrees * degrees2Radians;

/// Interpolate between [min] and [max] with the amount of [a] using a linear
/// interpolation. The computation is equivalent to the GLSL function mix.
double mix(double min, double max, double a) => min + a * (max - min);

/// Do a smooth step (hermite interpolation) interpolation with [edge0] and
/// [edge1] by [amount]. The computation is equivalent to the GLSL function
/// smoothstep.
double smoothStep(double edge0, double edge1, double amount) {
  final t = ((amount - edge0) / (edge1 - edge0)).clamp(0.0, 1.0).toDouble();

  return t * t * (3.0 - 2.0 * t);
}

//learning dashboard bottom nav bar size
const double alphaOff = 0;
const double alphaOn = 1;
const int animDuration = 300;


String formatBytes(int bytes, int decimals) {
  if (bytes <= 0) {
    return '0 B';
  }
  const List<String> suffixes = <String>[
    'B',
    'KB',
    'MB',
    'GB',
    'TB',
    'PB',
    'EB',
    'ZB',
  ];
  final int i = (math.log(bytes / 100) / math.log(1024)).floor();
  return '${(bytes / math.pow(1024, i)).toStringAsFixed(
      decimals)} ${suffixes[i]}';
}


String getVideoSize({required File file}) =>
    formatBytes(file.lengthSync(), 2);


final List colors = [
  const Color(0xffF98BAE),
  const Color(0xff72CCCF),
  const Color(0xffF4ABC4),
  const Color(0xff346751),
  const Color(0xffFFC947),
  const Color(0xff3282B8),
];

int getUnseenMessagesNumber(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> items) {
  int counter = 0;
  items.asMap().entries.forEach((element) {
    if (!element.value.data()["isSeen"]) {
      counter++;
    }
  });
  return counter;
}

phoneNumberVariantsList({
  String? phone,
  String countryCode ="",
}) {
  bool isNumberContains =false;
  log("countryCode : $countryCode");
  List list =[];
  if(countryCode != "") {
    list = [
      '+${countryCode.substring(1)}$phone',
      '+${countryCode.substring(1)}-$phone',
      '${countryCode.substring(1)}-$phone',
      '${countryCode.substring(1)}$phone',
      '0${countryCode.substring(1)}$phone',
      '0$phone',
      '$phone',
      '+$phone',
      '+${countryCode.substring(1)}--$phone',
      '00$phone',
      '00${countryCode.substring(1)}$phone',
      '+${countryCode.substring(1)}-0$phone',
      '+${countryCode.substring(1)}0$phone',
      '${countryCode.substring(1)}0$phone',
    ];
  }else{
    list = [
      '+$phone',
      '+-$phone',
      '-$phone',
      '$phone',
      '0$phone',
      '$phone',
      '+--$phone',
      '00$phone',
      '+-0$phone',
      '+0$phone',
    ];
  }

  isNumberContains = list.where((element) => element == phone).isEmpty;

  return isNumberContains;
}

int getGroupUnseenMessagesNumber(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> items) {
  int counter = 0;
  items
      .asMap()
      .entries
      .forEach((element) {
    if(element.value.data().containsKey("seenMessageList")) {
      if (!element.value.data()["seenMessageList"].contains(appCtrl.user["id"])) {
        counter++;
      }
    }
  });
  return counter;
}


int getUnseenAllMessagesNumber(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> items) {
  int counter = 0;
  items
      .asMap()
      .entries
      .forEach((element) {
    if(element.value.data()["senderId"] != appCtrl.user["id"]) {
      if (element.value.data()["isOneToOne"] == true) {
        if (!element.value.data()["isSeen"]) {
          counter++;
        }
      } else if (element.value.data()["isGroup"] == true) {
        if (element.value.data().containsKey("seenMessageList")) {
          if (element.value.data()["seenMessageList"].contains(
              appCtrl.user["id"])) {
            counter++;
          }
        }
      }
    }
  });
  return counter;
}



bool checkUserExist(phone) {
  bool isExist = false;
  log("{userContactList.length: ${appCtrl.userContactList.length}");
  var contain = appCtrl.userContactList.where((element) {
    return element.phone != null ? phoneNumberExtension(
        element.phone.toString()) == phone : false;
  });
  if (contain.isNotEmpty) {
    isExist = true;
  } else {
    isExist = false;
  }
  return isExist;
}


typedef StringCallback = void Function(String);
typedef IntCallback = void Function(int);
typedef VoidCallBack = void Function();
typedef DoubleCallBack = void Function(double, double);
typedef VoidCallBackWithFuture = Future<void> Function();
typedef StringsCallBack = void Function(String emoji, String messageId);
typedef StringWithReturnWidget = Widget Function(String separator);
typedef DragUpdateDetailsCallback = void Function(DragUpdateDetails);

const String heart = "❤";
const String faceWithTears = "😂";
const String disappointedFace = "😥";
const String angryFace = "😡";
const String astonishedFace = "😲";
const String thumbsUp = "👍";



decryptMessage(content) {
  String decryptedText = decrypt(content);
  return decryptedText;
}

String decrypt(encryptedData) {
  final key = encrypted.Key.fromUtf8(encryptedKey);
  final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
  final initVector = IV.fromUtf8(encryptedKey.substring(0, 16));
  return encrypter.decrypt(Encrypted.fromBase64(encryptedData), iv: initVector);
}

Encrypted encryptFun(String plainText) {
  final key = encrypted.Key.fromUtf8(encryptedKey);
  final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
  final initVector = IV.fromUtf8(encryptedKey.substring(0, 16));
  Encrypted encryptedData = encrypter.encrypt(plainText, iv: initVector);
  return encryptedData;
}
linkCondition(document) {
  bool contentType = (decryptMessage(document!.content).contains("youtube") ||
      decryptMessage(document!.content).contains("youtu.be") ||
      decryptMessage(document!.content).contains("instagram.com") ||
      decryptMessage(document!.content).contains("fb.watch"));

  return contentType;
}

getDate(date) {
  // log("DATE : $date");
  DateTime now = DateTime.now();
  String when;
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(date));
  if (dateTime.day == now.day) {
    when = 'Today';
  } else if (dateTime.day == now.subtract(const Duration(days: 1)).day) {
    when = 'yesterday';
  } else {
    when = "${DateFormat.MMMd().format(dateTime)}-other";
  }
  return when;
}

getWhen(date) {
  // log("DATE : $date");
  DateTime now = DateTime.now();
  String when;
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(date));
  if (dateTime.day == now.day) {
    when = 'today';
  } else if (dateTime.day == now.subtract(const Duration(days: 1)).day) {
    when = 'yesterday';
  } else {
    when = "${DateFormat.MMMd().format(dateTime)}-other";
  }
  return when;
}

String messageTypeCondition(MessageType type, content) {
  if (type == MessageType.image ) {
    return "\u{1F4F8} Photo";
  } else if (type == MessageType.video) {
    return "\u{1F3A5} Video";
  } else if (type == MessageType.audio) {
    return "\u{1F3A4} Audio";
  } else if (type == MessageType.doc) {
    return "\u{1f4c4} Document";
  } else if (type == MessageType.location) {
    return "\u{1F4CD} Location";
  } else if (type == MessageType.link) {
    return "\u{1F517} Link";
  } else if (type == MessageType.contact) {
    return "\u{1F464} ${content.toString().split("-BREAK-")[0]}";
  } else if (type == MessageType.gif) {
    return "\u{1F47E} GIF";
  } else {
    return content;
  }
}

String groupMessageTypeCondition(MessageType type, content) {
  if (type == MessageType.image ) {
    return "${appCtrl.user["name"]} shared \u{1F4F8} Photo";
  } else if (type == MessageType.video) {
    return "${appCtrl.user["name"]} shared \u{1F3A5} Video";
  } else if (type == MessageType.audio) {
    return "${appCtrl.user["name"]} shared \u{1F3A4} Audio";
  } else if (type == MessageType.doc) {
    return "${appCtrl.user["name"]} shared \u{1f4c4} Document";
  } else if (type == MessageType.location) {
    return "${appCtrl.user["name"]} shared \u{1F4CD} Location";
  } else if (type == MessageType.link) {
    return "${appCtrl.user["name"]} shared \u{1F517} Link";
  } else if (type == MessageType.contact) {
    return "${appCtrl.user["name"]} shared \u{1F464} ${content.toString().split("-BREAK-")[0]}";
  } else if (type == MessageType.gif) {
    return "${appCtrl.user["name"]} shared \u{1F47E} GIF";
  } else {
    return content;
  }
}

openUploadDialog(
    {required BuildContext context,
      double? percent,
      required String title,
      required String subtitle}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      CircularPercentIndicator(
        radius: 25.0,
        lineWidth: 4.0,
        percent: percent ?? 0.0,
        center:  Text(
          percent == null ? '0%' : "${(percent * 100).roundToDouble()}%",
          style: TextStyle(fontSize: 11,color: appCtrl.appTheme.black),
        ),
        progressColor: Colors.green[400],
      ),
      Container(
        width: 195,
        padding: EdgeInsets.only(left: 3),
        child: ListTile(
          dense: false,
          title: Text(
            title,
            textAlign: TextAlign.left,
            style: TextStyle(
                height: 1.3, fontWeight: FontWeight.w600, fontSize: 14,color: appCtrl.appTheme.black),
          ),
          subtitle: Text(
            subtitle,
            textAlign: TextAlign.left,
            style: TextStyle(height: 2.2, color:appCtrl.appTheme.black ),
          ),
        ),
      ),
    ],
  );
}


double bytesTransferred(TaskSnapshot snapshot) {
  double res = snapshot.bytesTransferred / 1024.0;
  double res2 = snapshot.totalBytes / 1024.0;
  // print('${((res / res2) * 100).roundToDouble().toString()} %');
  return ((res / res2) * 100).roundToDouble();
}