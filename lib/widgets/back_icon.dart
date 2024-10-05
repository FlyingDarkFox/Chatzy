import 'package:chatzy_web/utils/extensions.dart';

import '../config.dart';

class BackIcon extends StatelessWidget {
  final bool verticalPadding;
  const BackIcon({super.key,this.verticalPadding = false});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      appCtrl.isRTL || appCtrl.languageVal == "ar" ? eSvgAssets.arrowRight : eSvgAssets.arrowLeft,
      height: Sizes.s18,
      fit: BoxFit.scaleDown
    ).paddingAll(Insets.i8).boxDecoration(color: appCtrl.appTheme.greyText.withOpacity(0.08))

        .inkWell(onTap: () => Get.back());
  }
}
