

import 'package:chatzy_web/utils/extensions.dart';

import '../../../../config.dart';
import '../../../../controllers/app_pages_controllers/setting_controller.dart';

class SettingListCard extends StatelessWidget {
  final dynamic data;
  final int? index;

  const SettingListCard({Key? key, this.data, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingController>(builder: (settingCtrl) {
      return
          Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            SvgPicture.asset(
              data["icon"],
            ).paddingAll(Insets.i10).decorated(
                  color: appCtrl.appTheme.white,
                  borderRadius:
                      SmoothBorderRadius(cornerRadius: 8, cornerSmoothing: 1),
                ),
            const HSpace(Sizes.s10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(trans(data["title"]),
                    style: AppCss.manropeMedium18
                        .textColor(appCtrl.appTheme.darkText)),
                if (index == 0)
                  Text(
                      appCtrl.languageVal == "en"
                          ? "English"
                          : appCtrl.languageVal == "ar"
                              ? "Arabic"
                              : appCtrl.languageVal == "hi"
                                  ? "Hindi"
                                  : "Gujarati",
                      style: AppCss.manropeLight12
                          .textColor(appCtrl.appTheme.darkText1)).paddingOnly(top: Insets.i8)
              ],
            )
          ]),
          data["title"] == "rtl" ||
                  data["title"] == "theme" ||
                  data["title"] == "fingerprintLock"
              ? Switch(
                  // This bool value toggles the switch.
                  value: data["title"] == "rtl"
                      ? appCtrl.isRTL
                      : data["title"] == "theme"
                          ? appCtrl.isTheme
                          : appCtrl.isBiometric,
                  activeColor: appCtrl.appTheme.primary,
                  inactiveThumbColor: appCtrl.appTheme.white,inactiveTrackColor: appCtrl.appTheme.lightText,
                  onChanged: (bool value) {
                    settingCtrl.onSettingTap(index);
                    appCtrl.update();
                  },
                )
              : SvgPicture.asset(
                      appCtrl.isRTL
                          ? eSvgAssets.arrowLeft
                          : eSvgAssets.arrowRight,

                      colorFilter: ColorFilter.mode(appCtrl.appTheme.darkText, BlendMode.srcIn),)
                  .paddingAll(Insets.i12)

                  .inkWell(onTap: () => settingCtrl.onSettingTap(index)),
        ],
      )  .paddingAll(Insets.i15)
              .boxDecoration()
              .paddingOnly(bottom: Insets.i20,left:Responsive.isMobile(context)? Insets.i20:Insets.i30,right: Responsive.isMobile(context)? Insets.i20:Insets.i30).inkWell(onTap: (){});
    });
  }
}
