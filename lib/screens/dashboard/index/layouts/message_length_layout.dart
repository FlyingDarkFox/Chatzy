import '../../../../config.dart';
import '../../../../utils/general_utils.dart';

class MessageLengthLayout extends StatelessWidget {
  const MessageLengthLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<IndexController  >(
      builder: (indexCtrl) {
        return StreamBuilder(
            stream: FirebaseFirestore
                .instance
                .collection(
                collectionName.users)
                .doc(
                indexCtrl.user["id"])
                .collection(
                collectionName.chat)
                .snapshots(),
            builder: (context,
                snapshot) {
              if (snapshot.hasData) {
                int number = getUnseenMessagesNumber(
                    snapshot.data!
                        .docs);
                return number == 0
                    ? Container()
                    : Container(
                    height: Sizes.s20,
                    width: Sizes.s20,
                    alignment: Alignment
                        .center,
                    margin: const EdgeInsets
                        .only(
                        top: Insets.i5),
                    decoration: BoxDecoration(
                        shape: BoxShape
                            .circle,
                        gradient: RadialGradient(
                          colors: [
                            appCtrl
                                .appTheme
                                .lightText,
                            appCtrl
                                .appTheme
                                .primary
                          ],
                        )),
                    child: Text(
                        number
                            .toString(),
                        textAlign: TextAlign
                            .center,
                        style: AppCss
                            .manropeSemiBold10
                            .textColor(
                            appCtrl
                                .appTheme
                                .darkText)
                            .textHeight(
                            1.3))
                );
              } else {
                return Container();
              }
            });
      }
    );
  }
}
