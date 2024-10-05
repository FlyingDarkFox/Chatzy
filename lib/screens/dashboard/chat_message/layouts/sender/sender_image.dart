
import 'package:intl/intl.dart';
import 'package:smooth_corner/smooth_corner.dart';
import '../../../../../config.dart';

class SenderImage extends StatelessWidget {
  final MessageModel? document;
  final VoidCallback? onPressed, onLongPress;
  final bool isBroadcast;
  final String? userId;

  const   SenderImage({super.key, this.document, this.onPressed, this.onLongPress,this.isBroadcast =false,this.userId})
     ;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        InkWell(
            onLongPress: onLongPress,
            onTap:onPressed,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SmoothContainer(
                  color: appCtrl.appTheme.primary,
                  smoothness: 1,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppRadius.r20),
                    topRight: Radius.circular(AppRadius.r20),
                    bottomRight: Radius.circular(AppRadius.r20),
                  ),
                  padding: EdgeInsets.all(Insets.i10),
                  child: ClipRRect(

                    borderRadius: BorderRadius.circular(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CachedNetworkImage(
                          placeholder: (context, url) => Container(
                              width: Sizes.s160,
                              decoration: BoxDecoration(
                                color: appCtrl.appTheme.primary,
                                borderRadius: BorderRadius.circular(AppRadius.r8),
                              ),
                              child: Container()),
                          imageUrl: decryptMessage(document!.content),
                          width: Sizes.s160,
                          imageBuilder: (context, imageProvider) =>
                              SmoothContainer(
                                  width: Sizes.s160,
                                  smoothness: 1,
                                  borderRadius:
                                  BorderRadius.circular(AppRadius.r8),
                                  child: SmoothClipRRect(
                                      smoothness: 1,
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image(
                                        image: imageProvider,
                                      ))),
                          fit: BoxFit.fill,
                        ),
                        Row(

                          children: [
                            if (document!.isFavourite != null)
                              if (document!.isFavourite == true)
                                if(appCtrl.user["id"].toString() == document!.favouriteId.toString())
                                Icon(Icons.star,
                                    color: appCtrl.appTheme.sameWhite, size: Sizes.s10),
                            const HSpace(Sizes.s3),
                            if (!isBroadcast)
                              Icon(Icons.done_all_outlined,
                                  size: Sizes.s15,
                                  color: document!.isSeen == true
                                      ? appCtrl.appTheme.sameWhite
                                      : appCtrl.appTheme.tick),
                            const HSpace(Sizes.s5),
                            Text(
                              DateFormat('hh:mm a').format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      int.parse(document!.timestamp!))),
                              style: AppCss.manropeMedium12
                                  .textColor(appCtrl.appTheme.sameWhite),
                            )
                          ],
                        ).paddingAll(Insets.i10)
                      ],
                    ),
                  ),
                ),

              ],
            )),
        if (document!.emoji != null)
          EmojiLayout(emoji: document!.emoji)
      ],
    ).paddingOnly(bottom: Insets.i10);
  }
}
