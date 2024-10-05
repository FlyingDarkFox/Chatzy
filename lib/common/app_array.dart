import '../config.dart';

class AppArray {
  // Reels List
   var reelsList = [
     eImageAssets.r1,
     eImageAssets.r2,
     eImageAssets.r3,
   ];

   //language list
   var languageList = [
     {'name': 'english', 'locale': const Locale('en', 'US')},
     {'name': 'arabic', 'locale': const Locale('ar', 'AE')},
     {'name': 'hindi', 'locale': const Locale('hi', 'IN')},
     {'name': 'korean', 'locale': const Locale('ko', 'KR')}
   ];

   var addProfilePhotoList = [
     {
       "image": eImageAssets.gallery,
       "title": appFonts.selectFromGallery
     },
     {
       "image": eImageAssets.camera,
       "title": appFonts.openCamera
     },
     {
       "image": eImageAssets.anonymous,
       "title": appFonts.removePhoto
     }
   ];

   // Bottom NavigationBar List
   var bottomNavyList = [
     {
       "icon": eSvgAssets.chat,
       "title": appFonts.chats,
       "icon2": eSvgAssets.chatOut
     },
     {
       "icon": eSvgAssets.call,
       "title": appFonts.calls,
       "icon2": eSvgAssets.callOut
     },
     {
       "icon": eSvgAssets.setting,
       "title": appFonts.setting,
       "icon2": eSvgAssets.settingOut
     },
     {
       "icon": eSvgAssets.call,
       "title": appFonts.profile,
       "icon2": eSvgAssets.callOut
     },
   ];

   var addStatusList = [
     {
       "image": eImageAssets.gallery,
       "title": appFonts.gallery.tr
     },
     {
       "image": eImageAssets.textStatus,
       "title": appFonts.writeText.tr
     },
   ];


   var chatMenuList = [
     {
       "image": eSvgAssets.people,
       "title": appFonts.newGroup
     },
     {
       "image": eSvgAssets.broadCast,
       "title": appFonts.newBroadcast
     },
     {
       "image": eSvgAssets.add,
       "title": appFonts.inviteFriends
     },
   ];

   var addStoryList = [
     {
       "image": eImageAssets.gallery,
       "title": appFonts.selectFromGallery.tr
     },
     {
       "image": eImageAssets.camera,
       "title": appFonts.openCamera.tr
     },
     {
       "image": eImageAssets.text,
       "title": appFonts.writeText.tr
     }
   ];

   //bottom list
   var bottomList = [
     {'icon': eSvgAssets.chat, 'title': "chats",'iconSelected': eSvgAssets.chatFilled},
     {'icon': eSvgAssets.story, 'title': "status",'iconSelected': eSvgAssets.storyFilled},
     {'icon': eSvgAssets.call, 'title': "calls",'iconSelected': eSvgAssets.callFilled},
   ];

   //action list
   var actionList = [
     {'title': "newBroadCast"},
     {'title': "newGroup"},
     {'title': "setting"},
   ];


   //statusAction list
   var statusAction = [

     {'title': "setting"},
   ];

   //callAction list
   var callsAction = [

     {'title': "clearLogs"},
     {'title': "setting"}
   ];

   var chatLayoutMenuList = [
     {
       "image": eSvgAssets.viewInfo,
       "title": appFonts.viewInfo.tr
     },
     {
       "image": eSvgAssets.searchChat,
       "title": appFonts.search.tr
     },
     {
       "image": eSvgAssets.addWallpaper,
       "title": appFonts.wallpaper.tr
     },
     {
       "image": eSvgAssets.clearChat,
       "title": appFonts.clearChat.tr
     },
     {
       "image": eSvgAssets.block,
       "title": appFonts.block.tr
     },
   ];

   //chat list
   var chatList = [
     {
       "type": "source",
       "message": "appFonts.hellow",
     },
     {
       "type": "source",
       "message": "appFonts.youAreOn",
     },
     {
       "type": "receiver",
       "message": "appFonts.okyCanYou",
     },
     {
       "type": "source",
       "message": "appFonts.yesWhyNot",
     },
     {
       "type": "receiver",
       "message": "appFonts.thankYou",
     },
     {
       "type": "source",
       "message": "appFonts.canYouPleaseBring",
     },
     {
       "type": "receiver",
       "message": "appFonts.yesIWill",
     },
     {
       "type": "receiver",
       "message": "appFonts.yesIWill",
     },
     {
       "type": "receiver",
       "message": "appFonts.yesIWill",
     },
     {
       "type": "receiver",
       "message": "appFonts.yesIWill",
     },
     {
       "type": "source",
       "message": "appFonts.yesWhyNot",
     },
   ];

   var callList = [
     {
       "image": eImageAssets.audioCall,
       "title": appFonts.audioCall.tr
     },
     {
       "image": eImageAssets.videoCall,
       "title": appFonts.videoCall.tr
     }

   ];

   var selectContactList = [
     {
       "image": eImageAssets.newGroup,
       "title": appFonts.newGroup.tr,
     },

     {
       "image": eImageAssets.newContact,
       "title": appFonts.newContact.tr,
     },

   ];


  List solidWallpaper = [
   eImageAssets.bg1,
   eImageAssets.bg2,
   eImageAssets.bg3,
   eImageAssets.bg4,
   eImageAssets.bg5,
   eImageAssets.bg6,
   eImageAssets.bg7,
   eImageAssets.bg8,
   eImageAssets.bg9,
   ];

   List lightWallpaper = [
     eImageAssets.lbg1,
     eImageAssets.lbg2,
     eImageAssets.lbg3,
     eImageAssets.lbg4,
     eImageAssets.lbg5,
     eImageAssets.lbg6,
   ];

   List darkWallpaper = [
     eImageAssets.dbg1,
     eImageAssets.dbg2,
     eImageAssets.dbg3,
     eImageAssets.dbg4,
     eImageAssets.dbg5,
     eImageAssets.dbg6,
   ];

   List settingList = [
   /*  {
       "icon": eSvgAssets.multiLang,
       "title": appFonts.appLanguage
     },
     {
       "icon": eSvgAssets.rtl,
       "title": appFonts.rtl
     },
     {
       "icon": eSvgAssets.theme,
       "title": appFonts.theme
     },
     {
       "icon": eSvgAssets.fingerScanner,
       "title": appFonts.fingerLock
     },
     {
       "icon": eSvgAssets.starOut,
       "title": appFonts.rateApp
     },
     {
       "icon": eSvgAssets.trash,
       "title": appFonts.clearStorage
     },
     {
       "icon": eSvgAssets.logoutOut,
       "title": appFonts.logOut
     }*/
     { "icon": eSvgAssets.multiLang,
       "title": appFonts.appLanguage},
     { "icon": eSvgAssets.rtl,
       "title": appFonts.rtl},
     { "icon": eSvgAssets.theme,
       "title": appFonts.theme},
     {'title': appFonts.deleteAccount,"icon" : eSvgAssets.trash},
     {   "icon": eSvgAssets.logoutOut,
       "title": appFonts.logOut},
   ];

   List languagesList = [
     {
       "icon": eImageAssets.english,
       "title": appFonts.english,
       'locale': const Locale('en', 'US'),
       "code": "en"
     },
     {
       "icon": eImageAssets.hindi,
       "title": appFonts.hindi,
       'locale': const Locale('hi', 'IN'),
       "code": "hi"
     },
     {
       "icon": eImageAssets.arabic,
       "title": appFonts.arabic,
       'locale': const Locale('ar', 'AE'),
       "code": "ar"
     },
     {
       "icon": eImageAssets.korean,
       "title": appFonts.korean,
       'locale': const Locale('ko', 'KR'),
       "code": "ko"
     }
   ];



   List groupOptionList = [
       {'title': appFonts.add.tr,"icon" : eSvgAssets.profileAdd},
       {'title': appFonts.leave.tr,"icon" : eSvgAssets.exit},
       {'title': appFonts.report.tr,"icon" : eSvgAssets.dislike},
   ];

   var broadcastOptionList = [
       {'title': appFonts.add.tr,"icon" : eSvgAssets.profileAdd},
       {'title': appFonts.delete.tr,"icon" : eSvgAssets.trash},

   ];


}