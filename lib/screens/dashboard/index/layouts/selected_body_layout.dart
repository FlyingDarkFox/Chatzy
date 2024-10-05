
import '../../../../config.dart';
import '../../../../controllers/app_pages_controllers/contact_list_controller.dart';
import '../../../../controllers/bottom_controllers/index_controller.dart';
import '../../chat_message/chat_message.dart';
import '../../group_message_screen/group_chat_message.dart';

class SelectedIndexBodyLayout extends StatelessWidget {
  const SelectedIndexBodyLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<IndexController>(builder: (indexCtrl) {
      return Consumer<FetchContactController>(
          builder: (context1, registerAvailableContact, child) {
          return Expanded(
              child: SelectionArea(
                  child: CustomScrollView(
                      shrinkWrap: true,
                      controller: indexCtrl.scrollController,
                      slivers: [
                SliverList(
                    delegate: SliverChildListDelegate([
                  AnimatedContainer(
                      height: MediaQuery.of(context).size.height,
                      duration: const Duration(seconds: 2),
                      color: appCtrl.appTheme.primaryLight1,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            indexCtrl.chatId != null
                                ? indexCtrl.chatType == 0
                                ? const Chat()
                               : indexCtrl.chatType == 1
                                ? const GroupChatMessage()
                              : /*const BroadcastChat()*/
                            Container()
                                :  Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.max,
                                children: [

                                  Image.asset(eImageAssets.appLogo,
                                      height: Sizes.s280),
                                  const VSpace(Sizes.s35),
                                  registerAvailableContact.alreadyRegisterUser.isEmpty ?
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(appFonts.newRegister.tr,
                                          style: AppCss.manropeSemiBold20
                                              .textColor(appCtrl.appTheme.txt)),
                                      const VSpace(Sizes.s15),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                                text: appFonts.newRegisterSync.tr,
                                                style:    AppCss.manropeMedium14
                                                    .textColor(appCtrl.appTheme.txt).textHeight(1.2)
                                            ),
                                            const WidgetSpan(
                                              child: Icon(Icons.settings, size: 20),
                                            ),
                                            TextSpan(
                                                text: " ${appFonts.settingInThat.tr} ", style:    AppCss.manropeMedium14
                                                .textColor(appCtrl.appTheme.txt).textHeight(1.2)
                                            ),
                                            const WidgetSpan(
                                              child: Icon(Icons.sync, size: 20),
                                            ),
                                            TextSpan(
                                                text: " ${appFonts.syncTextButton.tr}",   style:    AppCss.manropeMedium14
                                                .textColor(appCtrl.appTheme.txt).textHeight(1.2)
                                            ),
                                          ],
                                        ),
                                      ),

                                    ],
                                  ):
                                  Text(appFonts.noChat.tr,
                                      style: AppCss.manropeSemiBold20
                                          .textColor(
                                          appCtrl.appTheme.darkText))
                                ]).marginOnly(
                                top: MediaQuery.of(context).size.height / 5)
                          ])
                     )
                ])),
                SliverFillRemaining(
                    hasScrollBody: false,
                    fillOverscroll: true,
                    child: const Column(
                            children: <Widget>[Expanded(child: SizedBox.shrink())])
                        .backgroundColor(appCtrl.appTheme.bg))
              ])));
        }
      );
    });
  }

}
