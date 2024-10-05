
import 'package:chatzy_web/screens/auth_screens/layouts/otp_body_layout.dart';

import '../../../../config.dart';
import '../../../responsive.dart';
import 'login_class.dart';

class OtpLayout extends StatelessWidget {
  final String? phone,dialCode;
  const OtpLayout({Key? key,this.phone,this.dialCode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoginCommonClass().loginBody(
        child: Container(
            width: Responsive.isMobile(context)
                ? MediaQuery.of(context).size.width
                : MediaQuery.of(context).size.width / 4,

            decoration: ShapeDecoration(
                shape: SmoothRectangleBorder(side: BorderSide(color: appCtrl.appTheme.greyText.withOpacity(.20)),
                    borderRadius: SmoothBorderRadius(
                        cornerRadius: 8,cornerSmoothing: .5
                    )
                ),

                /*border: Border.all(
                    color: appCtrl.appTheme.greyText.withOpacity(.20)),*/
                color: appCtrl.appTheme.white,
                shadows: [
                  BoxShadow(
                      color: Color(0xFF4EA0F7).withOpacity(.08),
                      blurRadius: 12,
                      spreadRadius: 2)
                ]),
            child:  SingleChildScrollView(child: OtpBodyLayout(dialCode: dialCode,phone: phone,))));
  }
}
