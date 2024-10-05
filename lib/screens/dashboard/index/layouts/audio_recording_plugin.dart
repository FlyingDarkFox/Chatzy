import 'dart:async';
import 'dart:developer';
import 'dart:io';


import 'package:audioplayers/audioplayers.dart';
import 'package:record/record.dart';
import 'package:smooth_corner/smooth_corner.dart';
import 'package:universal_html/html.dart' as html;

import 'package:chatzy_web/config.dart';

import 'audio_layout/stop_arrow_icons.dart';
import 'audio_layout/voice_stop_icons.dart';

enum AudioState { recording, stop, play, notStarted }

class AudioRecordingPlugin extends StatefulWidget {
  final String? type;
  final int? index;

  const AudioRecordingPlugin({Key? key, this.type, this.index})
      : super(key: key);

  @override
  AudioRecordingPluginState createState() => AudioRecordingPluginState();
}

class AudioRecordingPluginState extends State<AudioRecordingPlugin> {
//  FlutterSoundRecorder? mRecorder = FlutterSoundRecorder();
  bool isLoading = false;

  // Codec codec = Codec.aacMP4;
  late String recordFilePath;
  int counter = 0;
  String statusText = "";
  bool isRecording = false;
  bool isComplete = false;
  bool mPlaybackReady = false;
  String mPath = 'tau_file.mp4';
  Timer? _timer;
  int recordingTime = 0;
  String? filePath;
  bool mPlayerIsInit = false;
  bool mRecorderIsInited = false;
  File? recordedFile;

  // FlutterSoundPlayer? mPlayer = FlutterSoundPlayer();
  bool isPlaying = false,
      isSupported = true,
      isAlertShow = false;

  // MicrophoneRecorder? recorder;
  AudioState audioState = AudioState.notStarted;

  AudioPlayer player = AudioPlayer();

  final record = AudioRecorder();
  String? outputPath;

  Future<void> checkPermission() async {
    final permission =
    await html.window.navigator.permissions?.query({'name': 'microphone'});
    log("permission : ${permission!.state}");
    if (permission.state == 'prompt' || permission.state == "denied") {
      WidgetsFlutterBinding.ensureInitialized();
      dynamic value =
      await html.window.navigator.getUserMedia(audio: true, video: true);
      log("AUDIO : $value");
    }
  }

  // record audio
  getRecorderFn(context) {
    /* if (isSupported) {
      if (!mRecorderIsInited || !mPlayer!.isStopped) {
        log("audioState : $mRecorderIsInited");
        log("audioState : $mPlayer");
        return null;
      }
      if (audioState == AudioState.notStarted) {
        record();
      } else {
        stopRecorder();
      }
    }else{
      isAlertShow =true;
      setState(() {

      });
    }*/
  }

  startTimer() {
    log("recordingTime :$recordingTime");
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      recordingTime++;
      log("recordingTime :$recordingTime");
      setState(() {});
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    //recorder = MicrophoneRecorder()..init();
    /* recorder = MicrophoneRecorder()
      ..init().onError((error, stackTrace) {
        isSupported = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(error.toString()),
          backgroundColor: appCtrl.appTheme.greenColor,
        ));
      });*/
    player.onPlayerStateChanged.listen((s) {
      if (s == PlayerState.stopped || s == PlayerState.completed) {
        isPlaying = false;
        setState(() {

        });
      }
    });
    super.initState();
  }

  // play recorded audio
  getPlaybackFn() {
    handleAudioState();
  }

  void handleAudioState() async {
    String recording = 'record';

    bool isRecord = await record.isRecording();

    if (!isRecord) {
      if (await record.hasPermission()) {
        log("isRecording : $isRecording");
        setState(() {
          recording = "recording";
          isRecording = true;
        });
        isAlertShow = false;
        await record.start(RecordConfig(),path: "$outputPath");
        startTimer();
      } else {
        isAlertShow = true;
        setState(() {

        });
      }
    } else {
      outputPath = await record.stop();
      _timer!.cancel();
      if (outputPath != null) {
        setState(() {
          isRecording = false;
          recording = "recorderstopped";
        });
      }
    }
  }

  // play recorded audio
  void play() {

    if (!isPlaying) {
      isPlaying = true;
      player.play(DeviceFileSource(outputPath!));
    } else {
      isPlaying = false;
      player.stop();
    }
    setState(() {

    });
    /* assert(mPlayerIsInit &&
        mPlaybackReady &&
        mRecorder!.isStopped &&
        mPlayer!.isStopped);
    mPlayer!
        .startPlayer(
            fromURI: mPath,
            whenFinished: () {
              setState(() {});
            })
        .then((value) {
      setState(() {});
    });*/
  }

  // stop player
  void stopPlayer() {
    /* mPlayer!.stopPlayer().then((value) {
      _timer!.cancel();
      recordedFile = File(mPath);
      setState(() {});
    });*/
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          InkWell(
              onTap: () {
                Get.back();
              },
              child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: Insets.i5),
                  child: Icon(Icons.cancel)))
        ]),
        const SizedBox(height: Sizes.s20),
        if (isAlertShow)
          Text(
            appFonts.notSupport.tr,
            style: AppCss.manropeblack16.textColor(appCtrl.appTheme.redColor),
          ).marginOnly(bottom: Insets.i5),
        Container(
            width: MediaQuery
                .of(context)
                .size
                .width * 0.95,
            decoration: BoxDecoration(
                color: appCtrl.appTheme.greyText.withOpacity(.5),
                borderRadius:
                const BorderRadius.all(Radius.circular(AppRadius.r30))),
            padding: const EdgeInsets.all(0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  //audio start and stop icon
                  VoiceStopIcons(
                      onPressed: () => getPlaybackFn(),
                      isRecording: isRecording),
                  Text(recordingTime.toString(),
                      style: AppCss.manropeMedium14
                          .textColor(appCtrl.appTheme.txt)),
                  StopArrowIcons(
                    onPressed: () => play(),
                    isPlaying: isPlaying,
                  )
                ])),
        const VSpace(Sizes.s10),
        SmoothContainer(

            width: MediaQuery.of(context).size.width,
            smoothness: 1,
            color:  appCtrl.isTheme
                ? appCtrl.appTheme.white
                : appCtrl.appTheme.primary,
            padding: EdgeInsets.symmetric(vertical: 20),
            borderRadius: BorderRadius.circular(12),
            alignment: Alignment.center,
            child: Text(appFonts.done.tr, textAlign: TextAlign.center, style:  AppCss.manropeMedium12.textColor(appCtrl.appTheme.white))).inkWell( onTap: () {
          stopPlayer();

          Get.back(result: outputPath);
        }),
        if (isLoading)
          Padding(
            padding: const EdgeInsets.all(Insets.i10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                      height: Sizes.s20,
                      width: Sizes.s20,
                      child: CircularProgressIndicator()),
                  const HSpace(Sizes.s10),
                  Text(appFonts.audioProcess.tr)
                ]),
          )
      ],
    );
  }
}
