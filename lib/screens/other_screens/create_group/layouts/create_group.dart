

import 'package:chatzy_web/screens/dashboard/group_message_screen/group_firebase_api.dart';
import 'package:smooth_corner/smooth_corner.dart';

import '../../../../config.dart';
import '../../../../controllers/app_pages_controllers/create_group_controller.dart';
import '../group_firebase_api.dart';

class CreateGroup extends StatelessWidget {

  const CreateGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Builder(
        builder: (context) {
          return GetBuilder<CreateGroupController>(builder: (groupCtrl) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                  color: appCtrl.appTheme.trans,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(16),
                  height: MediaQuery.of(context).size.height /4,
                  width: MediaQuery.of(context).size.width /2,
                  child: Form(
                    key: groupCtrl.formKey,
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const VSpace(Sizes.s15),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              appFonts.newGroup.tr,
                              textAlign: TextAlign.left,
                              style: AppCss.manropeBold16
                                  .textColor(appCtrl.appTheme.darkText),
                            ),
                          ),
                          const VSpace(Sizes.s20),
                          Row(
                            children: [
                              groupCtrl.pickerCtrl.image != null
                                  ? Container(
                                      height: Sizes.s60,
                                      width: Sizes.s60,
                                      decoration: BoxDecoration(
                                          color: appCtrl.appTheme.greyText
                                              .withOpacity(.2),
                                          shape: BoxShape.circle),
                                      child: groupCtrl.isLoading ? const CircularProgressIndicator() : groupCtrl.imageUrl != "" ? Image.network(
                                          groupCtrl.imageUrl,
                                          fit: BoxFit.fill) : Image.memory(
                                              groupCtrl.webImage,
                                              fit: BoxFit.fill)
                                          .clipRRect(all: AppRadius.r50),
                                    ).inkWell(onTap: () {
                                      groupCtrl.pickerCtrl
                                          .imagePickerOption(context,isCreateGroup: true);
                                    })
                                  : Image.asset(
                                      eImageAssets.anonymous,
                                      height: Sizes.s30,
                                      width: Sizes.s30,
                                      color: appCtrl.appTheme.white,
                                    )
                                      .paddingAll(Insets.i15)
                                      .decorated(
                                          color: appCtrl.appTheme.greyText
                                              .withOpacity(.4),
                                          shape: BoxShape.circle)
                                      .inkWell(
                                          onTap: () => groupCtrl.pickerCtrl
                                              .imagePickerOption(context,isCreateGroup: true)),
                              const HSpace(Sizes.s15),
                              Expanded(
                                child:  TextFieldCommon(hintText:groupCtrl.isGroup ? appFonts.addGroupTitle : appFonts.addBroadcastTitle,
                                  suffixIcon: SvgPicture.asset(eSvgAssets.emojis,height: Sizes.s20,width: Sizes.s20,fit: BoxFit.scaleDown),
                                  controller: groupCtrl.txtGroupName,
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return groupCtrl.isGroup ? "Group Name Required" : "Broadcast Name Required" ;
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                               /* child: CommonTextBox(
                                  controller: groupCtrl.txtGroupName,
                                  labelText: appFonts.groupName.tr,
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return "Group Name Required";
                                    } else {
                                      return null;
                                    }
                                  },
                                  maxLength: 25,
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: appCtrl.appTheme.blackColor)),
                                  textInputAction: TextInputAction.next,
                                ),*/
                              ),
                            ],
                          ),
                          const VSpace(Sizes.s20),


                          SmoothContainer(
                           padding: const EdgeInsets.symmetric(vertical: 15),
                              width:250,
                              smoothness: 1,
                              color:  appCtrl.appTheme.primary,
                              margin: const EdgeInsets.symmetric(horizontal: 200,),
                              borderRadius: BorderRadius.circular(12),
                              alignment: Alignment.center,
                              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [

                                Text(groupCtrl.isLoading ? "Loading..." :  appFonts.done.tr, textAlign: TextAlign.center, style: AppCss.manropeMedium14
                                    .textColor(appCtrl.appTheme.white))
                              ])).inkWell(onTap: () =>
                              GroupFirebaseApi().createGroup(groupCtrl,context))
                        ]),
                  )),
            );
          });
        }
      );
    });
  }
}
