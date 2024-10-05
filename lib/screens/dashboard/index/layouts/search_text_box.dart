

import '../../../../config.dart';

class SearchTextBox extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const SearchTextBox({Key? key, this.controller, this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldCommon(
      controller: controller,
      onChanged: onChanged,
      vertical: Insets.i20,
      border: const OutlineInputBorder(borderSide: BorderSide.none),
      prefixIcon: SvgPicture.asset(eSvgAssets.search,
              height: Sizes.s20,
              fit: BoxFit.contain,
              colorFilter: ColorFilter.mode(appCtrl.appTheme.greyText, BlendMode.srcIn),)
          .marginSymmetric(horizontal: Insets.i8, vertical: Insets.i10), hintText:appFonts.searchHere.tr,
    ).marginSymmetric(horizontal:Responsive.isMobile(context) ? Insets.i20:  Insets.i30);
  }
}
