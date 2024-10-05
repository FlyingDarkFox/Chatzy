import 'package:chatzy_web/screens/auth_screens/layouts/login_class.dart';
import 'package:chatzy_web/widgets/button_common.dart';
import 'package:flutter/gestures.dart';


import '../../../../config.dart';
import '../../../controllers/auth_controller/otp_controller.dart';
import '../../../controllers/auth_controller/phone_controller.dart';
import '../../../widgets/dotted_line.dart';
import 'otp_input.dart';

class OtpBodyLayout extends StatelessWidget {
final String? phone,dialCode;
  const OtpBodyLayout({Key? key,this.dialCode,this.phone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OtpController>(
        builder: (otpCtrl) {
          String strDigits(int n) => n.toString().padLeft(2, '0');
          final seconds = strDigits(otpCtrl.myDuration.inSeconds.remainder(60));
         /* return Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoginCommonClass().logoLayout(image: eImageAssets.appLogo),
                  const VSpace(Sizes.s30),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    FittedBox(
                        child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                                text: "Welcome Back ",
                                style: AppCss.manropeMedium22
                                    .textColor(appCtrl.appTheme.black),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: "chatify!",
                                      style: AppCss.manropeMedium22
                                          .textColor(appCtrl.appTheme.primary))
                                ]))),
                    const VSpace(Sizes.s8),
                    Text("OTP Verification!",
                        textAlign: TextAlign.center,
                        style: AppCss.manropeLight16
                            .textColor(appCtrl.appTheme.txt))
                  ])
                      .paddingOnly(left: Insets.i12)
                      .border(left: 3, color: appCtrl.appTheme.primary),
                  const VSpace(Sizes.s40),
                  LoginCommonClass().titleLayout(title: "Enter Code From SMS"),
                  const VSpace(Sizes.s10),
                  const OtpInput(),
                  const VSpace(Sizes.s18),
                  Text("Enter SMS code sent to - ${otpCtrl.dialCodeVal} ${otpCtrl.mobileNumber}",
                      textAlign: TextAlign.center,
                      style:
                      AppCss.manropeLight14.textColor(appCtrl.appTheme.txt)).alignment(Alignment.center),
                  const VSpace(Sizes.s70),
                  ButtonCommon( title: "Verify",
                      margin: 0,
                      onTap: () => otpCtrl.onFormSubmitted(),
                      padding: 0,

                      style:
                      AppCss.manropeMedium14.textColor(appCtrl.appTheme.white))
                 ,
                  const VSpace(Sizes.s20),

                  Align(
                    alignment: Alignment.center,
                    child: RichText(
                        textAlign: TextAlign.center,

                        text: TextSpan(
                            text: "Your OTP will expire after ",
                            recognizer:  TapGestureRecognizer()
                              ..onTap = () { otpCtrl.onVerifyCode(phone, dialCode);
                              },
                            style: AppCss.manropeMedium16
                                .textColor(appCtrl.appTheme.txt),
                            children: <TextSpan>[
                              TextSpan(
                                  text: seconds,
                                  style: AppCss.manropeMedium16
                                      .textColor(appCtrl.appTheme.primary)),
                              TextSpan(
                                  text: " seconds",
                                  style: AppCss.manropeMedium16
                                      .textColor(appCtrl.appTheme.txt))
                            ])),
                  ),
                  const VSpace(Sizes.s15),

                ],
              ),
              Text("Back To SignIn Screen",textAlign: TextAlign.center,style: AppCss.manropeMedium18.textColor(appCtrl.appTheme.black),).inkWell(
                  onTap: (){
                    final phoneCtrl = Get.isRegistered<PhoneController>()
                        ? Get.find<PhoneController>()
                        : Get.put(PhoneController());
                    phoneCtrl.isOtp = false;
                    phoneCtrl.update();
                  }
              )
            ],
          );*/
          return   Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
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
                LoginCommonClass().titleLayout(title: appFonts.enterCode.tr),
                const VSpace(Sizes.s10),
                //  const PhoneInputBox(),
                const OtpInput(),
                const VSpace(Sizes.s18),
                Text("${appFonts.enterSmsCodeSendTo.tr} ${otpCtrl.dialCodeVal} ${otpCtrl.mobileNumber}",
                    textAlign: TextAlign.center,
                    style:
                    AppCss.manropeLight14.textColor(appCtrl.appTheme.txt)).alignment(Alignment.center),
                const VSpace(Sizes.s70),

                ButtonCommon(
                    title: appFonts.verify.tr,
                    margin: 0,
                    onTap: () => otpCtrl.onFormSubmitted(),
                    padding: 0,
                    style:GoogleFonts.manrope(
                        fontSize: Sizes.s16,
                        color: appCtrl.appTheme.sameWhite,
                        fontWeight: FontWeight.w500,
                        letterSpacing: .5
                    )),

                const VSpace(Sizes.s15),
                if(otpCtrl.verificationCode != null)
                  RichText(
                      textAlign: TextAlign.center,

                      text: TextSpan(
                          text: "Your OTP will expire after ",
                          recognizer:  TapGestureRecognizer()
                            ..onTap = () { otpCtrl.onVerifyCode(phone, dialCode);
                            },
                          style: AppCss.manropeMedium16
                              .textColor(appCtrl.appTheme.darkText),
                          children: <TextSpan>[
                            TextSpan(
                                text: seconds,
                                style: AppCss.manropeMedium16
                                    .textColor(appCtrl.appTheme.primary)),
                            TextSpan(
                                text: " seconds",
                                style: AppCss.manropeMedium16
                                    .textColor(appCtrl.appTheme.darkText))
                          ])),
                if(otpCtrl.verificationCode == null)
                  RichText(
                      overflow: TextOverflow.clip,
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text: appFonts.notReceived.tr,
                          style:
                          AppCss.manropeSemiBold13
                              .textColor(
                              appCtrl.appTheme.greyText)
                              .textHeight(1.3),
                          children: [
                            TextSpan(
                                text: appFonts.resendIt.tr,
                                style: AppCss.manropeSemiBold13
                                    .textColor(
                                    appCtrl.appTheme.darkText)
                                    .textHeight(1.3))
                          ]))
                      .alignment(Alignment.center)
                      .inkWell(onTap: () => otpCtrl.resendCode()).paddingSymmetric(
                    horizontal: Responsive.isMobile(context) ?  Insets.i20 : Insets.i50,
                  ),


              ],
            ).paddingSymmetric(
              horizontal: Responsive.isMobile(context) ?  Insets.i20 : Insets.i50,
            ),
            DottedLines(color: appCtrl.appTheme.greyText.withOpacity(0.4)).paddingSymmetric(vertical: Insets.i40),
            Text(appFonts.sendSmsCode.tr,
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: appCtrl.appTheme.greyText
                ))
                .alignment(Alignment.center),
            const VSpace(Sizes.s20),
            Text("Back To SignIn Screen",textAlign: TextAlign.center,style: AppCss.manropeMedium18.textColor(appCtrl.appTheme.darkText),).inkWell(
                onTap: (){
                  final phoneCtrl = Get.isRegistered<PhoneController>()
                      ? Get.find<PhoneController>()
                      : Get.put(PhoneController());
                  phoneCtrl.isOtp = false;
                  phoneCtrl.update();
                }
            ),
            const VSpace(Sizes.s30),
          ]);
        }
    );
  }
}
