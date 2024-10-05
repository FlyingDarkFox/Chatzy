import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:smooth_corner/smooth_corner.dart';
import 'package:universal_html/html.dart' as html;
import '../../../../config.dart';

class AudioDoc extends StatefulWidget {
  final VoidCallback? onLongPress, onTap;
  final MessageModel? document;
  final bool isReceiver, isBroadcast;

  const AudioDoc(
      {super.key,
      this.onLongPress,
      this.document,
      this.isReceiver = false,
      this.isBroadcast = false,
      this.onTap});

  @override
  State<AudioDoc> createState() => _AudioDocState();
}

class _AudioDocState extends State<AudioDoc> with WidgetsBindingObserver {
  /// Optional
  int timeProgress = 0;
  int audioDuration = 0;
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration positions = Duration.zero;
  AudioPlayer audioPlayer = AudioPlayer();
  int value = 2;

  Future<void> checkPermission() async {
    final permission =
    await html.window.navigator.permissions?.query({'name': 'microphone'});
    log("permission : ${permission!.state}");
    if (permission.state == 'prompt' || permission.state == "denied") {
      WidgetsFlutterBinding.ensureInitialized();
      await html.window.navigator.getUserMedia(audio: true, video: true);
    }

  }

  void play() async {
    log("play");
    audioPlayer.play().then((value) {
      setState(() {
        isPlaying = true;
      });
    });
    isPlaying = true;
    setState(() {});
  }

  void pause() {
    isPlaying = false;
    setState(() {});
    log("SATTE : ${audioPlayer.processingState}");
    audioPlayer.pause();
    setState(() {});
  }

  void seek(Duration position) {
    log("pso :$position");
    audioPlayer.seek(position);
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }

  /// Optional
  Widget slider() {
    return StreamBuilder<Duration?>(
        stream: audioPlayer.positionStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            timeProgress = snapshot.data!.inSeconds;
          }
          log("audioDuration : $audioDuration");
        return SliderTheme(
            data: SliderThemeData(
                overlayShape: SliderComponentShape.noThumb,
                trackHeight: 3,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7)),
            child: Slider(
                value: snapshot.hasData
                    ? snapshot.data!.inSeconds.toDouble()
                    : timeProgress.toDouble(),
                max: audioDuration.toDouble(),
                activeColor: appCtrl.appTheme.sameWhite,
                inactiveColor: widget.isReceiver
                    ? appCtrl.appTheme.white
                    : appCtrl.appTheme.sameWhite.withOpacity(0.3),
                onChanged: (value) async {
                  seekToSec(value.toInt());
                }));
      }
    );
  }

  @override
  void initState() {
    super.initState();
    checkPermission();
    /// Compulsory

    String url = decryptMessage(widget.document!.content).contains("-BREAK")
        ? decryptMessage(widget.document!.content).split("-BREAK-")[1]
        : decryptMessage(widget.document!.content);
    audioPlayer.setUrl(url);
    setState(() {});
    log("audioPlayer ; ${audioPlayer.duration}");
    log("audioPlayer ; ${audioPlayer.bufferedPosition}");
    audioPlayer.durationStream.listen((event) {
      log("DURATION SRRE: $event");
    });
    audioPlayer.bufferedPositionStream.listen((event) {
      audioDuration = event.inSeconds;
    });
    audioPlayer.playbackEventStream.listen((event) {
      timeProgress = audioPlayer.position.inSeconds;
      audioDuration = event.duration == null ? 0 : event.duration!.inSeconds;
    }, onError: (Object e, StackTrace stackTrace) {
      log('A stream error occurred: $e');
    });
    timeProgress = audioPlayer.position.inSeconds;
  }

  /// Optional
  void seekToSec(int sec) {
    Duration newPos = Duration(seconds: sec);
    audioPlayer
        .seek(newPos); // Jumps to t
    // Jumps to the given position within the audio file
  }

  /// Optional
  String getTimeString(int seconds) {
    String minuteString =
        '${(seconds / 60).floor() < 10 ? 0 : ''}${(seconds / 60).floor()}';
    String secondString = '${seconds % 60 < 10 ? 0 : ''}${seconds % 60}';
    return '$minuteString:$secondString'; // Returns a string with the format mm:ss
  }

  onStopPlay() async {
    if (isPlaying) {
      await  audioPlayer.stop();
    } else {
      play();
    }
    setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      audioPlayer.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        InkWell(
                onLongPress: widget.onLongPress,
                onTap: widget.onTap,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SmoothContainer(
                        margin: const EdgeInsets.symmetric(vertical: Insets.i5),
                        padding:
                            const EdgeInsets.symmetric(horizontal: Insets.i15),
                        color: widget.isReceiver
                            ? appCtrl.appTheme.primary.withOpacity(0.5)
                            : appCtrl.appTheme.primary,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(AppRadius.r18),
                          topRight: Radius.circular(AppRadius.r18),
                          bottomLeft: Radius.circular(AppRadius.r18),
                        ),
                        height: Sizes.s90,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                                //mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  if (!widget.isReceiver)
                                    Row(children: [
                                      decryptMessage(widget.document!.content)
                                              .contains("-BREAK-")
                                          ? SvgPicture.asset(
                                                  eSvgAssets.headPhone)
                                              .paddingAll(Insets.i10)
                                              .decorated(
                                                  color:
                                                      appCtrl.appTheme.redColor,
                                                  shape: BoxShape.circle)
                                          : Container()
                                    ]).paddingOnly(right: Insets.i5),
                                  if (widget.isReceiver)
                                    const HSpace(Sizes.s10),
                                  SizedBox(
                                          height: Sizes.s40,
                                          width: Sizes.s40,
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset(
                                                        isPlaying
                                                            ? eSvgAssets.pause
                                                            : eSvgAssets.arrow,
                                                        height: Sizes.s15,
                                                        width: Sizes.s15,
                                                        alignment:
                                                            Alignment.center,
                                                        fit: BoxFit.scaleDown,
                                                        colorFilter:
                                                            ColorFilter.mode(
                                                                appCtrl.appTheme
                                                                    .primary,
                                                                BlendMode
                                                                    .srcIn))
                                                    .paddingOnly(
                                                        left: isPlaying
                                                            ? 0
                                                            : Insets.i2)
                                              ]))
                                      .alignment(Alignment.center)
                                      .decorated(
                                          color: appCtrl.appTheme.sameWhite,
                                          shape: BoxShape.circle)
                                      .inkWell(onTap: () => onStopPlay())
                                      .padding(horizontal: Insets.i10),
                                  IntrinsicHeight(
                                      child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                        Column(children: [
                                          slider().width(
                                              widget.isReceiver ? 150 : 160),
                                          const VSpace(Sizes.s5),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                    getTimeString(timeProgress),
                                                    style: AppCss
                                                        .manropeMedium12
                                                        .textColor(appCtrl
                                                            .appTheme
                                                            .sameWhite)),
                                                const HSpace(Sizes.s80),
                                                Text(
                                                    getTimeString(
                                                        audioDuration),
                                                    style: AppCss
                                                        .manropeMedium12
                                                        .textColor(appCtrl
                                                            .appTheme
                                                            .sameWhite))
                                              ])
                                        ]).marginOnly(top: Insets.i16)
                                      ])),
                                ]),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (widget.document!.isFavourite != null)
                                  if (widget.document!.isFavourite == true)
                                    if (appCtrl.user["id"] ==
                                        widget.document!.favouriteId)
                                      Icon(Icons.star,
                                          color: appCtrl.appTheme.sameWhite,
                                          size: Sizes.s10),
                                const HSpace(Sizes.s3),
                                if (!widget.isReceiver && !widget.isBroadcast)
                                  Icon(Icons.done_all_outlined,
                                      size: Sizes.s15,
                                      color: widget.document!.isSeen == true
                                          ? appCtrl.appTheme.sameWhite
                                          : appCtrl.appTheme.tick),
                                const HSpace(Sizes.s5),
                                Text(
                                  DateFormat('hh:mm a').format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          int.parse(widget.document!.timestamp!
                                              .toString()))),
                                  style: AppCss.manropeMedium12
                                      .textColor(appCtrl.appTheme.sameWhite),
                                )
                              ],
                            ).marginSymmetric(vertical: Insets.i10)
                          ],
                        )),
                  ],
                )
                    /*.decorated(
                        color: appCtrl.appTheme.primary,
                        borderRadius: SmoothBorderRadius(
                            cornerRadius: 15, cornerSmoothing: 1))*/
                    .paddingSymmetric(horizontal: Insets.i10))
            .paddingOnly(bottom: Insets.i5),
        if (widget.document!.emoji != null)
          EmojiLayout(emoji: widget.document!.emoji)
      ],
    );
  }
}
