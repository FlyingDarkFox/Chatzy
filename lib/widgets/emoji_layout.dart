import '../config.dart';

class EmojiLayout extends StatelessWidget {
  final String? emoji;
  const EmojiLayout({super.key,this.emoji});

  @override
  Widget build(BuildContext context) {
    return Text(emoji!,style: AppCss.manropeBold10)
        .paddingAll(Insets.i5)
        .decorated(
        shape: BoxShape.circle,

        color: appCtrl.appTheme.white).paddingSymmetric(horizontal: Insets.i15);
  }
}
