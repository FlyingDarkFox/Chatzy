import '../../../config.dart';
import '../../../controllers/app_pages_controllers/group_chat_controller.dart';
import '../../../widgets/common_loader.dart';
import 'layouts/group_app_bar.dart';
import 'layouts/group_chat_body.dart';

class GroupChatMessage extends StatefulWidget {
  const GroupChatMessage({super.key});

  @override
  State<GroupChatMessage> createState() => _GroupChatMessageState();
}

class _GroupChatMessageState extends State<GroupChatMessage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  final chatCtrl = Get.put(GroupChatMessageController());

  @override
  void initState() {
    // TODO: implement initState

    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      chatCtrl.textEditingController.addListener(() async {
        if (chatCtrl.textEditingController.text.isNotEmpty) {
          chatCtrl.typing = true;
          firebaseCtrl.groupTypingStatus(
              chatCtrl.pId,  true);
        }
        if (chatCtrl.textEditingController.text.isEmpty &&
            chatCtrl.typing == true) {
          chatCtrl.typing = false;
          firebaseCtrl.groupTypingStatus(
              chatCtrl.pId, false);
        }
        chatCtrl.update();
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {

      if (chatCtrl.listScrollController.hasClients) {
        chatCtrl.listScrollController.animateTo(
          chatCtrl.listScrollController.position.maxScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 500),
        );
      }
    });

    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      firebaseCtrl.setIsActive();
    } else {
      firebaseCtrl.setLastSeen();
    }
  }

  @override
  Widget build(BuildContext context) {

    return GetBuilder<GroupChatMessageController>(builder: (_) {
      return DirectionalityRtl(
        child: Stack(children: <Widget>[
          //body layout
          const GroupChatBody(),
          // Loading
          if (chatCtrl.isLoading)
            const CommonLoader(),

        ]).height(MediaQuery.of(context).size.height));
    });
  }
}
