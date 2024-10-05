import 'package:flutter_sound/public/flutter_sound_player.dart';

import '../../../../../config.dart';

class StopArrowIcons extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isPlaying;
  const StopArrowIcons({Key? key,this.onPressed,this.isPlaying=false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: Sizes.s50,
        width: Sizes.s50,
        decoration: BoxDecoration(
            color: appCtrl.isTheme
                ? appCtrl.appTheme.white
                : appCtrl.appTheme.primary,
            borderRadius:
            const BorderRadius.all(Radius.circular(100))),
        child: IconButton(
            onPressed: onPressed,
            color: appCtrl.appTheme.black,
            icon: Icon(
             isPlaying? Icons.stop
                  : Icons.play_arrow
                 ,
              color: appCtrl.appTheme.black,
            )));
  }
}
