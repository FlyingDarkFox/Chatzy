import 'package:chatzy_web/screens/auth_screens/layouts/language_layout.dart';

import '../../../../config.dart';

class DarkLanguageLayout extends StatelessWidget {
  const DarkLanguageLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
        height: Sizes.s55,
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [

           LanguageLayout(),
           SizedBox(width: Sizes.s16 * 0.5)
        ]));
  }
}
