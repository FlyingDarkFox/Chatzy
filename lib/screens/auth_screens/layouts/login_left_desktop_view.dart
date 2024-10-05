
import 'dart:developer';

import '../../../config.dart';

class LoginLeftDesktopView extends StatelessWidget {
  const LoginLeftDesktopView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: LayoutBuilder(
          builder: (context, constraints) {
log("DHHH :${constraints.minWidth} //${constraints.maxWidth}");
            return  Container(

                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,color: appCtrl.appTheme.primaryLight1,
                child: ListView(

                  children: [
                    Image.asset(
                      eImageAssets.loginBg,
                    fit: BoxFit.fill,
height: constraints.minWidth > 770 ? 600 :550,
width: constraints.minWidth > 770 ? 600 :550,
                    ),

                    Image.asset(
                      eImageAssets.googleBt ,height: 67,

                    ),
                  ],
                ).paddingOnly(left: constraints.minWidth /8,right: constraints.minWidth /8,top: constraints.maxWidth < 770 ?20:80)

            );
          },
        ));
  }
}
