import 'package:get/get.dart';
import 'package:lokse/core/utils/global_controller.dart';
import 'package:lokse/core/network/getx_network_manager.dart';
import 'package:lokse/modules/auth/login/login_controller.dart';
import 'package:lokse/modules/auth/register/register_controller.dart';
import 'package:lokse/modules/learn/learn_controller.dart';
import 'package:lokse/modules/quiz/quiz_controller.dart';

class GlobalBindings extends Bindings {
  @override
  void dependencies() {
    // Permanent — alive for entire app session
    Get.put<GlobalController>(GlobalController(), permanent: true);
    Get.put<GetXNetworkManager>(GetXNetworkManager(), permanent: true);

    // Lazy — created on first access
    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<RegisterController>(() => RegisterController());
    Get.lazyPut<LearnController>(() => LearnController());
    Get.lazyPut<QuizController>(() => QuizController());

    // ProfileController is NOT here — NavigationPage handles it
  }
}
