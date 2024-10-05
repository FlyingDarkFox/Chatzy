import '../../config.dart';

class LanguageController extends GetxController {
  final storage = GetStorage();

  //language selection
  languageSelection(e) async {
    if (e['name'] == "english" ||
        e['name'] == 'अंग्रेजी' ||
        e['name'] == 'انجليزي' ||
        e['name'] == '영어' ||
        e['name'] == 'Anglais') {
      var locale = const Locale("en", 'US');
      Get.updateLocale(locale);
      appCtrl.languageVal = "en";
      storage.write(session.languageCode, "en");
      storage.write(session.countryCode, "US");
    } else if (e['name'] == "arabic" ||
        e['name'] == 'अरबी' ||
        e['name'] == 'عربي' ||
        e['name'] == '아랍어' ||
        e['name'] == 'arabe') {
      var locale = const Locale("ar", 'AE');
      Get.updateLocale(locale);
      appCtrl.languageVal = "ar";
      storage.write(session.languageCode, "ar");
      storage.write(session.countryCode, "AE");
    } else if (e['name'] == "korean" ||
        e['name'] == 'कोरियाई' ||
        e['name'] == 'كوري' ||
        e['name'] == '한국어' ||
        e['name'] == 'coréen') {
      var locale = const Locale("ko", 'KR');
      Get.updateLocale(locale);

      appCtrl.languageVal = "ko";
      storage.write(session.languageCode, "ko");
      storage.write(session.countryCode, "KR");
    } else if (e['name'] == "hindi" ||
        e['name'] == 'हिंदी' ||
        e['name'] == 'هندي' ||
        e['name'] == '힌디어') {
      appCtrl.languageVal = "hi";
      var locale = const Locale("hi", 'IN');
      Get.updateLocale(locale);

      storage.write(session.languageCode, "hi");
      storage.write(session.countryCode, "IN");
    }
    update();
    appCtrl.update();

    Get.forceAppUpdate();

    Get.back();
  }

}
