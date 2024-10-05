import 'package:smooth_corner/smooth_corner.dart';

import '../../config.dart';

class ButtonCommon extends StatelessWidget {
  final String title;
  final double? padding, margin, radius, height, appFontSize, width;
  final GestureTapCallback? onTap;
  final TextStyle? style;
  final Color? color, fontColor, borderColor;
  final Widget? icon;
  final FontWeight? fontWeight;


  const ButtonCommon(
      {super.key,
      required this.title,
      this.padding,
      this.margin = 0,
      this.radius = AppRadius.r9,
      this.height = 46,
      this.appFontSize = FontSize.f30,
      this.onTap,
      this.style,
      this.color,
      this.fontColor,
      this.icon,
      this.borderColor,
      this.width,
      this.fontWeight = FontWeight.w700})
     ;

  @override
  Widget build(BuildContext context) {
    return SmoothContainer(
        width: width ?? MediaQuery.of(context).size.width,
        height: height,
        margin: EdgeInsets.symmetric(horizontal: margin!),
        color: appCtrl.appTheme.primary,
        borderRadius: BorderRadius.circular(radius!),
        side: BorderSide(color:  borderColor ?? appCtrl.appTheme.trans),
     smoothness: 1,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          if (icon != null)
            Row(children: [icon ?? const HSpace(0), const HSpace(Sizes.s10)]),
          Text(title.tr,
              textAlign: TextAlign.center,
              style: style ??
                  AppCss.manropeBold15.textColor(appCtrl.appTheme.sameWhite))
        ])).inkWell(onTap: onTap);
  }
}
