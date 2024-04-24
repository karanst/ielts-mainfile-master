import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ielts/chat/api/apis.dart';
import 'package:ielts/exam_panel.dart/configs/theme/app_dart_theme.dart';
import 'package:ielts/exam_panel.dart/configs/theme/app_light_theme.dart';
import 'package:ielts/exam_panel.dart/controllers/question_page/question_paper_controller.dart';
import 'package:ielts/exam_panel.dart/controllers/theme_controller.dart';
import 'package:ielts/exam_panel.dart/firebase_ref/firebase_storage_service.dart';

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

import 'package:ielts/widgets/remote-config.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:in_app_update/in_app_update.dart';

import 'chat/screens/home_screen.dart';

 late Size mq;
Future initFirebase() async {
  await Firebase.initializeApp();
}

Future<void> _initIAP() async {
  try {
    await FlutterInappPurchase.instance.initialize();
  } catch (e) {
    print('Failed to initialize in-app purchase: $e');
  }
}

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.lazyPut(() => FirebaseStorageService());


  await initFirebase();
  _initIAP();
  // await FacebookAdsManager.init();
  await Config.initConfig();
  await AdHelper.initAds();
  MobileAds.instance.initialize;
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

class MyApp extends StatefulWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //update

  @override
  void initState() {
    super.initState();
    checkForUpdate();
    // FirebaseMessaging.onBackgroundMessage(_handleMessage);

    APIs.getFirebaseMessagingToken(context);
  }

  Future<void> checkForUpdate() async {
    print('Checking for update...');
    InAppUpdate.checkForUpdate().then((info) {
      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        print('Update available');
        // Prompt user to update
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: Text('New Update Available'),
            content: Text('Please update to the latest version to continue.'),
            actions: <Widget>[
              TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).primaryColor),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  update();
                },
                child: Text('Update Now'),
              ),
            ],
          ),
        );
      }
    }).catchError((e) {
      print('Failed to check for update: $e');
    });
  }

  void update() async {
    print('Starting update...');
    await InAppUpdate.startFlexibleUpdate();
    print('Update started');
  }

  // Future<void> _handleMessage(RemoteMessage message) {
  //   if (message.messageId !=null) {
  //     Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreens()));
  //
  //   }
  //   return Future<void>.value();
  // }
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
              // theme: Get.find<ThemeController>().darkTheme,
              onGenerateRoute: rt.Router.generateRoute,
              // home: HomeScreen(),
            );
          },
        ));
  }
}
