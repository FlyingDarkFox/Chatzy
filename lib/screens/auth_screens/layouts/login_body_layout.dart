import 'dart:developer';
import 'package:chatzy_web/screens/auth_screens/layouts/country_list.dart';
import 'package:chatzy_web/screens/auth_screens/layouts/login_class.dart';
import 'package:country_list_pick/support/code_country.dart';


import '../../../../config.dart';
import '../../../widgets/dotted_line.dart';

class LoginBodyLayout extends StatelessWidget {
  const LoginBodyLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PhoneController>(builder: (loginCtrl) {
      return Form(
          key: loginCtrl.formKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Column(
              children: [
                LoginCommonClass().logoLayout(image: eImageAssets.appLogo),
                const VSpace(Sizes.s15),
                FittedBox(
                    child: RichText(
                        textAlign: TextAlign.center,
                        text: Responsive.isMobile(context)
                            ? TextSpan(
                                text: appFonts.welcomeBack.tr,
                                /*   style: MediaQuery.of(context).size.width < 1140
                            ? AppCss.manropeSemiBold14
                            .textColor(appCtrl.appTheme.black)
                            : AppCss.manropeSemiBold26
                            .textColor(appCtrl.appTheme.black)*/
                                style: TextStyle(
                                    fontFamily:
                                        GoogleFonts.manrope().fontFamily,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 2,
                                    color: appCtrl.appTheme.txt,
                                    fontSize:
                                        MediaQuery.of(context).size.width < 1140
                                            ? 14
                                            : 26),
                                children: <TextSpan>[
                                    TextSpan(
                                        text:
                                            " ${appFonts.chatzy.tr.toLowerCase()} !",
                                        style: TextStyle(
                                            fontFamily: GoogleFonts.manrope()
                                                .fontFamily,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 2,
                                            color: appCtrl.appTheme.primary,
                                            fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width <
                                                    1140
                                                ? 14
                                                : 26))
                                  ])
                            : TextSpan(
                                text: appFonts.welcomeBack.tr,
                                style: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: .5,
                                    color: appCtrl.appTheme.txt,
                                    fontSize:
                                        MediaQuery.of(context).size.width < 1140
                                            ? 12
                                            : 26),
                                children: <TextSpan>[
                                    TextSpan(
                                        text:
                                            " ${appFonts.chatzy.tr.toLowerCase()} !",
                                        style: TextStyle(
                                            fontFamily: GoogleFonts.manrope()
                                                .fontFamily,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 2,
                                            color: appCtrl.appTheme.primary,
                                            fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width <
                                                    1140
                                                ? 12
                                                : 26))
                                  ]))),
              ],
            ).paddingOnly(
              left: Responsive.isMobile(context) ? Insets.i20 : Insets.i50,
              right: Responsive.isMobile(context) ?  Insets.i20 : Insets.i50,
              top: Responsive.isMobile(context) ?  Insets.i20 : Insets.i50,
            ),
            Text(appFonts.subtitle.tr,
                textAlign: TextAlign.center,
                style: AppCss.manropeLight14
                    .textColor(appCtrl.appTheme.greyText)
                    .textHeight(1.4)),
                const VSpace(Sizes.s40),
            Column(
              children: [
                LoginCommonClass().titleLayout(title: appFonts.mobileNumber.tr),
                const VSpace(Sizes.s10),
                //  const PhoneInputBox(),
                IntrinsicHeight(
                  child: Row(children: [
                    CountryListLayout(
                      onChanged: (CountryCode? code) {
                        log("CODE : $code");
                        loginCtrl.dialCode = code.toString();
                        loginCtrl.update();
                      },
                      dialCode: loginCtrl.dialCode,
                    ),
                    const HSpace(Sizes.s10),
                    Expanded(
                        child: TextFieldCommon(vertical: Insets.i21,
                            keyboardType: TextInputType.number,
                            validator: (phone) => Validation()
                                .phoneValidation(phone),
                            controller:
                            loginCtrl.phone,
                            hintText: appFonts.enterNumber.tr))
                   /*  Expanded(
                    child: CommonTextBox(
                        keyboardType: TextInputType.number,
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(AppRadius.r8)),
                        controller: loginCtrl.phone,
                        filled: true,
                        hinText: "Enter your mobile number",
                        fillColor: appCtrl.appTheme.txt.withOpacity(.10)))*/
                  ]),
                ),
                const VSpace(Sizes.s10),
                if (loginCtrl.mobileNumber)
                  AnimatedOpacity(
                      duration: const Duration(seconds: 3),
                      opacity: loginCtrl.mobileNumber ? 1.0 : 0.0,
                      child: Text(appFonts.phoneError.tr,
                              style: AppCss.manropeMedium12
                                  .textColor(appCtrl.appTheme.redColor))
                          .alignment(Alignment.centerRight)),
                const VSpace(Sizes.s30),

                ButtonCommon(
                    title: appFonts.sendVerificationCode.tr,
                    margin: 0,
                    onTap: () => loginCtrl.checkValidation(),
                    padding: 0,
                    style:GoogleFonts.manrope(
                      fontSize: Sizes.s16,
                      color: appCtrl.appTheme.sameWhite,
                      fontWeight: FontWeight.w500,
                      letterSpacing: .5
                    )),

                const VSpace(Sizes.s15),
                Text(appFonts.sendSmsCode.tr,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.manrope(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: appCtrl.appTheme.greyText
                        ))
                    .alignment(Alignment.center),

              ],
            ).paddingSymmetric(
              horizontal: Responsive.isMobile(context) ?  Insets.i20 : Insets.i50,
            ),
                DottedLines(color: appCtrl.appTheme.greyText.withOpacity(0.4)).paddingSymmetric(vertical: Insets.i40),

                RichText(
                    text: TextSpan(
                        text: "NOTE : ",
                        style: AppCss.manropeblack14
                            .textColor(appCtrl.appTheme.redColor)
                            .textHeight(1.5),
                        children: [
                          TextSpan(
                              text:
                              "For Mobile Web Access Firstly You Need To Register Your App From Mobile Device For Contact Sync In Web",
                              style: AppCss.manropeBold14
                                  .textColor(appCtrl.appTheme.black)
                                  .textHeight(1.5))
                        ])).paddingSymmetric(
                  horizontal: Responsive.isMobile(context) ?  Insets.i20 : Insets.i50,
                ),
                const VSpace(Sizes.s30),
          ]));
    });
  }
}
