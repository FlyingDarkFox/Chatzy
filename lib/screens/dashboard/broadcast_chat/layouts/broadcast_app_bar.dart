

import 'package:chatzy_web/utils/extensions.dart';
import 'package:smooth_corner/smooth_corner.dart';

import '../../../../config.dart';

class BroadCastAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? name, nameList;

  const BroadCastAppBar({super.key, this.name, this.nameList});

  @override
  Widget build(BuildContext context) {
    var appBarHeight = AppBar().preferredSize.height;
    return GetBuilder<BroadcastChatController>(builder: (chatCtrl) {
      String name = chatCtrl.broadData["users"] != null
          ? "${chatCtrl.broadData["users"].length} recipients"
          : "0";
      return Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (Responsive.isMobile(context))
                  SvgPicture.asset(
                      appCtrl.isRTL || appCtrl.languageVal == "ar"
                          ? eSvgAssets.arrowRight
                          : eSvgAssets.arrowLeft,
                      colorFilter: ColorFilter.mode(
                          appCtrl.appTheme.sameWhite, BlendMode.srcIn),
                      height: Sizes.s18)
                      .paddingAll(Insets.i10)
                      .newBoxDecoration()
                      .marginOnly(
                      right: Insets.i10,
                      top: Insets.i20,
                      bottom: Insets.i20,
                      left: Insets.i20)
                      .inkWell(onTap: () {
                    chatCtrl.onBackPress();
                    Get.back();
                  }).marginOnly(right: Insets.i20),
                SmoothContainer(
                    height:
                    Responsive.isMobile(context) ? Sizes.s40 : Sizes.s60,
                    width: Responsive.isMobile(context) ? Sizes.s40 : Sizes.s60,
                    alignment: Alignment.center,
                    color: const Color(0xff3282B8),
                    smoothness: 0.9,
                    borderRadius: BorderRadius.circular(AppRadius.r12),
                    child: Text(
                      name.length > 2
                          ? name
                          .replaceAll(" ", "")
                          .substring(0, 2)
                          .toUpperCase()
                          : name[0],
                      style: AppCss.manropeblack16
                          .textColor(appCtrl.appTheme.white),
                    )),
                const HSpace(Sizes.s8),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    name,
                    textAlign: TextAlign.center,
                    style: Responsive.isMobile(context)
                        ? AppCss.manropeBold14
                        .textColor(appCtrl.appTheme.darkText)
                        : AppCss.manropeBold20
                        .textColor(appCtrl.appTheme.darkText),
                  ),
                  const VSpace(Sizes.s10),
                  Text(
                    chatCtrl.nameList,
                    style: AppCss.manropeMedium14
                        .textColor(appCtrl.appTheme.greyText),
                  )
                ]),
              ],
            ),
            Stack(alignment: Alignment.center, children: [
              PopupMenuButton(
                  color: appCtrl.appTheme.white,
                  icon: SvgPicture.asset(
                    eSvgAssets.more,
                    colorFilter: ColorFilter.mode(
                        appCtrl.appTheme.darkText, BlendMode.srcIn),
                  ),
                  onSelected: (result) {
                    if (result == 0) {
                     /* Get.to(()=> const BroadcastProfile());*/
                    } else if (result ==
                        1) {

                      chatCtrl
                          .buildPopupDialog();
                      chatCtrl.update();
                    }
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.r8),
                  ),
                  itemBuilder: (ctx) => [
                    _buildPopupMenuItem(
                        appFonts.viewInfo,
                        eSvgAssets.viewInfo,
                        0),
                    _buildPopupMenuItem(
                        appFonts
                            .clearChat,
                        eSvgAssets
                            .trash,
                        1,
                        isDivider:
                        false),
                  ])
            ])
          ]).marginSymmetric(
              horizontal:
              Responsive.isMobile(context) ? Insets.i20 : Insets.i30,
              vertical: Insets.i30),
          Divider(color: appCtrl.appTheme.divider, height: 0, thickness: 1)
              .marginSymmetric(
              horizontal:
              Responsive.isMobile(context) ? Insets.i20 : Insets.i30)
        ],
      );
    });
  }

  @override
  Size get preferredSize => const Size.fromHeight(Sizes.s85);

  PopupMenuItem _buildPopupMenuItem(
      String title, String iconData, int position, {isDivider = true}) {
    return PopupMenuItem(
      value: position,
      child: Column(
        children: [
          Row(children: [
            SvgPicture.asset(iconData,
                height: Sizes.s20,
                colorFilter: ColorFilter.mode(
                    appCtrl.appTheme.darkText, BlendMode.srcIn)),
            const HSpace(Sizes.s5),
            Text(title.tr,
                style: AppCss.manropeMedium14.textColor(
                    title == appFonts.block.tr
                        ? appCtrl.appTheme.redColor
                        : appCtrl.appTheme.darkText))
          ]),
          if (isDivider)
            Divider(
                color: appCtrl.appTheme.borderColor,
                height: 0,
                thickness: 1)
                .marginOnly(top: Insets.i15)
        ],
      ),
    );
  }

}
