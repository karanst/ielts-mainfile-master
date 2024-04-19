import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_navigation/src/routes/default_route.dart';
import 'package:ielts/exam_panel.dart/controllers/question_page/question_paper_controller.dart';
import 'package:ielts/exam_panel.dart/screens/home/home_screen.dart';
import 'package:ielts/exam_panel.dart/screens/introduction/introduction.dart';
import 'package:ielts/exam_panel.dart/screens/splash/splash_screen.dart';
import 'package:ielts/screens/credits_screen.dart';
import 'package:ielts/screens/forums_screen.dart';
import 'package:ielts/screens/listening_screen.dart';
import 'package:ielts/screens/premium_screen.dart';
import 'package:ielts/utils/app_constants.dart';
import 'package:ielts/screens/blog_screen.dart';
import 'package:ielts/screens/home_screen.dart';
import 'package:ielts/chat/screens/splach_screen.dart';
import 'package:ielts/screens/quiz_screen.dart';
import 'package:ielts/screens/quiz_screen.dart';
import 'package:ielts/screens/reading_screen.dart';
import 'package:ielts/screens/reset_password_screen.dart';
import 'package:ielts/screens/settings_screen.dart';
import 'package:ielts/screens/speaking_screen.dart';
import 'package:ielts/screens/splash_screen.dart';
import 'package:ielts/screens/vocabulary_screen.dart';
import 'package:ielts/screens/writing_screen.dart';
import 'package:ielts/screens/login_screen.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePaths.chats:
        return MaterialPageRoute<Widget>(builder: (_) => SplashScreens());
      case RoutePaths.root:
        return MaterialPageRoute<Widget>(builder: (_) => SplashScreen());
      case RoutePaths.login:
        return MaterialPageRoute<Widget>(
            builder: (_) => LoginScreen1(
                  title: '',
                ));
      case RoutePaths.home:
        return MaterialPageRoute<Widget>(builder: (_) => HomeScreen());
      case RoutePaths.vocabulary:
        return MaterialPageRoute<Widget>(builder: (_) => VocabularyScreen());
      case RoutePaths.writing:
        return MaterialPageRoute<Widget>(builder: (_) => WritingScreen());
      case RoutePaths.speaking:
        return MaterialPageRoute<Widget>(builder: (_) => SpeakingScreen());
      case RoutePaths.reading:
        return MaterialPageRoute<Widget>(builder: (_) => ReadingScreen());
      case RoutePaths.listening:
        return MaterialPageRoute<Widget>(builder: (_) => ListeningScreen());
      case RoutePaths.resetpassword:
        return MaterialPageRoute<Widget>(
            builder: (_) => ResetPasswordScreen(
                  title: '',
                ));
      case RoutePaths.blog:
        return MaterialPageRoute<Widget>(builder: (_) => BlogScreen());
      case RoutePaths.quiz:
        return MaterialPageRoute<Widget>(builder: (_) => QuizScreen());
      case RoutePaths.settings:
        return MaterialPageRoute<Widget>(builder: (_) => SettingsPage());
      case RoutePaths.credits:
        return MaterialPageRoute<Widget>(builder: (_) => CreditsScreen());
      case RoutePaths.forum:
        return MaterialPageRoute<Widget>(builder: (_) => ForumsScreen());
      case RoutePaths.premium:
        return MaterialPageRoute<Widget>(builder: (_) => PremiumScreen());

// exam panel

      case RoutePaths.start:
        return MaterialPageRoute<Widget>(builder: (_) => SplashScreen2());
      case RoutePaths.introduction:
        return MaterialPageRoute<Widget>(
            builder: (_) => AppIntroductionScreen());
      // case RoutePaths.examHome:
      //   return MaterialPageRoute<Widget>(builder: (_) => ExamHomeScreen());
      case RoutePaths.examHome:
        return GetPageRoute(
          page: () => ExamHomeScreen(),
          binding: BindingsBuilder(
            () {
              Get.put(QuestionPaperController());
            },
          ),
        );
      default:
        return MaterialPageRoute<Widget>(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
