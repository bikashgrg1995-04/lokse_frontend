import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lokse/modules/auth/login/login_page.dart';
import 'package:lokse/modules/auth/profile/profile_page.dart';
import 'package:lokse/modules/home/home_page.dart';
import 'package:lokse/modules/learn/learn_page.dart';
import 'package:lokse/modules/quiz/quiz_page.dart';
import 'navigation_controller.dart';
import 'package:lokse/core/utils/global_controller.dart';

class NavigationPage extends StatelessWidget {
  const NavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final navController = Get.put(NavigationController());
    final authController = Get.find<GlobalController>();

    // Initial tab index
    final argIndex = Get.arguments;
    if (argIndex != null && argIndex is int) navController.setIndex(argIndex);

    // Pages
    final pages = [
      const HomePage(),
      const LearnPage(),
      const QuizPage(),
      Obx(() =>
          authController.isLoggedIn.value ? ProfilePage() : const LoginPage()),
    ];

    return Scaffold(
      body: Obx(() => IndexedStack(
            index: navController.currentIndex.value,
            children: pages,
          )),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            currentIndex: navController.currentIndex.value,
            onTap: navController.changePage,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white54,
            backgroundColor: const Color.fromARGB(255, 38, 67, 197),
            showUnselectedLabels: true,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.menu_book_rounded),
                label: 'Learn',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.quiz_rounded),
                label: 'Quiz',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded),
                label: 'Profile',
              ),
            ],
          )),
    );
  }
}
