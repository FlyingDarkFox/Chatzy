import 'dart:developer';

import '../../../../config.dart';
import '../../../../utils/general_utils.dart';
import '../../../../widgets/common_image_layout.dart';

class UserLayout extends StatelessWidget {
  final GlobalKey<ScaffoldState>? scaffoldDrawerKey;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final IntCallback? onTap;

  const UserLayout(
      {Key? key, this.scaffoldDrawerKey, this.scaffoldKey, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<IndexController>(builder: (indexCtrl) {
      return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(
          children: [
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection(collectionName.users)
                    .doc(appCtrl.user["id"])
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.exists) {
                      return CommonImage(
                          image: snapshot.data!.data()!["image"] ?? "",
                          name: appCtrl.user["name"],
                          height: Responsive.isMobile(context)
                              ? Sizes.s40
                              : Sizes.s60,
                          width: Responsive.isMobile(context)
                              ? Sizes.s40
                              : Sizes.s60);
                    } else {
                      return CommonImage(
                          image: "",
                          name: appCtrl.user["name"],
                          height: Responsive.isMobile(context)
                              ? Sizes.s40
                              : Sizes.s60,
                          width: Responsive.isMobile(context)
                              ? Sizes.s40
                              : Sizes.s60);
                    }
                  } else {
                    return CommonImage(
                        image: "",
                        name: appCtrl.user["name"],
                        height: Responsive.isMobile(context)
                            ? Sizes.s40
                            : Sizes.s60,
                        width: Responsive.isMobile(context)
                            ? Sizes.s40
                            : Sizes.s60);
                  }
                }),
            const HSpace(Sizes.s20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    indexCtrl.user != null ? indexCtrl.user["name"] : "Welcome",
                    style: AppCss.manropeBold20
                        .textColor(appCtrl.appTheme.darkText)
                        .letterSpace(.5)),
                const VSpace(Sizes.s8),
                Text(
                  appCtrl.user['statusDesc'],
                  style: AppCss.manropeLight16
                      .textColor(appCtrl.appTheme.greyText),
                )
              ],
            )
          ],
        ),
        Container(
            width: Sizes.s40,
            height: Sizes.s40,
            decoration: ShapeDecoration(
                color: appCtrl.appTheme.white,
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
                ),
                onSelected: (result) async {
                  onTap!(result);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.r8),
                ),
                itemBuilder: (ctx) => [
                      _buildPopupMenuItem(
                          appFonts.newBroadcast.tr, Icons.search, 0),
                      _buildPopupMenuItem(
                          appFonts.newGroup.tr, Icons.upload, 1),
                      _buildPopupMenuItem(appFonts.profile.tr, Icons.copy, 2),
                      _buildPopupMenuItem(appFonts.setting.tr, Icons.copy, 3),
                      _buildPopupMenuItem(appFonts.chats.tr, Icons.copy, 4),
                      //_buildPopupMenuItem(appFonts.logout.tr, Icons.copy, 5)
                    ]))
      ]).marginOnly(
          left: Responsive.isMobile(context) ? Insets.i20 : Insets.i30,
          top: Insets.i35,
          bottom: Insets.i24,
          right: Responsive.isMobile(context) ? Insets.i20 : Insets.i30);
    });
  }

  PopupMenuItem _buildPopupMenuItem(
      String title, IconData iconData, int position) {
    return PopupMenuItem(
        height: 0,
        value: position,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    AppCss.manropeBold16.textColor(appCtrl.appTheme.darkText)),
            if (position != 5)
              Divider(
                color: appCtrl.appTheme.divider,
                height: 0,
                thickness: 1,
              ).marginSymmetric(vertical: Insets.i20)
          ],
        ).paddingOnly(
            top: position == 0 ? Insets.i15 : 0,
            bottom: position == 5 ? Insets.i15 : 0));
  }
}
