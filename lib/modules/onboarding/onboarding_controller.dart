import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../routes/app_routes.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  final currentIndex = 0.obs;
  final GetStorage _box = GetStorage();

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  void nextPage() {
    if (currentIndex.value < 2) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void continueAsGuest() {
    _box.write('isFirstTime', false);
    Get.offAllNamed(AppRoutes.navigation);
  }

  void goToLogin() {
    _box.write('isFirstTime', false);
    //set to login
    Get.offAllNamed(AppRoutes.navigation, arguments: 3);
  }

  void skip() => continueAsGuest();

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
