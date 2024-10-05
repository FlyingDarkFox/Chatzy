import 'dart:developer';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:universal_html/html.dart' as html;

import 'common/languages/index.dart';
import 'config.dart';
import 'controllers/app_pages_controllers/contact_list_controller.dart';

// DO NOT CHANGE THIS KEY
const encryptedKey = "MyCHATZY32lengthENCRYPTKEY132456";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // We're using the manual installation on non-web platforms since Google sign in plugin doesn't yet support Dart initialization.
  // See related issue: https://github.com/flutter/flutter/issues/96391
  GetStorage.init();
  Get.put(AppController());

  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "Your Firebase Api key",
        authDomain: "Your Firebase Auth Domain",
        projectId: "Your Firebase Project Id",
        storageBucket: "Your Firebase Storage Bucket Id",
        messagingSenderId: "Your Firebase Messaging Sender Id",
        appId: "Your Firebase App Id",
        measurementId: "Your Firebase Measurement Id"),
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var scaffoldKey = GlobalKey<ScaffoldState>(debugLabel: "key2");

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    html.window.onBeforeUnload.listen((event) async {
      if (appCtrl.user != null) {
        await FirebaseFirestore.instance
            .collection(collectionName.users)
            .doc(appCtrl.user["id"])
            .collection(collectionName.userContact)
            .get()
            .then((value) {
          if (value.docs.isNotEmpty) {
            value.docs.asMap().entries.forEach((element) {
              element.value.reference.delete();
            });
          }
        });
      }
    });
    appCtrl.isLogin = html.window.localStorage[session.isLogin] ?? "false";
    appCtrl.id = html.window.localStorage[session.id] ?? "fals";
    log("ISLOGIN : ${appCtrl.isLogin}");
    appCtrl.user = appCtrl.storage.read(session.user) ?? "";
    appCtrl.update();
    SystemChrome.setApplicationSwitcherDescription(
        ApplicationSwitcherDescription(
      label: appFonts.chatzy.tr,
      primaryColor: Theme.of(context).primaryColor.value,
    ));
    return FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, AsyncSnapshot<SharedPreferences> snapData) {
          if (snapData.hasData) {
            appCtrl.pref = snapData.data;
            appCtrl.update();

            return MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => FetchContactController()),
              ],
              child: GetMaterialApp(
                debugShowCheckedModeBanner: false,
                // translations: Language(),
                locale: const Locale('en', 'US'),
                fallbackLocale: const Locale('en', 'US'),
                // tran
                title: appFonts.chatzy.tr,
                home: appCtrl.isLogin == "true"
                    ? Title(
                        title: appFonts.chatzy.tr,
                        color: appCtrl.appTheme.black,
                        child: IndexLayout(
                          pref: snapData.data,
                        ))
                    : LoginScreen(
                        pref: snapData.data,
                      ),
                getPages: appRoute.getPages,
                theme: AppTheme.fromType(ThemeType.light).themeData,
                darkTheme: AppTheme.fromType(ThemeType.dark).themeData,
                themeMode: ThemeService().theme,
                scrollBehavior: MyCustomScrollBehavior(),
              ),
            );
          } else {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => FetchContactController()),
              ],
              child: GetMaterialApp(
                debugShowCheckedModeBanner: false,
                translations: Language(),
                locale: const Locale('en', 'US'),
                fallbackLocale: const Locale('en', 'US'),
                // tran
                title: appFonts.chatzy.tr,
                home: Center(
                    child: Image.asset(
                  eImageAssets.splash,
                  // replace your Splashscreen icon
                  width: Sizes.s210,
                )),
                getPages: appRoute.getPages,
                theme: AppTheme.fromType(ThemeType.light).themeData,
                darkTheme: AppTheme.fromType(ThemeType.dark).themeData,
                themeMode: ThemeService().theme,
                scrollBehavior: MyCustomScrollBehavior(),
              ),
            );
          }
        });
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
