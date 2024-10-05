import '../config.dart';

class CommonEmptyLayout extends StatelessWidget {
  final String? title,desc,gif;
  const CommonEmptyLayout({Key? key,this.title,this.desc,this.gif}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(gif!,height: Sizes.s150),
            const VSpace(Sizes.s18),
            Text(title!,style: AppCss.manropeBold16.textColor(appCtrl.appTheme.darkText)).paddingSymmetric(vertical: Insets.i10),

            Text(desc!,textAlign: TextAlign.center,style: AppCss.manropeMedium14.textColor(appCtrl.appTheme.greyText).textHeight(1.5))
          /*  Image.asset(gif!,height: Sizes.s150),
            const VSpace(Sizes.s18),
            Text(title!,style: AppCss.manropeblack16.textColor(appCtrl.appTheme.darkText)),
            const VSpace(Sizes.s6),
            Text(desc!,textAlign: TextAlign.center,style: AppCss.manropeLight14.textColor(appCtrl.appTheme.greyText).textHeight(1.6).letterSpace(.2)).marginSymmetric(horizontal: Insets.i35),*/
          ]),
    );
  }
}
