

import 'package:chatzy_web/screens/dashboard/broadcast_chat/broadcast_chat.dart';
import 'package:chatzy_web/screens/other_screens/create_group/create_group.dart';

import '../../config.dart';
import 'chat_message/chat_message.dart';
import 'group_message_screen/group_chat_message.dart';

class ChatMobileView extends StatelessWidget {
  const ChatMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Chat(),
    );
  }
}

class GroupChatMobileView extends StatelessWidget {
  const GroupChatMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: GroupChatMessage(),
    );
  }
}

class BroadcastChatMobileView extends StatelessWidget {
  const BroadcastChatMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: BroadcastChat(),
    );
  }
}

