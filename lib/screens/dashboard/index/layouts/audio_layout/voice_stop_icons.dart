import 'package:flutter_sound/public/flutter_sound_recorder.dart';

import '../../../../../config.dart';

class VoiceStopIcons extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isRecording;
  const VoiceStopIcons({Key? key,this.onPressed,this.isRecording=false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
        height: Sizes.s50,
        width: Sizes.s50,
        decoration: BoxDecoration(
          color: appCtrl.isTheme
              ? appCtrl.appTheme.white
              : appCtrl.appTheme.primary,
          borderRadius:
          const BorderRadius.all(Radius.circular(100)),
        ),
        child: IconButton(
            onPressed: onPressed,
            icon: isRecording ? Icon(Icons.stop,
                color: appCtrl.appTheme.white)
                : Icon(Icons.settings_voice,
                color: appCtrl.appTheme.white)
                ));
  }
}
