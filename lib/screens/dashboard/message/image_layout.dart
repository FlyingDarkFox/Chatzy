import '../../../../config.dart';
import '../../../../widgets/common_asset_image.dart';
import '../../../../widgets/common_image_layout.dart';
import 'icon_circle.dart';

class ImageLayout extends StatelessWidget {
  final String? id;
  final bool isLastSeen, isImageLayout;
  final double? width,height;
  const ImageLayout(
      {super.key, this.id, this.isLastSeen = true, this.isImageLayout = false, this.width, this.height})
     ;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(collectionName.users)
            .doc(id)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            if (!snapshot.data!.exists) {

              return Stack(children: [
                CommonAssetImage(
                    height: height ??( isImageLayout ? Sizes.s40 : Sizes.s52),
                    width:width ?? (isImageLayout ? Sizes.s40 : Sizes.s52)),
                if (isLastSeen)
                  if(snapshot.data!.data() != null)
                  snapshot.data!.data()!["status"] != "Offline" ?
                     const Positioned(right: 3, bottom: 10, child: IconCircle()) : Container()
              ]);
            } else {
              return Stack(children: [
                CommonImage(
              height: height ??( isImageLayout ? Sizes.s40 : Sizes.s52),
          width:width ?? (isImageLayout ? Sizes.s40 : Sizes.s52),
                    image: (snapshot.data!).data()!["image"] ?? "",
                    name: (snapshot.data!).data()!["name"] ?? ""),
                if (isLastSeen)
                  if ((snapshot.data!).data()!["status"] != "Offline")
                    const SizedBox(height: Sizes.s10, width: Sizes.s10)
                        .decorated(
                        color: appCtrl.appTheme.online,
                        borderRadius: BorderRadius.circular(AppRadius.r20),
                        border: Border.all(
                            color: appCtrl.appTheme.sameWhite, width: 1))
                        .paddingOnly( left: Insets.i3)
              ]);
            }
          } else {
            return Stack(children: [
              CommonAssetImage(
                  height: height ??( isImageLayout ? Sizes.s40 : Sizes.s52),
                  width:width ?? (isImageLayout ? Sizes.s40 : Sizes.s52)),
            ]);
          }
        });
  }
}
