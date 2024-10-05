import 'dart:developer';

import '../../../config.dart';
import '../../../controllers/app_pages_controllers/create_group_controller.dart';
import '../../dashboard/group_message_screen/group_profile/selected_users.dart';
import 'layouts/all_registered_contact.dart';
import 'layouts/selected_contact_list.dart';

class GroupChat extends StatelessWidget {
  final SharedPreferences? prefs;
  final groupChatCtrl = Get.isRegistered<CreateGroupController>()
      ? Get.find<CreateGroupController>()
      : Get.put(CreateGroupController());

  GroupChat({Key? key, this.prefs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context2, setState) {
      return GetBuilder<CreateGroupController>(builder: (_) {
        return WillPopScope(
          onWillPop: () async {
            groupChatCtrl.selectedContact = [];
            groupChatCtrl.update();
            Get.back();
            return true;
          },
          child: GetBuilder<AppController>(builder: (appCtrl) {
            log("groupChatCtrl.isAddUser : ${groupChatCtrl.isGroup}");
            return Consumer<FetchContactController>(
                builder: (context1, registerAvailableContact, child) {
              return Scaffold(
                  backgroundColor: appCtrl.appTheme.white,
                  appBar: AppBar(
                      centerTitle: false,
                      automaticallyImplyLeading: false,
                      actions: [
                        Icon(
                          groupChatCtrl.selectedContact.isNotEmpty
                              ? Icons.arrow_right_alt
                              : Icons.refresh,
                          color: appCtrl.appTheme.white,
                        ).marginSymmetric(horizontal: Insets.i15).inkWell(
                            onTap: () =>
                                groupChatCtrl.selectedContact.isNotEmpty
                                    ? groupChatCtrl.addGroupBottomSheet(context)
                                    : registerAvailableContact
                                        .syncContactsFromCloud(context, prefs!))
                      ],
                      leading: Icon(Icons.arrow_back,
                              color: appCtrl.appTheme.white)
                          .inkWell(onTap: () => Get.back()),
                      backgroundColor: appCtrl.appTheme.primary,
                      title: Text(
                          groupChatCtrl.isAddUser
                              ? appFonts.addContact.tr
                              : groupChatCtrl.isGroup
                                  ? appFonts.selectContact.tr
                                  : appFonts.newBroadcast.tr,
                          style: AppCss.manropeMedium18
                              .textColor(appCtrl.appTheme.white))),
                  body: Stack(children: [
                    SingleChildScrollView(
                        child:Consumer<FetchContactController>(
                            builder: (context, registerAvailableContact, child) {

                              return Stack(children: [
                                SingleChildScrollView(
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          if (groupChatCtrl.selectedContact.isNotEmpty)

                                            Column(
                                                children: [
                                                  Divider(height: 1,color: appCtrl.appTheme.greyText.withOpacity(0.2)),
                                                  SingleChildScrollView(
                                                      scrollDirection: Axis.horizontal,
                                                      child: Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: groupChatCtrl.selectedContact.asMap().entries.map((e) {
                                                            return SelectedUsers(
                                                                data: e.value,
                                                                onTap: () {
                                                                  groupChatCtrl.selectedContact.remove(e.value);
                                                                  groupChatCtrl.update();
                                                                }
                                                            );
                                                          }).toList()
                                                      ).paddingSymmetric(vertical: Insets.i10)
                                                  ),
                                                  Divider(height: 1,color: appCtrl.appTheme.greyText.withOpacity(0.2))
                                                ]
                                            ).backgroundColor(appCtrl.appTheme.borderColor),
                                          registerAvailableContact
                                              .alreadyRegisterUser.isNotEmpty ?
                                            Column(children: [
                                              ...registerAvailableContact.alreadyRegisterUser
                                                  .asMap()
                                                  .entries
                                                  .map((e) {
                                                return AllRegisteredContact(
                                                    onTap: () => groupChatCtrl.selectUserTap(e.value),
                                                    isExist: groupChatCtrl.selectedContact.any((file) =>
                                                    file["phone"] == e.value.phone),
                                                    data: e.value);
                                              })
                                            ]).paddingAll(Insets.i20): Center(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Text(appFonts.newRegister.tr,
                                                    style: AppCss.manropeBold16
                                                        .textColor(appCtrl.appTheme.txt)),
                                                const VSpace(Sizes.s15),
                                                Text(
                                                    appFonts.newRegisterSync.tr,
                                                    style: AppCss.manropeMedium14
                                                        .textColor(appCtrl.appTheme.txt))
                                              ],
                                            )
                                                .height(
                                                MediaQuery.of(context).size.height /
                                                    2.5)
                                                .paddingSymmetric(horizontal: Insets.i15),
                                          )
                                        ])),
                              ]);
                            }
                        )),
                  ]).height(MediaQuery.of(context).size.height));
            });
          }),
        );
      });
    });
  }
}
