
import '../../../../config.dart';

class GlassMorphicLayout extends StatelessWidget {
  final LinearGradient? linearGradient;
  final Widget? child;

  const GlassMorphicLayout({Key? key, this.child, this.linearGradient})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      width: MediaQuery.of(context).size.width,
alignment: Alignment.center,
      height: MediaQuery.of(context).size.height,
      color: appCtrl.appTheme.white,
      child: child
    );
  }
}
