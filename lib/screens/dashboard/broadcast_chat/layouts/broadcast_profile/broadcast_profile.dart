import '../../../../../config.dart';
import '../../../../../widgets/gradiant_button_common.dart';
import '../../../chat_message/layouts/chat_user_profile/center_position_image.dart';
import 'broadcast_profile_body.dart';

class BroadcastProfile extends StatefulWidget {
  const BroadcastProfile({super.key});

  @override
  State<BroadcastProfile> createState() => _BroadcastProfileState();
}

class _BroadcastProfileState extends State<BroadcastProfile> {
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

//----------
  bool get isSliverAppBarExpanded {
    return scrollController.hasClients &&
        scrollController.offset > (130 - kToolbarHeight);
  }

  @override
  Widget build(BuildContext context) {
    return DirectionalityRtl(
      child: GetBuilder<BroadcastChatController>(builder: (chatCtrl) {
        return SingleChildScrollView(
            child: Column(
                children: [
                  Stack(
                      children: [
                        Stack(alignment: Alignment.bottomCenter, children: [
                          const CenterPositionImage(isBroadcast: true),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(chatCtrl.pName!,
                                          style: AppCss.manropeSemiBold18
                                              .textColor(appCtrl.appTheme.darkText)),
                                      const VSpace(Sizes.s8),
                                      Text(
                                          "${chatCtrl.pData.length.toString()} ${appFonts.people.tr}",
                                          style: AppCss.manropeMedium14
                                              .textColor(appCtrl.appTheme.greyText))
                                    ]),

                              ]).paddingAll(Insets.i20)
                        ]),
                        GradiantButtonCommon(
                            icon:  eSvgAssets.cross,
                            onTap:  (){
                              chatCtrl.isUserProfile =false;
                              chatCtrl.update();
                            }).paddingAll(Insets.i20)
                      ]
                  ),
                  const BroadcastProfileBody()
                ]
            )
        );
      }),
    );
  }
}
