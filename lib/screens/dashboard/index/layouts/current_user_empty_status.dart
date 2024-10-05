

import '../../../../config.dart';
import 'my_status_layout.dart';


class CurrentUserEmptyStatus extends StatelessWidget {
  final GestureTapCallback? onTap;
  final String? currentUserId;

  const CurrentUserEmptyStatus({super.key, this.onTap, this.currentUserId})
     ;

  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(collectionName.users).doc(appCtrl.user["id"])

            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {

            if(snapshot.data!.exists){

              return  MyStatusLayout(image: snapshot.data!.data()!["image"],name: appCtrl.user["name"],).inkWell(onTap: onTap);
            }else{
              return Container();
            }

          } else {
            return Container();
          }
        });
  }
}
