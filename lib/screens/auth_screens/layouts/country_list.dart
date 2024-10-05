import 'dart:developer';

import 'package:country_list_pick/country_list_pick.dart';
import '../../../../config.dart';
import '../../../responsive.dart';

class CountryListLayout extends StatelessWidget {
  final Function(CountryCode?)? onChanged;
  final String? dialCode;
  const CountryListLayout({Key? key,this.onChanged,this.dialCode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
log("dialCode :$dialCode");
    return Container(
      width: Responsive.isMobile(context) ? Sizes.s105: Sizes.s125,
            padding: EdgeInsets.symmetric(vertical: Insets.i8),
            child: CountryListPick(
                appBar: AppBar(
                    centerTitle: true,
                    title: Text(appFonts.selectCountry.tr,
                        style: AppCss.manropeSemiBold18
                            .textColor(appCtrl.appTheme.white)),
                    elevation: 0,
                    backgroundColor: appCtrl.appTheme.primary),
                pickerBuilder: (context, CountryCode? countryCode) {
                  log("COD :$countryCode");
                  return Row(children: [
                    if(!Responsive.isMobile(context))
                    Container(
                        height: Responsive.isMobile(context) ?Sizes.s20 :Sizes.s25,
                        width: Responsive.isMobile(context) ?Sizes.s20 :Sizes.s25,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.fill  ,
                                image: AssetImage(
                              countryCode!.flagUri.toString(),
                              package: 'country_list_pick',
                            )),
                            shape: BoxShape.circle)),
                    if(!Responsive.isMobile(context))
                    const HSpace(Sizes.s3),
                    Expanded(
                      child: Text("( ${dialCode.toString()} )",
                              overflow: TextOverflow.ellipsis,
                              style: AppCss.manropeMedium13
                                  .textColor(appCtrl.appTheme.txt)),
                    ),
                     HSpace(Responsive.isMobile(context)?Sizes.s10 : Sizes.s12),
                    SvgPicture.asset(
                      eSvgAssets.arrowDown,height: Sizes.s20,width: Sizes.s20,

                    )
                  ]);
                },
                theme: CountryTheme(
                    alphabetSelectedBackgroundColor: appCtrl.appTheme.primary),
                initialSelection: dialCode,
                onChanged: onChanged))
        .decorated(
            color: appCtrl.appTheme.greyText.withOpacity(0.05),
            border: Border.all(color:appCtrl.appTheme.borderColor),
            borderRadius:
                const BorderRadius.all(Radius.circular(AppRadius.r8)));
  }
}
