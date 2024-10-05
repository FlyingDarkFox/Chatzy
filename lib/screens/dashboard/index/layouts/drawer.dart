



import 'package:chatzy_web/controllers/app_pages_controllers/profile_screen_controller.dart';
import 'package:smooth_corner/smooth_corner.dart';

import '../../../../config.dart';
import '../../../../widgets/back_icon.dart';
import '../../../../widgets/common_image_layout.dart';
import '../../../../widgets/common_photo_view.dart';

class IndexDrawer extends StatelessWidget {

  final profileCtrl = Get.put(ProfileScreenController());

  final GestureTapCallback? onTap;
   IndexDrawer({Key? key,this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<IndexController>(builder: (indexCtrl) {
      return GetBuilder<ProfileScreenController>(
        builder: (_) {
          return ValueListenableBuilder<bool>(
              valueListenable: indexCtrl.drawerIndex,
              builder: (context, value, child) {

                return AnimatedContainer(
                  duration: Duration(seconds: !value ? 1 :0),
                  height: MediaQuery.of(context).size.height,

                  width: !value ? Sizes.s520 : 0,
                    color: appCtrl.appTheme.white ,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                      Row(mainAxisSize: MainAxisSize.min, children: [
                         const BackIcon(),
                        const HSpace(Sizes.s20),
                        Text(appFonts.profileSetting.tr,
                            style: GoogleFonts.manrope(
                              color: appCtrl.appTheme.darkText,
                              fontSize: FontSize.f22,
                              fontWeight: FontWeight.w600
                            ))
                      ])
                          .width(!value ? Sizes.s520 : 0)
                          .paddingOnly(top: Insets.i50,left:Responsive.isMobile(context)?Insets.i20: Insets.i30,right: Responsive.isMobile(context)?Insets.i20: Insets.i30,bottom: Insets.i35),
                        Divider(
                            color: appCtrl.appTheme.greyText.withOpacity(.20),
                            height: 0,
                            thickness: 1),
                    const VSpace(Sizes.s20),
                    Stack(
                      alignment: Alignment.topRight,
                      children: [
                        profileCtrl.imageFile != null ?SmoothContainer(
                            height: Sizes.s170,
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            smoothness: 1,
                            borderRadius: BorderRadius.circular(AppRadius.r10),
                            foregroundDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(AppRadius.r10),
                                image: DecorationImage(
                                    fit: BoxFit.cover, image:MemoryImage(profileCtrl.webImage))
                            )
                        ) :
                        /*CommonImage(
                            image: appCtrl.user["image"] ??"",
                            name: appCtrl.user["name"],
                            height: Sizes.s130,
                            width:MediaQuery.of(context).size.width)*/
                        appCtrl.user["image"] != null && appCtrl.user["image"]!=""?        CachedNetworkImage(
                          imageUrl: appCtrl.user["image"] ??"",
                          imageBuilder: (context, imageProvider) => SmoothClipRRect(
                            borderRadius: BorderRadius.circular(AppRadius.r10),
                            smoothness: 2,
                            child: Image(image: imageProvider,height: Sizes.s170,width:MediaQuery.of(context).size.width ,fit: BoxFit.cover,).inkWell(onTap: (){
                              Get.to(CommonPhotoView(image: appCtrl.user["image"]));
                            }),
                          ),
                          placeholder: (context, url) => SmoothContainer(
                              height: Sizes.s170,
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.center,
                              smoothness: 1,
                              borderRadius: BorderRadius.circular(AppRadius.r10),
                              foregroundDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(AppRadius.r10),
                                  image: DecorationImage(
                                      fit: BoxFit.cover, image:AssetImage(eImageAssets.anonymous))
                              )
                          ),
                          errorWidget: (context, url, error) => SmoothContainer(
                              height: Sizes.s170,
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.center,
                              smoothness: 1,
                              borderRadius: BorderRadius.circular(AppRadius.r10),
                              foregroundDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(AppRadius.r10),
                                  image: DecorationImage(
                                      fit: BoxFit.cover, image:AssetImage(eImageAssets.anonymous))
                              )
                          )): SmoothContainer(
                            height: Sizes.s170,
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            smoothness: 1,
                            borderRadius: BorderRadius.circular(AppRadius.r10),
                            foregroundDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(AppRadius.r10),
                                image: DecorationImage(
                                    fit: BoxFit.cover, image:AssetImage(eImageAssets.anonymous))
                            )
                        ),
                        Align(
                            alignment: Alignment.topRight,
                            child: SvgPicture.asset(eSvgAssets.edit,
                                height: Sizes.s16)
                                .paddingAll(Insets.i6)
                                .decorated(
                                color: appCtrl.appTheme.primaryLight,
                                shape: BoxShape.circle) .paddingAll(Insets.i2)
                                .decorated(
                                color: appCtrl.appTheme.white,
                                shape: BoxShape.circle).marginAll(Insets.i15).inkWell(onTap: ()=> profileCtrl.documentShare()))

                      ],
                    ).paddingSymmetric(horizontal: Responsive.isMobile(context) ?Insets.i20: Insets.i30),
                    Divider(color: appCtrl.appTheme.divider,height: 0).marginSymmetric(vertical: Insets.i20),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(appFonts.displayName.tr,
                            style: AppCss.manropeBold15.textColor(
                                appCtrl.appTheme.darkText)),
                        const VSpace(Sizes.s8),
                        TextFieldCommon(hintText: appFonts.enterYourName.tr,
                            controller: profileCtrl.userNameController,
                            validator: (name) =>
                                Validation().nameValidation(name)
                        ),
                        const VSpace(Sizes.s20),
                        Text(appFonts.email.tr,
                            style: AppCss.manropeBold15.textColor(
                                appCtrl.appTheme.darkText)),
                        const VSpace(Sizes.s8),
                        TextFieldCommon(hintText: appFonts.enterYourEmail.tr,
                            controller: profileCtrl.emailController,
                            validator: (email) =>
                                Validation().emailValidation(email)),
                        const VSpace(Sizes.s20),
                        Text(appFonts.addStatus.tr,
                            style: AppCss.manropeBold15.textColor(
                                appCtrl.appTheme.darkText)),
                        const VSpace(Sizes.s8),
                        TextFieldCommon(hintText: appFonts.writeHere.tr,
                            suffixIcon: SvgPicture.asset(eSvgAssets.emojis,height: Sizes.s20,width: Sizes.s20,fit: BoxFit.scaleDown).inkWell(onTap: ()=> profileCtrl.onTapEmoji()),
                            controller: profileCtrl.statusController,
                            validator: (name) =>
                                Validation().nameValidation(name)),
                        const VSpace(Sizes.s48),
                        ButtonCommon(title:profileCtrl.isLoading ? "": appFonts.saveProfile.tr,onTap: ()=> profileCtrl.uploadFile(),
                        icon: profileCtrl.isLoading ?    CircularProgressIndicator(color: appCtrl.appTheme.sameWhite,):null),

                      ],
                    ).marginSymmetric(horizontal: Insets.i25)
                  ]) .width(!value ? Sizes.s520 : 0)
                );
              });
        }
      );
    });
  }
}
