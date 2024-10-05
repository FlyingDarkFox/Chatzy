
import 'package:get/get_navigation/src/root/internacionalization.dart';
import 'ar.dart';
import 'en.dart';
import 'hi.dart';
import 'kr.dart';

class Language extends Translations {
  // TODO: implement keys
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': en,
        'hi_IN': hi,
        'ar_AE': ar,
        'ko_KR': kr,
      };
}



