import '../../../../config.dart';

class SelectedUsers extends StatelessWidget {
  final dynamic data;
  final GestureTapCallback? onTap;

  const SelectedUsers({Key? key, this.data, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            width: Sizes.s80,
            padding: const EdgeInsets.fromLTRB(
                Insets.i12, Insets.i10, Insets.i12, Insets.i10),
            child: Column(children: [
              CachedNetworkImage(
                  imageUrl: data["image"].toString(),
                  imageBuilder: (context, imageProvider) => CircleAvatar(
                      backgroundColor: appCtrl.appTheme.greyText.withOpacity(0.2),
                      radius: AppRadius.r30,
                      backgroundImage: NetworkImage(data["image"].toString())),
                  placeholder: (context, url) => CircleAvatar(
                        backgroundColor: appCtrl.appTheme.greyText.withOpacity(0.2),
                        radius: AppRadius.r30,
                        child:
                            const Icon(Icons.person, color: Color(0xffCCCCCC)),
                      ),
                  errorWidget: (context, url, error) => const CircleAvatar(
                        backgroundColor: Color(0xffE6E6E6),
                        radius: 30,
                        child: Icon(
                          Icons.person,
                          color: Color(0xffCCCCCC),
                        ),
                      )),
              const VSpace(Sizes.s8),
              Text(data["name"].toString(),
                  maxLines: 1, overflow: TextOverflow.ellipsis)
            ])),
        Positioned(
          right: Insets.i18,
          top: Insets.i5,
          child: InkWell(
              onTap: onTap,
              child: Container(
                  width: Sizes.s20,
                  height: Sizes.s20,
                  padding: const EdgeInsets.all(2.0),
                  decoration:  BoxDecoration(
                      shape: BoxShape.circle, color: appCtrl.appTheme.black),
                  child:  Icon(Icons.close,
                      size: Sizes.s14, color: appCtrl.appTheme.white)) //............
              ),
        )
      ],
    );
  }
}
