/*
import '../../../../config.dart';

class SelectedContactList extends StatelessWidget {
  const SelectedContactList({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GroupChatMessageController>(builder: (groupChatCtrl) {
      return Column(
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
      ).backgroundColor(appCtrl.appTheme.borderColor);
    });
  }
}
*/
