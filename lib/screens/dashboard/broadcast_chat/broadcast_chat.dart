import '../../../config.dart';
import '../../../widgets/common_loader.dart';
import '../../other_screens/pick_up_call/pick_up_call.dart';
import 'layouts/broadcast_app_bar.dart';
import 'layouts/broadcast_body.dart';


class BroadcastChat extends StatefulWidget {
  const BroadcastChat({super.key});

  @override
  State<BroadcastChat> createState() => _BroadcastChatState();
}

class _BroadcastChatState extends State<BroadcastChat>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  final chatCtrl = Get.put(BroadcastChatController());
  dynamic receiverData;

  @override
  void initState() {
    // TODO: implement initState
    receiverData = Get.arguments;
    WidgetsBinding.instance.addObserver(this);
    setState(() {});
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
    return PickupLayout(
      scaffold: GetBuilder<BroadcastChatController>(builder: (_) {
        return DirectionalityRtl(
          child: PopScope(
              canPop: false,
              onPopInvoked: (didPop) {
                if (didPop) return;
                chatCtrl.onBackPress();
                Get.back();
              },

              child: Stack(children: <Widget>[
                const BroadcastBody(),

                // Loading
                if (chatCtrl.isLoading!)
                  const CommonLoader()
              ])),
        );
      }),
    );
  }
}
