import 'dart:developer';

import 'package:chatzy_web/screens/dashboard/index/layouts/search_text_box.dart';
import 'package:chatzy_web/screens/dashboard/index/layouts/status_horizontal.dart';
import 'package:chatzy_web/screens/dashboard/index/layouts/user_layout.dart';
import '../../../../config.dart';
import 'message_layout.dart';

typedef StringCallback = void Function(int);

class DrawerMenu extends StatelessWidget {
  final bool? value;
  final IntCallback? onTap;
  final GestureTapCallback? statusTap;

  const DrawerMenu({Key? key, this.value, this.onTap, this.statusTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<IndexController>(builder: (indexCtrl) {

      return Container(
          height: MediaQuery.of(context).size.height,
          width: Responsive.isMobile(context)
              ? MediaQuery.of(context).size.width
              : value!
                  ? Sizes.s520
                  : Sizes.s70,
          color: appCtrl.appTheme.white,
          child: SingleChildScrollView(
              controller: ScrollController(),
              child: Column(
                  crossAxisAlignment: value!
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    UserLayout(
                      onTap: (p0) => onTap!(p0),
                    ),
                    Divider(
                        color: appCtrl.appTheme.greyText.withOpacity(.20),
                        height: 0,
                        thickness: 1),
                    const VSpace(Sizes.s25),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            appFonts.status.tr,
                            style: GoogleFonts.manrope(
                                color: appCtrl.appTheme.darkText,
                                fontSize: FontSize.f20,
                                fontWeight: FontWeight.w600),
                          ),
                          if(appCtrl.statusList.length > 7)
                          Text(appFonts.viewAll.tr,
                              style: GoogleFonts.manrope(
                                  color: appCtrl.appTheme.primary,
                                  fontSize: FontSize.f16,
                                  fontWeight: FontWeight.w500))
                              .inkWell(onTap: statusTap),
                        ]).marginSymmetric(horizontal:Responsive.isMobile(context) ? Insets.i20:  Insets.i30),

                    const VSpace(Sizes.s18),
                    const StatusHorizontal(),
                    const VSpace(Sizes.s15),
                    Divider(
                        color: appCtrl.appTheme.greyText.withOpacity(.20),
                        height: 0,
                        thickness: 1),
                    const VSpace(Sizes.s25),
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection(collectionName.users)
                            .doc(appCtrl.user["id"])
                            .collection(collectionName.chats)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            int number =
                            getUnseenAllMessagesNumber(snapshot.data!.docs);
                            return Text("${appFonts.message.tr} (${number.toString()})",
                                style: GoogleFonts.manrope(
                                  fontWeight: FontWeight.w600,
                                  color: appCtrl.appTheme.darkText,
                                  fontSize: FontSize.f20
                                ))
                                .marginSymmetric(horizontal:  Responsive.isMobile(context) ? Insets.i20:  Insets.i30);
                          } else {
                            return Text("${appFonts.message.tr} (0)",
                                style:GoogleFonts.manrope(
                                    fontWeight: FontWeight.w600,
                                    color: appCtrl.appTheme.darkText,
                                    fontSize: FontSize.f20
                                ))
                                .marginSymmetric(horizontal: Responsive.isMobile(context) ? Insets.i20:  Insets.i30);
                          }
                        }),
                    const VSpace(Sizes.s18),
                    SearchTextBox(
                      onChanged: (val) => indexCtrl.onSearch(val),
                      controller: indexCtrl.userText,
                    ),
                    if(indexCtrl.chatId != null) const VSpace(Sizes.s15),
                    if (indexCtrl.user != null) const MessageLayout()
                  ])));
    });
  }
}
