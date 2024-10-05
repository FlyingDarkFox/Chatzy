import 'package:pinput/pinput.dart';

import '../../../../config.dart';

class OtpCommon{

  //default theme
  final defaultPinTheme = PinTheme(
    margin: EdgeInsets.zero,
    width: Sizes.s55,
    height: Sizes.s55,
    padding: EdgeInsets.zero,
    textStyle: const TextStyle(
      fontSize: Sizes.s18,
      color: Color.fromRGBO(30, 60, 87, 1),
    ),
    decoration: BoxDecoration(
        color:appCtrl.appTheme.txt.withOpacity(.10),
      borderRadius: BorderRadius.circular(AppRadius.r8),
      border: Border.all(color:appCtrl.appTheme.txt.withOpacity(.10)),
    ),
  );

  //d

}