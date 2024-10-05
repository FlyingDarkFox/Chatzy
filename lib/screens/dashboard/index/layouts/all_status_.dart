import 'dart:developer';

import 'package:chatzy_web/screens/dashboard/index/layouts/status_layout.dart';

import '../../../../config.dart';
import '../../../../widgets/back_icon.dart';
import 'current_user_status.dart';

class AllStatus extends StatelessWidget {
  final List? firebaseList;

  const AllStatus({Key? key, this.firebaseList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<IndexController>(builder: (indexCtrl) {
      return ValueListenableBuilder<bool>(
          valueListenable: indexCtrl.statusIndex,
          builder: (context, value, child) {
            if (!value) {
              indexCtrl.textShow();
            }
            log("SSS : ${appCtrl.firebaseContact.length}");
            return AnimatedContainer(
              duration: Duration(seconds: !value ? 1 : 0),
              height: MediaQuery.of(context).size.height,
              width: !value ? Sizes.s520 : 0,
              color: appCtrl.appTheme.white,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (indexCtrl.isTextShow)
                      Row(mainAxisSize: MainAxisSize.min, children: [
                        const BackIcon(),
                        const HSpace(Sizes.s20),
                        Text(appFonts.status.tr,
                            style: GoogleFonts.manrope(
                                color: appCtrl.appTheme.darkText,
                                fontSize: FontSize.f22,
                                fontWeight: FontWeight.w600))
                      ]).width(!value ? Sizes.s520 : 0).paddingOnly(
                          top: Insets.i50,
                          left: Responsive.isMobile(context)
                              ? Insets.i20
                              : Insets.i30,
                          right: Responsive.isMobile(context)
                              ? Insets.i20
                              : Insets.i30,
                          bottom: Insets.i35),
                    Divider(
                        color: appCtrl.appTheme.greyText.withOpacity(.20),
                        height: 0,
                        thickness: 1),
                    if (indexCtrl.isTextShow)
                      SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            if (indexCtrl.user != null)
                              CurrentUserStatus(
                                currentUserId:
                                    appCtrl.storage.read(session.user)["id"],
                              ),
                            ...firebaseList!.asMap().entries.map((e) {
                              return StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection(collectionName.users)
                                      .doc(e.value.id)
                                      .collection(collectionName.status)
                                      .orderBy("updateAt", descending: true)
                                      .limit(15)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Container();
                                    } else if (!snapshot.hasData) {
                                      return Container();
                                    } else {
                                      List<Status> statusList = [];
                                      List status =
                                          indexCtrl.statusListWidget(snapshot);
                                      statusList = [];
                                      status.asMap().entries.forEach((element) {
                                        Status convertStatus =
                                            Status.fromJson(element.value);

                                        if (element.value
                                            .containsKey("seenAllStatus")) {
                                          if (!convertStatus.seenAllStatus!
                                              .contains(appCtrl.user["id"])) {
                                            if (!statusList.contains(
                                                Status.fromJson(
                                                    element.value))) {
                                              statusList.add(Status.fromJson(
                                                  element.value));
                                            }
                                          }
                                        } else {
                                          if (!statusList.contains(
                                              Status.fromJson(element.value))) {
                                            statusList.add(
                                                Status.fromJson(element.value));
                                          }
                                        }
                                      });
                                      log("statusList : ${statusList.length}");
                                      return SizedBox(
                                        height: Sizes.s70,
                                        child: ListView.builder(
                                            itemCount: statusList.length,
                                            shrinkWrap: true,
                                            padding: EdgeInsets.zero,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              return InkWell(
                                                  onTap: () {
                                                    final statusCtrl = Get
                                                            .isRegistered<
                                                                StatusController>()
                                                        ? Get.find<
                                                            StatusController>()
                                                        : Get.put(
                                                            StatusController());
                                                    statusCtrl.openImagePreview(
                                                        statusList[index]);
                                                  },
                                                  child: StatusLayout(
                                                    snapshot: statusList[index],
                                                  ).marginOnly(
                                                      right: Insets.i20));
                                            }),
                                      );
                                    }
                                  });
                            }).toList()
                          ],
                        ).marginSymmetric(horizontal: Insets.i20),
                      ),
                  ]).paddingSymmetric(horizontal: Insets.i20),
            );
          });
    });
  }
}
