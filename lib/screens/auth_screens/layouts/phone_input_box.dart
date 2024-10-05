import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../../../config.dart';
import '../../../controllers/auth_controller/phone_controller.dart';

class PhoneInputBox extends StatelessWidget {
  const PhoneInputBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PhoneController>(builder: (phoneCtrl) {
      return Row(
        children: [
          Theme(
              data: ThemeData(
                  dialogTheme:
                      DialogTheme(backgroundColor: appCtrl.appTheme.white)),
              child: Expanded(
                  child: InternationalPhoneNumberInput(
                      textStyle: AppCss.manropeMedium16
                          .textColor(appCtrl.appTheme.txt),
                      onInputChanged: (PhoneNumber number) {
                        phoneCtrl.dialCode = number.dialCode!;
                        phoneCtrl.update();
                        if (number.phoneNumber!.isNotEmpty) {
                          phoneCtrl.mobileNumber = false;
                        }
                        phoneCtrl.update();
                      },
                      validator: (val){
                        if(val!.isEmpty){
                          return appFonts.phoneError.tr;
                        }else{
                          return null;
                        }
                      },
                      onInputValidated: (bool value) {
                        phoneCtrl.isCorrect = value;
                        phoneCtrl.update();
                        if (phoneCtrl.isCorrect) {
                          phoneCtrl.dismissKeyboard();
                        }
                      },
                      selectorConfig: const SelectorConfig(
                          leadingPadding: 0,
                          trailingSpace: false,
                          selectorType: PhoneInputSelectorType.BOTTOM_SHEET),
                      selectorButtonOnErrorPadding: 0,
                      ignoreBlank: false,
                      autoValidateMode: AutovalidateMode.disabled,
                      selectorTextStyle: TextStyle(color: appCtrl.appTheme.txt),
                      initialValue: phoneCtrl.number,
                      textFieldController: phoneCtrl.phone,
                      scrollPadding: EdgeInsets.zero,
                      formatInput: false,
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      inputBorder: const OutlineInputBorder(
                          borderSide: BorderSide.none, gapPadding: 0),
                      onSaved: (PhoneNumber number) {}))),
        ],
      ).paddingSymmetric(horizontal: Insets.i15).decorated(
          border: Border(
              bottom: BorderSide(
                  color: appCtrl.isTheme
                      ? appCtrl.appTheme.white
                      : appCtrl.appTheme.primary)));
    });
  }
}
