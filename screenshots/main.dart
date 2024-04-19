// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:admob_flutter/admob_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ielts/screens/home_screen.dart';
import 'package:ielts/utils/app_constants.dart';
import 'package:ielts/locator.dart';
import 'package:ielts/utils/themeChange.dart';
import 'package:ielts/utils/router.dart' as rt;
import 'package:ielts/utils/theme.dart';
import 'package:ielts/viewModels/blogCrudModel.dart';
import 'package:ielts/viewModels/listeningCrudModel.dart';
import 'package:ielts/viewModels/quizCrudModel.dart';
import 'package:ielts/viewModels/readingCrudModel.dart';
import 'package:ielts/viewModels/speakingCrudModel.dart';
import 'package:ielts/viewModels/writingCrudModel.dart';
import 'package:ielts/widgets/adsHelper.dart';
import 'package:ielts/widgets/facebookAds.dart';
import 'package:ielts/widgets/remote-config.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future initFirebase() async {

  await Firebase.initializeApp();
}

 main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await Admob.initialize();
  await  initFirebase();
  await  Config.initConfig();
  // await FacebookConfig.initFbConfig();
  await MyAds.initRemoteConfig();
   // await FacebookAdsManager.init();
  await AdHelper.initAds();
  setupLocator();
  var darkModeOn = false;
  SharedPreferences.getInstance().then((prefs) {
    if (prefs.containsKey('darkMode')) {
      darkModeOn = prefs.getBool('darkMode') ?? true;
    } else {
      prefs.setBool('darkMode', darkModeOn);
    }
    runApp(
      ChangeNotifierProvider<ThemeNotifier>(
        create: (_) => ThemeNotifier(darkModeOn ? darkTheme : lightTheme),
        child: MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
  FirebaseAnalyticsObserver(analytics: analytics);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => locator<CrudModel>()),
          ChangeNotifierProvider(create: (_) => locator<SpeakingCrudModel>()),
          ChangeNotifierProvider(create: (_) => locator<ReadingCrudModel>()),
          ChangeNotifierProvider(create: (_) => locator<ListeningCrudModel>()),
          ChangeNotifierProvider(create: (_) => locator<BlogCrudModel>()),
          ChangeNotifierProvider(create: (_) => locator<QuizCrudModel>()),
        ],
        child: Consumer<ThemeNotifier>(
          builder: (context, themeNotifier, child) {
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'IELTS',
              initialRoute: RoutePaths.root,
              theme: themeNotifier.getTheme(),
              onGenerateRoute: rt.Router.generateRoute,
            // home: HomeScreen(),
            );

          },
        ));
  }
}
