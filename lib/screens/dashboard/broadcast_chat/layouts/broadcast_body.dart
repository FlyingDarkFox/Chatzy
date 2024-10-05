import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:chatzy_web/screens/dashboard/broadcast_chat/layouts/broadcast_profile/broadcast_profile.dart';
import 'package:flutter/cupertino.dart';

import '../../../../config.dart';
import 'broadcast_app_bar.dart';
import 'broadcast_box.dart';
import 'broadcast_message.dart';

class BroadcastBody extends StatelessWidget {
  const BroadcastBody({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BroadcastChatController>(
      builder: (chatCtrl) {
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
                            const BroadCastAppBar(),
                            // List of messages
                            const BroadcastMessage(),
                            // Sticker
                            Container(),
                            // Input content
                            const BroadcastInputBox(),
                            if (chatCtrl.isShowSticker)
                  chatCtrl.showBottomSheet()
                          ]),
                ),
                if (chatCtrl.isUserProfile) const BroadcastProfile()
              ],
            );
      }
    );
  }
}
