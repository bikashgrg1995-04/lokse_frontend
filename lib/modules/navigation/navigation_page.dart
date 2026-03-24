import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lokse/core/constants/app_colors.dart';
import 'package:lokse/core/constants/app_strings.dart';
import 'package:lokse/core/utils/global_controller.dart';
import 'package:lokse/modules/auth/login/login_page.dart';
import 'package:lokse/modules/auth/profile/profile_page.dart';
import 'package:lokse/modules/home/home_page.dart';
import 'package:lokse/modules/learn/learn_page.dart';
import 'package:lokse/modules/quiz/quiz_page.dart';
import 'navigation_controller.dart';

class NavigationPage extends StatelessWidget {
  const NavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final nav = Get.put(NavigationController());
    final auth = GlobalController.instance;

    final argIndex = Get.arguments;
    if (argIndex is int) nav.setIndex(argIndex);

    final pages = [
      const HomePage(),
      const LearnPage(),
      const QuizPage(),
      Obx(() =>
          auth.isLoggedIn.value ? const ProfilePage() : const LoginPage()),
    ];

    return Scaffold(
      body: Obx(() => IndexedStack(
            index: nav.currentIndex.value,
            children: pages,
          )),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            currentIndex: nav.currentIndex.value,
            onTap: nav.changePage,
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColors.primary,
            selectedItemColor: AppColors.white,
            unselectedItemColor: AppColors.white.withOpacity(0.5),
            showUnselectedLabels: true,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded), label: AppStrings.navHome),
              BottomNavigationBarItem(
                  icon: Icon(Icons.menu_book_rounded),
                  label: AppStrings.navLearn),
              BottomNavigationBarItem(
                  icon: Icon(Icons.quiz_rounded), label: AppStrings.navQuiz),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person_rounded),
                  label: AppStrings.navProfile),
            ],
          )),
    );
  }
}
