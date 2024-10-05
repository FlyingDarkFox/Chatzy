import 'dart:developer';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:chatzy_web/utils/extensions.dart';
import 'package:flutter/cupertino.dart';

import '../../../config.dart';
import '../../../controllers/app_pages_controllers/chat_controller.dart';
import '../../../widgets/common_loader.dart';
import 'layouts/chat_app_bar.dart';
import 'layouts/chat_user_profile/chat_user_profile.dart';
import 'layouts/input_box.dart';
import 'layouts/message_box.dart';
import 'package:universal_html/html.dart' as html;

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  final chatCtrl = Get.put(ChatController());
  dynamic receiverData;

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      chatCtrl.setTyping();
    });
    receiverData = Get.arguments;

    setState(() {});
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      firebaseCtrl.setIsActive();
      chatCtrl.setTyping();
    } else {
      firebaseCtrl.setLastSeen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(builder: (_) {
     /* return DirectionalityRtl(
        child: PopScope(
            canPop: false,
            onPopInvoked: (didPop) {
              if (didPop) return;
              log("DD :$didPop");
              chatCtrl.onBackPress();
              Get.back();
            },
            child: Stack(children: <Widget>[
              Stack(
                children: [
                  Column(children: <Widget>[
                    // List of messages
                    const MessageBox(),
                    // Sticker
                    Container(),
                    // Input content
                    const InputBox(),
                    if (chatCtrl.isShowSticker) chatCtrl.showBottomSheet()
                  ]).chatBgExtension(chatCtrl.selectedWallpaper).inkWell(
                      onTap: () {
                        chatCtrl.enableReactionPopup = false;
                        chatCtrl.showPopUp = false;
                        chatCtrl.isShowSticker = false;
                        chatCtrl.update();
                        log("chatCtrl.enableReactionPopup : ${chatCtrl.enableReactionPopup}");
                      }),
                  if (chatCtrl.isFilter)
                    BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                        child: Container(
                            color:
                            const Color(0xff042549).withOpacity(0.3)))
                ],
              ),
              // Loading
              if (chatCtrl.isLoading || appCtrl.isLoading)
                const CommonLoader(),
            ])),
      );*/
   return   WillPopScope(
          onWillPop: chatCtrl.onBackPress,
          child: chatCtrl.allData != null
              ? chatCtrl.isCamera
              ? Stack(
            alignment: Alignment.bottomCenter,
            children: [
              chatCtrl.imageFile != null
                  ? Image.memory(chatCtrl.webImage,height: MediaQuery.of(context).size.height)
                  : FutureBuilder<void>(
                  future: chatCtrl.initializeControllerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.done) {
                      // If the Future is complete, display the preview.
                      return CameraPreview(chatCtrl.cameraController!)
                          .height(MediaQuery.of(context).size.height);
                    } else {
                      // Otherwise, display a loading indicator.
                      return const Center(
                          child: CircularProgressIndicator());
                    }
                  }),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    // Provide an onPressed callback.
                    onPressed: () async {
                      if(chatCtrl.imageFile != null){
                        await chatCtrl.uploadCameraImage();
                        chatCtrl.isCamera = false;
                        chatCtrl.update();
                      }else {
                        try {
                          final image =
                          await chatCtrl.cameraController!.takePicture();
                          log("CAMERA : $image");
                          chatCtrl.imageFile = image;
                          var imageFile = await image.readAsBytes();
                          chatCtrl.webImage = imageFile;
                          chatCtrl.update();
                        } catch (e) {
                          log(e.toString());
                        }
                      }
                    },
                    child:  Icon( chatCtrl.imageFile !=null ?Icons.arrow_forward : Icons.camera_alt),
                  ).marginOnly(bottom: Insets.i20,right: Insets.i15),
                  FloatingActionButton(
                    // Provide an onPressed callback.
                    onPressed: () async {
                      chatCtrl.isCamera =false;
                      chatCtrl.update();
                      chatCtrl.cameraController!.dispose();
                    },
                    child:const  Icon( CupertinoIcons.multiply),
                  ).marginOnly(bottom: Insets.i20),
                ],
              )
            ],
          )
              : Row(

            children: [
              Expanded(
                child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                  Column(children: <Widget>[
                    const ChatAppBar(),
                    // List of messages
                    const MessageBox(),
                    // Sticker
                    Container(),
                    // Input content
                    const InputBox(),
                    if (chatCtrl.isShowSticker)
                      chatCtrl.showBottomSheet()
                  ]).height(MediaQuery.of(context).size.height).inkWell(
                      onTap: () {
                        chatCtrl.enableReactionPopup = false;
                        chatCtrl.showPopUp = false;
                        chatCtrl.update();
                        log("chatCtrl.enableReactionPopup : ${chatCtrl.enableReactionPopup}");
                      })
                  ,
                  // Loading
                  if (chatCtrl.isLoading || appCtrl.isLoading)
                    const CommonLoader()
                ]),
              ),
              if(chatCtrl.isUserProfile)
                const ChatUserProfile()
            ],
          )
              : Container());
    });
  }
}
