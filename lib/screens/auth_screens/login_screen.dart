


import 'package:chatzy_web/screens/auth_screens/layouts/otp_layout.dart';

import '../../config.dart';
import '../../responsive.dart';
import 'layouts/glass_morphic_layout.dart';
import 'layouts/login_layout.dart';
import 'layouts/login_left_desktop_view.dart';

class LoginScreen extends StatelessWidget {
  final SharedPreferences? pref;
  final loginCtrl = Get.put(PhoneController());

  LoginScreen({Key? key,this.pref}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PhoneController>(builder: (_) {
      loginCtrl.pref = pref;
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Builder(builder: (context) {
          return Scaffold(
              backgroundColor: appCtrl.appTheme.bg,
              body: SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (Responsive.isDesktop(context))
                        const LoginLeftDesktopView(),
                      Expanded(
                        child: GlassMorphicLayout(

                            child: SingleChildScrollView(
                              child: Column(children:  [


                                loginCtrl.isOtp ? OtpLayout(phone: loginCtrl.phone.text,dialCode: loginCtrl.dialCode,) :const LoginLayout(),

                              ]),
                            )),
                      )
                    ],
                  ),
                ),
              ));
        }),
      );
    });
  }
}
