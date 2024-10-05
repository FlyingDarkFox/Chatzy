import 'dart:developer';

import '../../../../config.dart';
import '../../../../utils/story_dotted_lines.dart';

class MyStatusLayout extends StatelessWidget {
  final String? image, name;

  const MyStatusLayout({super.key, this.image, this.name});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Stack(alignment: Alignment.bottomRight, children: [
        Stack(
          alignment: Alignment.center,
          children: [
            RotatedBox(
                quarterTurns: 1,
                child: SizedBox(
                    width: Sizes.s60,
                    height: Sizes.s60,
                    child: CustomPaint(
                        painter: DottedBorders(
                            numberOfStories: [], spaceLength: 0)))),
            image != null && image != ""
                ? CachedNetworkImage(
                imageUrl: image!,
                imageBuilder: (context, imageProvider) => Container(
                    height: Sizes.s55,
                    width: Sizes.s55,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.cover, image: imageProvider))),
                placeholder: (context, url) => Container(
                  height: Sizes.s55,
                  width: Sizes.s55,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: appCtrl.appTheme.primary),
                  child: Text(
                      name != null
                          ? name!.length > 2
                          ? name!
                          .replaceAll(" ", "")
                          .substring(0, 2)
                          .toUpperCase()
                          : name![0]
                          : "C",
                      style: AppCss.manropeblack16
                          .textColor(appCtrl.appTheme.white)),
                ))
                : Container(
              height: Sizes.s55,
              width: Sizes.s55,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: appCtrl.appTheme.white),
              child: Text(
                  name != null && name != ""
                      ? name!.length > 2
                      ? name!
                      .replaceAll(" ", "")
                      .substring(0, 2)
                      .toUpperCase()
                      : name![0]
                      : "C",
                  style: AppCss.manropeblack16
                      .textColor(appCtrl.appTheme.primary)),
            ),

          ],
        ),
        if(appCtrl.usageControlsVal != null ? appCtrl.usageControlsVal!.allowCreatingStatus ?? true:true)
        SizedBox(
                child: Icon(Icons.add,
                        size: Sizes.s15, color: appCtrl.appTheme.sameWhite)
                    .paddingAll(Insets.i2))
            .decorated(
                color: appCtrl.appTheme.primary,
                borderRadius: BorderRadius.circular(AppRadius.r20),
                border: Border.all(color: appCtrl.appTheme.sameWhite, width: 1))
      ]),
      const VSpace(Sizes.s5),
      Text(appFonts.myStory.tr,
          style: AppCss.manropeLight12.textColor(appCtrl.appTheme.darkText))
    ]).height(90);
  }
}
