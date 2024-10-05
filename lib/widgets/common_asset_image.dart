import '../config.dart';

class CommonAssetImage extends StatelessWidget {
  final double? height,width;
  const CommonAssetImage({super.key,this.width,this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            color: appCtrl.appTheme.white,
            shape: BoxShape.circle),
        child: Image.asset(eImageAssets.profileAnon,
            height: height,
            width: width,
            fit: BoxFit.cover,
            color: appCtrl.appTheme.darkText)
            .paddingAll(Insets.i15));
  }
}
