import 'package:intl/intl.dart';
import 'package:smooth_corner/smooth_corner.dart';

import '../../../../../config.dart';

class ReceiverImage extends StatelessWidget {
  final MessageModel? document;
  final GestureLongPressCallback? onLongPress;
  final GestureTapCallback? onTap;

  const ReceiverImage({super.key, this.document, this.onLongPress, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: onLongPress,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              SmoothContainer(
                  color: appCtrl.appTheme.white,
                  smoothness: 1,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppRadius.r20),
                    topRight: Radius.circular(AppRadius.r20),
                    bottomRight: Radius.circular(AppRadius.r20),
                  ),
                  padding: EdgeInsets.all(Insets.i10),
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
                        imageUrl: decryptMessage(document!.content!),
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
                              if (appCtrl.user["id"].toString() ==
                                  document!.favouriteId.toString())
                                Icon(Icons.star,
                                    color: appCtrl.appTheme.greyText,
                                    size: Sizes.s10),
                          const HSpace(Sizes.s3),
                          Text(
                            DateFormat('hh:mm a').format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    int.parse(document!.timestamp!))),
                            style: AppCss.manropeMedium12
                                .textColor(appCtrl.appTheme.greyText),
                          ).marginSymmetric(
                              horizontal: Insets.i5, vertical: Insets.i8),
                        ],
                      ).paddingAll(Insets.i5)
                    ],
                  )),
              if (document!.emoji != null) EmojiLayout(emoji: document!.emoji)
            ],
          ),
        ],
      ),
    ).paddingSymmetric(horizontal: Insets.i15);
  }
}
