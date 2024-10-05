import '../../../config.dart';
import '../../controllers/common_controllers/language_controller.dart';

class LanguageScreen extends StatelessWidget {
  final languageCtrl = Get.put(LanguageController());

  LanguageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LanguageController>(builder: (_) {
      return GetBuilder<AppController>(builder: (appCtrl) {
        return Scaffold(
          backgroundColor: appCtrl.appTheme.white,
          body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //language list
                ...appArray.languageList.asMap().entries.map((e) {
                  return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: Insets.i12, horizontal: Insets.i10),
                      child: InkWell(
                        onTap: () => languageCtrl.languageSelection(e.value),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                              unselectedWidgetColor: appCtrl.appTheme.greyText,
                              disabledColor: appCtrl.appTheme.greyText),
                          child: RadioListTile(
                              dense: true,
                              visualDensity: const VisualDensity(
                                  horizontal: VisualDensity.minimumDensity,
                                  vertical: VisualDensity.minimumDensity),
                              value: e.key,
                              groupValue: appCtrl.currVal,
                              contentPadding: EdgeInsets.zero,
                              title: Row(children: [
                                Text(trans(e.value['name'].toString()),
                                    style: AppCss.manropeSemiBold14.textColor(
                                        appCtrl.isTheme
                                            ? appCtrl.appTheme.white
                                            : appCtrl.appTheme.darkText)),
                                const HSpace(Sizes.s15),
                                Text(
                                    "-   ${e.value['name'].toString().toCapitalized()}",
                                    style: AppCss.manropeMedium12
                                        .textColor(appCtrl.appTheme.greyText))
                              ]),
                              onChanged: (int? val) {
                                appCtrl.currVal = val!;
                                languageCtrl.languageSelection(e.value);
                              },
                              activeColor: appCtrl.appTheme.primary),
                        ),
                      ));
                }).toList()
              ]),
        );
      });
    });
  }
}
