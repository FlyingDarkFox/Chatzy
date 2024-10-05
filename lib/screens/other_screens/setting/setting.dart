import 'package:smooth_corner/smooth_corner.dart' as smooth;

import '../../../config.dart';
import '../../../controllers/app_pages_controllers/setting_controller.dart';
import '../../../widgets/back_icon.dart';
import '../../../widgets/common_image_layout.dart';
import 'layouts/setting_list_card.dart';


class Setting extends StatelessWidget {
  final settingCtrl = Get.put(SettingController());

  final GestureTapCallback? onTap;
  Setting({Key? key,this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<IndexController>(builder: (indexCtrl) {
      return GetBuilder<SettingController>(builder: (context2) {
        return ValueListenableBuilder<bool>(
            valueListenable: indexCtrl.settingIndex,
            builder: (context1, value, child) {
              if (!value) {
                indexCtrl.textShow();
              }
              return AnimatedContainer(
                duration: Duration(seconds: !value ? 1 : 0),
                height: MediaQuery.of(context).size.height,
                width: !value ? Sizes.s520 : 0,
                color:  appCtrl.appTheme.white,
                child: Column(children: [
                  if (!value)

                    Row(mainAxisSize: MainAxisSize.min, children: [
                      const BackIcon(),
                      const HSpace(Sizes.s20),
                      Text(appFonts.setting.tr,
                          style: GoogleFonts.manrope(
                              color: appCtrl.appTheme.darkText,
                              fontSize: FontSize.f22,
                              fontWeight: FontWeight.w600
                          ))
                    ])
                        .width(!value ? Sizes.s520 : 0)
                        .paddingOnly(top: Insets.i50,left:Responsive.isMobile(context)?Insets.i20: Insets.i30,right: Responsive.isMobile(context)?Insets.i20: Insets.i30,bottom: Insets.i35),
                  Divider(
                      color: appCtrl.appTheme.greyText.withOpacity(.20),
                      height: 0,
                      thickness: 1),
                  const VSpace(Sizes.s20),
                  if (!value)
                    Container(
                      padding: const EdgeInsets.all(Insets.i15),
                      margin: EdgeInsets.symmetric(horizontal: Responsive.isMobile(context)? Insets.i20:Insets.i30),
                      alignment: Alignment.center,
                      decoration: ShapeDecoration(
                          shadows: [
                            BoxShadow(
                                offset: const Offset(0, 2),
                                blurRadius: 15,
                                spreadRadius: 0,
                                color:
                                    appCtrl.appTheme.primary.withOpacity(.08))
                          ],
                          shape: smooth.SmoothRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              smoothness: 0.9),
                          color: appCtrl.appTheme.primary),
                      child: Row(children: [
                        CommonImage(
                            image: appCtrl.user["image"] ??"",
                            name: appCtrl.user["name"],
                            height: Sizes.s68,
                            width: Sizes.s68).paddingAll(Insets.i3).decorated(shape: BoxShape.circle,color: appCtrl.appTheme.white),
                        const HSpace(Sizes.s12),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(appCtrl.user["name"],
                                  style: AppCss.manropeblack24
                                      .textColor(appCtrl.appTheme.white)),
                              const VSpace(Sizes.s10),
                              Text(appCtrl.user["statusDesc"],
                                  style: AppCss.manropeLight14
                                      .textColor(appCtrl.appTheme.white))
                            ])
                      ]),
                    ),
                  const VSpace(Sizes.s35),
                  if (!value)
                    //setting list
                    ...settingCtrl.settingList
                        .asMap()
                        .entries
                        .map((e) => SettingListCard(index: e.key, data: e.value))
                        .toList()
                ]),
              );
            });
      });
    });
  }
}
