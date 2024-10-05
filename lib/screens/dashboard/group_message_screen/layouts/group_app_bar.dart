import 'package:chatzy_web/utils/extensions.dart';

import '../../../../config.dart';
import '../../../../widgets/common_image_layout.dart';
import 'group_user_status.dart';

class GroupChatMessageAppBar extends StatelessWidget {
  final PopupMenuItemSelected<dynamic>? onSelected;

  const GroupChatMessageAppBar({
    Key? key,
    this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appBarHeight = AppBar().preferredSize.height;
    return GetBuilder<GroupChatMessageController>(builder: (chatCtrl) {
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
                      .newBoxDecoration(color: appCtrl.appTheme.primary)
                      .marginOnly(
                          right: Insets.i10,
                          top: Insets.i20,
                          bottom: Insets.i20,
                          left: Insets.i20)
                      .inkWell(onTap: () {
                    chatCtrl.onBackPress();
                    Get.back();
                  }).marginOnly(right: Insets.i10),
                CommonImage(
                    image: chatCtrl.pData["image"],
                    name: chatCtrl.pName,
                    height:
                        Responsive.isMobile(context) ? Sizes.s40 : Sizes.s60,
                    width:
                        Responsive.isMobile(context) ? Sizes.s40 : Sizes.s60),
                const HSpace(Sizes.s8),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        chatCtrl.pName ?? "",
                        textAlign: TextAlign.center,
                        style: Responsive.isMobile(context)
                            ? AppCss.manropeBold14
                                .textColor(appCtrl.appTheme.darkText)
                            : AppCss.manropeBold20
                                .textColor(appCtrl.appTheme.darkText),
                      ),
                      const VSpace(Sizes.s12),
                      const GroupUserLastSeen()
                    ]).marginSymmetric(vertical: Insets.i2)
              ],
            ).inkWell(onTap: () {
              chatCtrl.isUserProfile = true;
              chatCtrl.update();
            }),
            Row(
              children: [
                IntrinsicHeight(
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        eSvgAssets.videoBorder,
                        colorFilter: ColorFilter.mode(
                            appCtrl.appTheme.primary, BlendMode.srcIn),
                      ),
                      VerticalDivider(color: appCtrl.appTheme.primary, width: 0)
                          .paddingSymmetric(
                              horizontal: Insets.i18, vertical: Insets.i5),
                      SvgPicture.asset(eSvgAssets.callOut,
                          colorFilter: ColorFilter.mode(
                              appCtrl.appTheme.primary, BlendMode.srcIn)),
                      const HSpace(Sizes.s35)
                    ],
                  ),
                ),
                Container(
                    width: Sizes.s40,
                    height: Sizes.s40,
                    decoration: ShapeDecoration(
                        color: appCtrl.appTheme.primary.withOpacity(.20),
                        shadows: const [
                          BoxShadow(
                              offset: Offset(0, 2),
                              blurRadius: 5,
                              spreadRadius: 1,
                              color: Color.fromRGBO(0, 0, 0, 0.08))
                        ],
                        shape: SmoothRectangleBorder(
                            borderRadius: SmoothBorderRadius(
                                cornerRadius: 10, cornerSmoothing: .8))),
                    child: PopupMenuButton(
                        color: appCtrl.appTheme.white,
                        icon: SvgPicture.asset(
                          eSvgAssets.more,
                          colorFilter: ColorFilter.mode(
                              appCtrl.appTheme.primary, BlendMode.srcIn),
                        ),
                        onSelected: (result) async {
                          if(result ==1){
                            chatCtrl
                                .clearChatConfirmation();

                          }else if(result ==2){
                            chatCtrl.isThere
                                ? chatCtrl.exitGroupDialog()
                                : chatCtrl.deleteGroup();
                          }
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.r8),
                        ),
                        itemBuilder: (ctx) => [
                          _buildPopupMenuItem(appFonts.clearChat.tr, 1),
                          _buildPopupMenuItem(chatCtrl.isThere
                              ? appFonts.exitGroup.tr
                              : appFonts.deleteGroup.tr, 2),
                            ])),
              ],
            )
          ]).marginOnly(
              left:
              Responsive.isMobile(context) ? 0 : Insets.i40,
              right:
              Responsive.isMobile(context) ? 0 : Insets.i40,
              top: Insets.i30,bottom: Insets.i28),
          Divider(
                  color: appCtrl.appTheme.greyText.withOpacity(.20),
                  height: 0,
                  thickness: 1)
              .marginSymmetric(
                  horizontal:
                      Responsive.isMobile(context) ? Sizes.s20 : Insets.i30)
        ],
      );
    });
  }

  PopupMenuItem _buildPopupMenuItem(String title, int position, {image}) {
    return PopupMenuItem(
      value: position,
      child: Row(
        children: [
          if (image != null)
            SvgPicture.asset(
              image,
              height: Sizes.s20,
              colorFilter:
                  ColorFilter.mode(appCtrl.appTheme.darkText, BlendMode.srcIn),
            ),
          if (image != null) const HSpace(Sizes.s5),
          Text(
            title,
            style: AppCss.manropeMedium14.textColor(appCtrl.appTheme.darkText),
          )
        ],
      ),
    );
  }
}
