import 'dart:developer';

import 'package:chatzy_web/screens/auth_screens/layouts/login_body_layout.dart';

import '../../../../config.dart';
import '../../../responsive.dart';
import 'login_class.dart';

class LoginLayout extends StatelessWidget {
  const LoginLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log("WIDTH : ${MediaQuery.of(context).size.width}");
    return LayoutBuilder(
        builder: (context, constraints) {
        return LoginCommonClass().loginBody(
            child: Container(
                width: Responsive.isMobile(context)
                    ? MediaQuery.of(context).size.width
                    :  Responsive.isTablet(context) ? MediaQuery.of(context).size.width  :  MediaQuery.of(context).size.width / (constraints.maxWidth < 770? 3:4),

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
                child: const SingleChildScrollView(child: LoginBodyLayout())));
      }
    );
  }
}
