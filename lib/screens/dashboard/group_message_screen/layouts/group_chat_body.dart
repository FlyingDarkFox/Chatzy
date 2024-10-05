import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';

import '../../../../config.dart';
import '../group_profile/group_profile.dart';
import 'group_app_bar.dart';
import 'group_input_box.dart';
import 'group_message_box.dart';

class GroupChatBody extends StatelessWidget {
  const GroupChatBody({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GroupChatMessageController>(builder: (chatCtrl) {
      return chatCtrl.isCamera
          ? Stack(
              alignment: Alignment.bottomCenter,
              children: [
                chatCtrl.imageFile != null
                    ? Image.memory(
                        chatCtrl.webImage,
                        height: MediaQuery.of(context).size.height,
                      )
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
                        if (chatCtrl.imageFile != null) {
                          await chatCtrl.uploadCameraImage();
                          chatCtrl.isCamera = false;
                          chatCtrl.update();
                        } else {
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
                      child: Icon(chatCtrl.imageFile != null
                          ? Icons.arrow_forward
                          : Icons.camera_alt),
                    ).marginOnly(bottom: Insets.i20, right: Insets.i15),
                    FloatingActionButton(
                      // Provide an onPressed callback.
                      onPressed: () async {
                        chatCtrl.isCamera = false;
                        chatCtrl.update();
                        chatCtrl.cameraController!.dispose();
                      },
                      child: const Icon(CupertinoIcons.multiply),
                    ).marginOnly(bottom: Insets.i20),
                  ],
                )
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: Column(children: <Widget>[
                    // List of messages
                    GroupChatMessageAppBar(onSelected: (result) async {

                      if (result == 0) {
                        log("RESULT:");
                        await chatCtrl.permissionHandelCtrl
                            .getCameraMicrophonePermissions(context)
                            .then((value) {
                          log("ss :$value");
                          if (value == true) {
                            chatCtrl.audioAndVideoCall(false);
                          }
                        });
                      } else if (result == 1) {
                        await chatCtrl.permissionHandelCtrl
                            .getCameraMicrophonePermissions(context)
                            .then((value) {

                          if (value == true) {

                            chatCtrl.audioAndVideoCall(true);
                          }
                        });
                      }
                    }),
                    const GroupMessageBox(),

                    Container(), // Input content
                    const GroupInputBox(),
                    if (chatCtrl.isShowSticker) chatCtrl.showBottomSheet()
                  ]).height(MediaQuery.of(context).size.height).inkWell(
                      onTap: () {
                    chatCtrl.enableReactionPopup = false;
                    chatCtrl.showPopUp = false;
                    chatCtrl.isChatSearch = false;
                    chatCtrl.update();
                  }),
                ),
                if (chatCtrl.isUserProfile) const GroupProfile()
              ],
            );
    });
  }
}
