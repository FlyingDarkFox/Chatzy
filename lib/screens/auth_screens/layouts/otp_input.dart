import 'package:chatzy_web/screens/auth_screens/layouts/otp_common_class.dart';

import '../../../../config.dart';
import '../../../controllers/auth_controller/otp_controller.dart';

class OtpInput extends StatelessWidget {
  const OtpInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OtpController>(builder: (otpCtrl) {
      return Pinput(
        controller: otpCtrl.otp,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        focusNode: otpCtrl.focusNode,
        androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsRetrieverApi,
        listenForMultipleSmsOnAndroid: true,
        enableSuggestions: true,
        length: 6,
        defaultPinTheme: OtpCommon().defaultPinTheme,
        hapticFeedbackType: HapticFeedbackType.lightImpact,
        onCompleted: (pin) {

          debugPrint('onCompleted: $pin');
        },
        onChanged: (value) {
          debugPrint('onChanged: $value');
        },

        focusedPinTheme: OtpCommon().defaultPinTheme.copyWith(
            decoration: OtpCommon().defaultPinTheme.decoration!.copyWith(
                borderRadius: BorderRadius.circular(AppRadius.r8),
                border: Border.all(
                    color:appCtrl.appTheme.txt.withOpacity(.10) ))),
        submittedPinTheme: OtpCommon().defaultPinTheme.copyWith(
            decoration: OtpCommon().defaultPinTheme.decoration!.copyWith(
                color:appCtrl.appTheme.txt.withOpacity(.10),
                borderRadius: BorderRadius.circular(AppRadius.r8),
                border: Border.all(
                    color: appCtrl.appTheme.txt.withOpacity(.10)))),
        errorPinTheme: OtpCommon()
            .defaultPinTheme
            .copyBorderWith(border: Border.all(color: appCtrl.appTheme.redColor)),
      );
    });
  }
}
