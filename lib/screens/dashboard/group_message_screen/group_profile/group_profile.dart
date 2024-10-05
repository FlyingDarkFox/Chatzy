import '../../../../../config.dart';
import '../../../../../widgets/gradiant_button_common.dart';

import '../../chat_message/layouts/chat_user_profile/center_position_image.dart';
import 'group_profile_body.dart';

class GroupProfile extends StatefulWidget {
  const GroupProfile({super.key});

  @override
  State<GroupProfile> createState() => _GroupProfileState();
}

class _GroupProfileState extends State<GroupProfile> {
  var scrollController = ScrollController();
  int topAlign = 5;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    scrollController = ScrollController()
      ..addListener(() {
        setState(() {});
      });
  }

  bool get isSliverAppBarExpanded {
    return scrollController.hasClients &&
        scrollController.offset > (130 - kToolbarHeight);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GroupChatMessageController>(builder: (chatCtrl) {
      return Container(
          color: appCtrl.appTheme.white,
          width: Sizes.s450,
          height: MediaQuery.of(context).size.height ,

          child: SingleChildScrollView(
            child: Column( children: [
              Stack(
                alignment: Alignment.topRight,
                  children: [
                    Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          CenterPositionImage(
                              isGroup: true,
                              image: chatCtrl.groupImage,
                              name: chatCtrl.pName,
                              topAlign: topAlign,onTap:  ()=> chatCtrl.imagePickerOption(context)),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(chatCtrl.pName!,
                                          style: AppCss.manropeSemiBold18
                                              .textColor(
                                              appCtrl.appTheme.sameWhite)),
                                      const VSpace(Sizes.s8),
                                      Text("${chatCtrl.userList.length.toString()} ${appFonts.people.tr}",
                                          style: AppCss.manropeSemiBold18
                                              .textColor(appCtrl.appTheme.sameWhite))
                                    ]
                                ),
            
                              ]
                          ).paddingAll(Insets.i20)
                        ]
                    ),
                    GradiantButtonCommon(
                        icon:  eSvgAssets.cross,
                        onTap:  (){
                  chatCtrl.isUserProfile =false;
                  chatCtrl.update();
                  }).paddingAll(Insets.i20)
                  ]
              ),
              const GroupProfileBody()
            ]),
          )
      );
    });
  }
}
