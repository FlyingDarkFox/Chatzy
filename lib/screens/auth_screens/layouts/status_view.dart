import 'dart:developer';
import 'package:story_time/story_page_view/story_page_view.dart';
import 'package:video_player/video_player.dart';

import '../../../../config.dart';
import '../../../models/status_model.dart';
import '../../../utils/type_list.dart';

bool isSwipeUp = false;

class StatusScreenView extends StatefulWidget {
  final Status? statusData;

  const StatusScreenView({Key? key, this.statusData}) : super(key: key);

  @override
  State<StatusScreenView> createState() => _StatusScreenViewState();
}

class _StatusScreenViewState extends State<StatusScreenView> {
  late ValueNotifier<IndicatorAnimationCommand> indicatorAnimationController;
  VideoPlayerController? videoController;
  bool startedPlaying = false;
  Status? status;
  int position = 0;
  List seenBy = [];

  @override
  void initState() {
    super.initState();

    indicatorAnimationController = ValueNotifier<IndicatorAnimationCommand>(
      IndicatorAnimationCommand(resume: true),
    );
    status = widget.statusData;
    setState(() {});
    log("INITR : $status");
  }

  @override
  void dispose() {
    indicatorAnimationController.dispose();
    super.dispose();
  }

  getData(newStoryIndex) async {
    if (status!.photoUrl![newStoryIndex].statusType == StatusType.video.name) {

      videoController =
          VideoPlayerController.networkUrl(Uri.parse(status!.photoUrl![newStoryIndex].image!))
            ..initialize().then((_) {
              videoController!.play();

              // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
              setState(() {});
            }).onError((error, stackTrace) {
              log("ONERROR  : $error");
              log("stackTrace  : $stackTrace");
            });
      videoController!.initialize().then((_) => setState(() {}));
    }
    await Future.delayed(DurationsClass.s3);
    if (status!.photoUrl![newStoryIndex].statusType == StatusType.video.name) {
      log("INIT : ${videoController!.value.isInitialized}");
      if (videoController!.value.isInitialized) {
        indicatorAnimationController.value = IndicatorAnimationCommand(
            duration: videoController!.value.duration);
      } else {
        indicatorAnimationController.value = IndicatorAnimationCommand(
          duration: const Duration(seconds: 5),
        );
      }
    } else {
      indicatorAnimationController.value = IndicatorAnimationCommand(
        duration: const Duration(seconds: 5),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          StoryPageView(
            onStoryIndexChanged: (int newStoryIndex) async {
              if (newStoryIndex == 0) {
                indicatorAnimationController.value = IndicatorAnimationCommand(
                  duration: const Duration(seconds: 5),
                );
              }


              await getData(newStoryIndex);
              log("INDICATOR : ${indicatorAnimationController.value.duration}");

              dynamic user = appCtrl.storage.read(session.user);

              position = position + 1;
              int lastPosition = position - 1;

              if (status!.uid != appCtrl.user["id"]) {
                log("CHECK L: ${(position - 1) < status!.photoUrl!.length}");
                if ((position - 1) < status!.photoUrl!.length) {
                  FirebaseFirestore.instance
                      .collection(collectionName.users)
                      .doc(status!.uid)
                      .collection(collectionName.status)
                      .limit(1)
                      .get()
                      .then((doc) {
                    if (doc.docs.isNotEmpty) {
                      Status getStatus = Status.fromJson(doc.docs[0].data());
                      log("getStatus : ${doc.docs[0].id}");
                      List<PhotoUrl> photoUrl = getStatus.photoUrl!;
                      bool isSeen = photoUrl[lastPosition]
                          .seenBy!
                          .where(
                              (element) => element["uid"] == appCtrl.user["id"])
                          .isNotEmpty;
                      if (!isSeen) {
                        photoUrl[lastPosition].seenBy!.add({
                          "uid": appCtrl.user["id"],
                          "seenTime": DateTime.now().millisecondsSinceEpoch
                        });
                        log("SEEN L %${photoUrl[lastPosition].seenBy}");
                        FirebaseFirestore.instance
                            .collection(collectionName.users)
                            .doc(status!.uid)
                            .collection(collectionName.status)
                            .doc(doc.docs[0].id)
                            .update({
                          "photoUrl": photoUrl.map((e) => e.toJson()).toList()
                        });
                      }

                      if (position == status!.photoUrl!.length) {
                        List seenAll = status!.seenAllStatus!;
                        if (!seenAll.contains(status!.uid)) {
                          seenAll.add(status!.uid);
                        }
                        FirebaseFirestore.instance
                            .collection(collectionName.users)
                            .doc(status!.uid)
                            .collection(collectionName.status)
                            .doc(doc.docs[0].id)
                            .update({"seenAllStatus": seenAll});
                      }
                    }
                  });
                }
              } else {
                FirebaseFirestore.instance
                    .collection(collectionName.users)
                    .doc(FirebaseAuth.instance.currentUser != null
                        ? appCtrl.user["id"]
                        : user["id"])
                    .collection(collectionName.status)
                    .limit(1)
                    .get()
                    .then((doc) {
                  if (doc.docs.isNotEmpty) {
                    Status getStatus = Status.fromJson(doc.docs[0].data());
                    log("getStatus : ${doc.docs[0].id}");
                    List<PhotoUrl> photoUrl = getStatus.photoUrl!;
                    seenBy = photoUrl[lastPosition].seenBy!;
                    setState(() {});
                    log("seenBy : $seenBy");
                  }
                });
              }
            },
            onStoryUnpaused: () {
              log("Story is unpaused!!");
            },
            onStoryPaused: () {
              log("Story is paused!!");
            },
            onPageBack: (val) {
              position = position - 1;
            },
            itemBuilder: (context, pageIndex, storyIndex) {
              final story = status!.photoUrl![storyIndex];
              Color? finalColor;
              if (story.statusType == StatusType.video.name) {
                if (videoController!.value.isInitialized) {
                  log("VIDEO 2: ${videoController!.value.duration}");
                  log("VIDEO 2: ${indicatorAnimationController.value.duration}");
                }
              }

              if (story.statusType == StatusType.image.name ||
                  story.statusType == StatusType.text.name) {}
              if (story.statusType == StatusType.text.name) {
                int value = int.parse(story.statusBgColor!, radix: 16);
                finalColor = Color(value);
              }
              return Stack(
                children: [
                  Positioned.fill(child: Container(color: Colors.black)),
                  Positioned.fill(
                    child: story.statusType == StatusType.text.name
                        ? Container(
                            decoration: BoxDecoration(color: finalColor),
                            padding: const EdgeInsets.symmetric(
                                horizontal: Insets.i24, vertical: Insets.i16),
                            child: Center(
                              child: Text(
                                story.statusText!,
                                style: AppCss.manropeBold24
                                    .textColor(appCtrl.appTheme.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            //color: backgroundColor,
                          )
                        : story.statusType == StatusType.video.name
                            ? videoController!.value.isInitialized
                                ? AspectRatio(
                        aspectRatio: videoController!
                            .value.aspectRatio,

                        // Use the VideoPlayer widget to display the video.
                        child: VideoPlayer(
                          videoController!,
                        )).height(Sizes.s100).width(Sizes.s100)
                                : Container()
                            : Image.network(
                                story.image!,
                                fit: BoxFit.cover,
                              ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 44, left: 8),
                    child: Row(
                      children: [
                        Container(
                          height: 32,
                          width: 32,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(status!.profilePic!),
                              fit: BoxFit.cover,
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          status!.username!,
                          style: const TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
            gestureItemBuilder: (context, pageIndex, storyIndex) {
              return Stack(children: [
                Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                        padding: const EdgeInsets.only(top: 32),
                        child: IconButton(
                            padding: EdgeInsets.zero,
                            color: appCtrl.appTheme.white,
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              Navigator.pop(context);
                            })))
              ]);
            },
            indicatorAnimationController: indicatorAnimationController,
            initialStoryIndex: (pageIndex) {
              return 0;
            },
            pageLength: 1,
            storyLength: (int pageIndex) {
              return status!.photoUrl!.length;
            },
            onPageLimitReached: () {
              Get.back();
            },
          )
        ],
      ),
    );
  }
}
