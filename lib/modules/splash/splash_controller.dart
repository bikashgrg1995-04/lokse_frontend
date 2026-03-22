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
    } else {
      Get.offAllNamed(AppRoutes.navigation);
    }
  }
}
