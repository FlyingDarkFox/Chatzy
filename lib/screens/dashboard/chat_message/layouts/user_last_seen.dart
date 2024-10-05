import 'dart:developer';

import 'package:intl/intl.dart';

import '../../../../config.dart';
import '../../../../controllers/app_pages_controllers/chat_controller.dart';

class UserLastSeen extends StatelessWidget {
  const UserLastSeen({super.key});

  @override
  Widget build(BuildContext context) {

    return GetBuilder<ChatController>(
      builder: (chatCtrl) {

        return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users').doc(chatCtrl.pId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                if (!snapshot.hasData) {
                  return Container();
                } else {

                  return chatCtrl.pId ==  "0" ? Container(): Text(
                      snapshot.data!.data() != null ?
                    snapshot.data!.data()!["status"] == "Offline"
                        ? DateFormat('hh:mm a').format(
                        DateTime.fromMillisecondsSinceEpoch(
                            int.parse(snapshot.data!.data()!
                            ['lastSeen'])))
                        : snapshot.data!.data()!["status"] : "Offline",
                    textAlign: TextAlign.center,
                    style: Responsive.isMobile(context) ? AppCss.manropeLight14
                        .textColor(appCtrl.appTheme.darkText1) : AppCss.manropeLight16
                        .textColor(appCtrl.appTheme.darkText1)
                  );
                }
              } else {
                return Container();
              }
            });
      }
    );
  }
}
