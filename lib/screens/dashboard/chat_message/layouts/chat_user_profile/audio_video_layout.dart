import '../../../../../config.dart';

class AudioVideoButtonLayout extends StatelessWidget {
  final GestureTapCallback? callTap, videoTap, addTap;
  final bool isGroup;

  const AudioVideoButtonLayout(
      {super.key,
      this.callTap,
      this.videoTap,
      this.isGroup = false,
      this.addTap})
     ;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Column(children: [
        SvgPicture.asset(eSvgAssets.call,
            height: Sizes.s18, colorFilter: ColorFilter.mode( appCtrl.appTheme.primary, BlendMode.srcIn),),
        const VSpace(Sizes.s10),
        Text(appFonts.audio.tr,
            style: AppCss.manropeMedium12.textColor(appCtrl.appTheme.darkText))
      ])
          .paddingSymmetric(vertical: Insets.i15, horizontal: Insets.i12)
          .decorated(
              color: appCtrl.appTheme.white,
              borderRadius: BorderRadius.circular(AppRadius.r10),
              boxShadow: [
            const BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.08),
                spreadRadius: 2,
                blurRadius: 12)
          ]).inkWell(onTap: callTap),
      const HSpace(Sizes.s15),
      Column(
        children: [
          SvgPicture.asset(eSvgAssets.video,
              height: Sizes.s18,  colorFilter: ColorFilter.mode( appCtrl.appTheme.primary, BlendMode.srcIn)),
          const VSpace(Sizes.s10),
          Text(appFonts.video.tr,
              style:
                  AppCss.manropeMedium12.textColor(appCtrl.appTheme.darkText))
        ],
      )
          .paddingSymmetric(vertical: Insets.i15, horizontal: Insets.i12)
          .decorated(
              color: appCtrl.appTheme.white,
              borderRadius: BorderRadius.circular(AppRadius.r10),
              boxShadow: [
            const BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.08),
                spreadRadius: 2,
                blurRadius: 12)
          ]).inkWell(onTap: videoTap),
      const HSpace(Sizes.s15),

    ]);
  }
}
