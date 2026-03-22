import 'package:get/get.dart';
import 'package:lokse/modules/auth/login/login_page.dart';
import 'package:lokse/modules/auth/profile/profile_page.dart';
import 'package:lokse/modules/auth/register/register_page.dart';
import 'package:lokse/modules/navigation/navigation_page.dart';
import 'package:lokse/modules/onboarding/onboarding_page.dart';
import 'package:lokse/modules/splash/splash_page.dart';

import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashPage(),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingPage(),
    ),
    GetPage(
      name: AppRoutes.navigation,
      page: () => NavigationPage(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => RegisterPage(),
    ),
    // GetPage(
    //   name: AppRoutes.home,
    //   page: () => const navi(),
    // ),
    // GetPage(
    //   name: AppRoutes.learn,
    //   page: () => const LearnPage(),
    // ),
    // GetPage(
    //   name: AppRoutes.quiz,
    //   page: () => const QuizPage(),
    // ),
    GetPage(
      name: AppRoutes.profile,
      page: () => ProfilePage(),
    ),
  ];
}
