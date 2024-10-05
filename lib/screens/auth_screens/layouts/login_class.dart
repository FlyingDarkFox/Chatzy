import '../../../../config.dart';
import '../../../responsive.dart';

class LoginCommonClass {
  //login body
  Widget loginBody({Widget? child}) => Center(
      child: Container(

          margin: const EdgeInsets.symmetric(horizontal: Insets.i15),
          child: child));

  //logo layout
  Widget logoLayout({String? image}) => Image.asset(image!,
      height: Responsive.isMobile(Get.context!) ?Sizes.s30 : Sizes.s80);

  //title layout
  Widget titleLayout({String? title}) => Text(title.toString().tr,
          style: AppCss.manropeRegular18.textColor(appCtrl.appTheme.darkText))
      .alignment(Alignment.centerLeft);

}
