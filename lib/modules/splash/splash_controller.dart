import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../routes/app_routes.dart';

class SplashController extends GetxController {
  final GetStorage _box = GetStorage();

  @override
  void onReady() {
    super.onReady();
    _handleNavigation();
  }

  Future<void> _handleNavigation() async {
    // Match animation duration
    await Future.delayed(const Duration(seconds: 3));

    final bool isFirstTime = _box.read('isFirstTime') ?? true;

    if (isFirstTime) {
      Get.offAllNamed(AppRoutes.onboarding);
      return;
    }

    // ── Wait for auth check to complete before navigating ──
    // GlobalController.checkLogin() is async — we must await it
    // so isLoggedIn is correct before NavigationPage renders.

    // final gc = GlobalController.instance;
    //await gc.checkLogin();

    // Always go to NavigationPage — it handles auth state internally.
    // If logged in  → ProfilePage shown on tab 3
    // If not logged → LoginPage shown on tab 3
    Get.offAllNamed(AppRoutes.navigation);
  }
}
