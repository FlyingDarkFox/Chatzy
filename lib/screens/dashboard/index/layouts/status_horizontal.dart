import 'dart:developer';

import 'package:chatzy_web/screens/dashboard/index/layouts/status_layout.dart';

import '../../../../config.dart';
import 'current_user_status.dart';

class StatusHorizontal extends StatelessWidget {
  const StatusHorizontal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (appCtrl) {
      return GetBuilder<IndexController>(builder: (indexCtrl) {
        indexCtrl.user = appCtrl.storage.read(session.user);

        return SizedBox(
          height: Sizes.s90,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (indexCtrl.user != null)
                      CurrentUserStatus(
                        currentUserId: indexCtrl.user["id"],
                      ),
                    if (appCtrl.firebaseContact.isNotEmpty)
                      ...appCtrl.firebaseContact.asMap().entries.map((e) {
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
                                List status =
                                    indexCtrl.statusListWidget(snapshot);
                                appCtrl.statusList = [];
                                status.asMap().entries.forEach((element) {
                                  Status convertStatus =
                                      Status.fromJson(element.value);

                                  if (element.value
                                      .containsKey("seenAllStatus")) {
                                    if (!convertStatus.seenAllStatus!
                                        .contains(appCtrl.user["id"])) {
                                      if (!appCtrl.statusList.contains(
                                          Status.fromJson(element.value))) {
                                        appCtrl.statusList.add(
                                            Status.fromJson(element.value));
                                      }
                                    }
                                  } else {
                                    if (!appCtrl.statusList.contains(
                                        Status.fromJson(element.value))) {
                                      appCtrl.statusList
                                          .add(Status.fromJson(element.value));
                                    }
                                  }
                                });

                                return SizedBox(
                                  height: Sizes.s66,
                                  child: ListView.builder(
                                      itemCount: appCtrl.statusList.length,
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      scrollDirection: Axis.horizontal,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                            onTap: () {
                                              log("STAT");
                                              final statusCtrl = Get
                                                      .isRegistered<
                                                          StatusController>()
                                                  ? Get.find<StatusController>()
                                                  : Get.put(StatusController());
                                              statusCtrl.openImagePreview(
                                                  appCtrl.statusList[index]);
                                            },
                                            child: StatusLayout(
                                              onTap: () {
                                                log("STAT");
                                                final statusCtrl = Get
                                                    .isRegistered<
                                                    StatusController>()
                                                    ? Get.find<StatusController>()
                                                    : Get.put(StatusController());
                                                statusCtrl.openImagePreview(
                                                    appCtrl.statusList[index]);
                                              },
                                              snapshot:
                                                  appCtrl.statusList[index],
                                            ).marginOnly(right: Insets.i20));
                                      }),
                                );
                              }
                            });
                      }).toList()
                  ],
                ).marginSymmetric(
                    horizontal:
                        Responsive.isMobile(context) ? Insets.i20 : Insets.i30),
              ),
              if(appCtrl.statusList.length > 7)
              Align(
                  alignment: Alignment.centerRight,
                  child: Image.asset(eImageAssets.shadow))
            ],
          ),
        );
      });
    });
  }
}
