import 'package:intl/intl.dart';
import 'package:smooth_corner/smooth_corner.dart';
import '../../../../config.dart';


class LocationLayout extends StatelessWidget {
  final GestureTapCallback? onTap;
  final VoidCallback? onLongPress;
  final MessageModel? document;
  final bool isReceiver, isBroadcast;

  const LocationLayout(
      {super.key,
      this.onLongPress,
      this.onTap,
      this.document,
      this.isReceiver = false,
      this.isBroadcast = false})
     ;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        InkWell(
            onTap: onTap,
            onLongPress: onLongPress,
            child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              SmoothContainer(
                  margin: const EdgeInsets.symmetric(horizontal: Insets.i8),
                  borderRadius:  BorderRadius.only(
                    topLeft: const Radius.circular(AppRadius.r20),
                    topRight: const Radius.circular(AppRadius.r20),
                    bottomLeft: Radius.circular(isReceiver ? 0 :AppRadius.r20),
                    bottomRight: Radius.circular(AppRadius.r20),
                  ),
                  color: appCtrl.appTheme.primary,
                  smoothness: 1,

                  child:
                      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    SmoothClipRRect(
                        smoothness: 1,
                        borderRadius: BorderRadius.circular(AppRadius.r15),
                        child: Image.asset(eImageAssets.map, height: Sizes.s150)),
                        Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                          if (document!.isFavourite != null)
                            if (document!.isFavourite == true)
                              if(appCtrl.user["id"].toString() == document!.favouriteId.toString())
                              Icon(Icons.star,
                                  color: appCtrl.appTheme.sameWhite, size: Sizes.s10),
                          const HSpace(Sizes.s3),
                          if (!isBroadcast && !isReceiver)
                            Icon(Icons.done_all_outlined,
                                size: Sizes.s15,
                                color: document!.isSeen== true
                                    ? appCtrl.appTheme.sameWhite
                                    : appCtrl.appTheme.tick),
                          const HSpace(Sizes.s5),
                          Text(
                              DateFormat('hh:mm a').format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      int.parse(document!.timestamp!))),
                              style:
                              AppCss.manropeBold12.textColor(appCtrl.appTheme.sameWhite))
                        ]).paddingAll(Insets.i6)
                  ]).paddingAll(Insets.i5)),

            ]).paddingOnly(bottom: Insets.i10)),
        if (document!.emoji != null)
          EmojiLayout(emoji: document!.emoji)
      ],
    );
  }
}
