import 'package:smooth_corner/smooth_corner.dart';

import '../../../../../config.dart';

class BlockReportLayout extends StatelessWidget {

  final String? name,icon;
  final GestureTapCallback? onTap;
  const BlockReportLayout({super.key,this.name,this.icon,this.onTap});

  @override
  Widget build(BuildContext context) {
    return SmoothContainer(
        width: MediaQuery.of(context).size.width,
        color: const Color(0xFFFFEDED),
        margin: const EdgeInsets.symmetric(vertical: Insets.i7),
        padding: const EdgeInsets.symmetric(
            vertical: Insets.i16, horizontal: Insets.i18),
        borderRadius: BorderRadius.circular(AppRadius.r12),
        smoothness: 1,

        child: Row(children: [
          SvgPicture.asset(
             icon!,
             colorFilter: ColorFilter.mode(appCtrl.appTheme.redColor, BlendMode.srcIn)),
          const HSpace(Sizes.s10),
          Text(
              name!,
              style: AppCss.manropeSemiBold14
                  .textColor(appCtrl.appTheme.redColor))
        ])).inkWell(onTap: onTap);
  }
}
