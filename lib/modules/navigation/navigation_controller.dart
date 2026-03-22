import 'package:get/get.dart';

class NavigationController extends GetxController {
  final currentIndex = 0.obs;

  void changePage(int index) {
    currentIndex.value = index;
  }

  /// 👇 external navigation (Register → Login jasto case)
  void setIndex(int index) {
    currentIndex.value = index;
  }
}
