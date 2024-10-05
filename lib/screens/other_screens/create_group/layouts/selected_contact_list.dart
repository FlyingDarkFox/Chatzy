

import 'dart:developer';



import '../../../../config.dart';
import '../../../dashboard/group_message_screen/group_profile/selected_users.dart';

class SelectedContactList extends StatelessWidget {
  final List? selectedContact;
  final Function(dynamic)? onTap;

  const SelectedContactList({Key? key, this.selectedContact, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: selectedContact!.asMap().entries.map((e) {
          log("EEE : ${e.value}");
          return SelectedUsers(
            data: e.value,
            onTap: () => onTap!(e.value),
          );
        }).toList(),
      ),
    );
  }
}
