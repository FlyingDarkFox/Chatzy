import 'package:dotted_border/dotted_border.dart';
import 'package:video_player/video_player.dart';
import '../../../../config.dart';
import 'dart:math';

import '../../../../utils/story_dotted_lines.dart';
import '../../../../utils/type_list.dart';
import '../../../../widgets/common_image_layout.dart';

double radius = 27.0;

double colorWidth(double radius, int statusCount, double separation) {
  return ((2 * pi * radius) - (statusCount * separation)) / statusCount;
}

double separation(int statusCount) {
  if (statusCount <= 20) {
    return 3.0;
  } else if (statusCount <= 30) {
    return 1.8;
  } else if (statusCount <= 60) {
    return 1.0;
  } else {
    return 0.3;
  }
}

class StatusLayout extends StatefulWidget {
  final Status? snapshot;
  final GestureTapCallback? onTap,addTap;

  const StatusLayout({Key? key, this.snapshot, this.onTap, this.addTap}) : super(key: key);

  @override
  State<StatusLayout> createState() => _StatusLayoutState();
}

class _StatusLayoutState extends State<StatusLayout> {
  VideoPlayerController? videoController;
  late Future<void> initializeVideoPlayerFuture;
  bool startedPlaying = false;

  @override
  void initState() {
    // TODO: implement initState
    if (widget.snapshot!.photoUrl![widget.snapshot!.photoUrl!.length - 1]
            .statusType ==
        StatusType.video.name) {
      videoController = VideoPlayerController.networkUrl(
        Uri.parse(widget
            .snapshot!.photoUrl![widget.snapshot!.photoUrl!.length - 1].image!)
      );
      initializeVideoPlayerFuture = videoController!.initialize();
    }
    setState(() {});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

      Stack(
        alignment: Alignment.bottomRight,
        children: [
          Stack(alignment: Alignment.center, children: [
            RotatedBox(
                quarterTurns: 1,
                child: SizedBox(
                    width: Sizes.s55,
                    height: Sizes.s55,
                    child: CustomPaint(
                        painter: DottedBorders(
                            numberOfStories: widget.snapshot!.photoUrl!,
                            spaceLength:
                            widget.snapshot!.photoUrl!.length == 1
                                ? 0
                                : 4)))),
            widget.snapshot!.photoUrl![widget.snapshot!.photoUrl!.length - 1]
                        .statusType ==
                    StatusType.text.name
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: Insets.i4),
                    height: Sizes.s50,
                    width: Sizes.s50,
                    alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Color(int.parse(widget.snapshot!.photoUrl![widget.snapshot!.photoUrl!.length - 1].statusBgColor!,
                        radix: 16)),
                    shape: BoxShape.circle),
                    child: Text(
                      widget
                          .snapshot!
                          .photoUrl![widget.snapshot!.photoUrl!.length - 1]
                          .statusText!,
                      textAlign: TextAlign.center,
                      style: AppCss.manropeMedium10
                          .textColor(appCtrl.appTheme.white),
                    ))
                : widget.snapshot!.photoUrl![widget.snapshot!.photoUrl!.length - 1]
                            .statusType ==
                        StatusType.image.name
                    ? CommonImage(
                        height: Sizes.s50,
                        width: Sizes.s50,
                        image: widget
                            .snapshot!
                            .photoUrl![widget.snapshot!.photoUrl!.length - 1]
                            .image!
                            .toString(),
                        name: widget.snapshot!.username)
                    :ClipRRect(
                clipBehavior: Clip.hardEdge,
                borderRadius: SmoothBorderRadius(cornerRadius: 50, cornerSmoothing: 1),
                child: videoController!.value.isInitialized
                    ? AspectRatio(
                  aspectRatio:
                  videoController!.value.aspectRatio,
                  // Use the VideoPlayer widget to display the video.
                  child: VideoPlayer(videoController!),
                ).height(Sizes.s55).width(Sizes.s55)
                    : Container(
                    padding: const EdgeInsets.symmetric(horizontal: Insets.i4),
                    height: Sizes.s55,
                    width: Sizes.s55,
                    alignment: Alignment.center,
                    decoration: ShapeDecoration(
                        color: appCtrl.appTheme.primary,
                        shape: SmoothRectangleBorder(
                          borderRadius: SmoothBorderRadius(
                              cornerRadius: 12,
                              cornerSmoothing: 1),
                        )),
                    child: const Text("C")))
          ]),
          if(appCtrl.usageControlsVal != null ? appCtrl.usageControlsVal!.allowCreatingStatus ?? true:true)
            SizedBox(
                child: Icon(Icons.add,
                    size: Sizes.s15, color: appCtrl.appTheme.sameWhite)
                    .paddingAll(Insets.i2))
                .decorated(
                color: appCtrl.appTheme.primary,
                borderRadius: BorderRadius.circular(AppRadius.r20),
                border: Border.all(color: appCtrl.appTheme.sameWhite, width: 1)).inkWell(onTap: widget.addTap)
        ],
      ),
      const VSpace(Sizes.s5),
      Text(widget.snapshot!.username!,
          overflow: TextOverflow.ellipsis,
          style: AppCss.manropeMedium12.textColor(appCtrl.appTheme.darkText))
    ]).inkWell(onTap: widget.onTap);
  }
}
