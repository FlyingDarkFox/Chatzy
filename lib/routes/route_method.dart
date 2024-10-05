
import 'package:chatzy_web/routes/route_name.dart';
import 'package:chatzy_web/screens/dashboard/group_message_screen/group_profile/add_participants.dart';

import '../config.dart';
import '../screens/dashboard/chat_mobile_view.dart';
import '../screens/other_screens/audio_call/audio_call.dart';
import '../screens/other_screens/video_call/video_call.dart';

RouteName _routeName = RouteName();

class AppRoute {
  final List<GetPage> getPages = [
    GetPage(name: _routeName.dashboard, page: () =>const  IndexLayout()),

    GetPage(name: _routeName.audioCall, page: () => const AudioCall()),
    GetPage(name: _routeName.videoCall, page: () => const VideoCall()),
    GetPage(name: _routeName.chatLayout, page: () => const ChatMobileView()),
    GetPage(name: _routeName.groupChat, page: () => const GroupChatMobileView()),
    GetPage(name: _routeName.broadcastChat, page: () => const BroadcastChatMobileView()),
    GetPage(name: _routeName.addParticipants, page: () =>  AddParticipants()),
  ];
}
