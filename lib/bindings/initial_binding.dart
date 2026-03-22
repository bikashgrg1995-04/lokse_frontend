import 'package:get/get.dart';
import 'package:lokse/core/utils/global_controller.dart';
import 'package:lokse/modules/auth/login/login_controller.dart';
import 'package:lokse/modules/auth/register/register_controller.dart';
import 'package:lokse/modules/auth/profile/profile_controller.dart';
import 'package:lokse/modules/learn/learn_controller.dart';
import 'package:lokse/modules/quiz/quiz_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Global app state (login status, etc.)
    Get.put(GlobalController(), permanent: true);

    // Auth/Login controller (form + API)
    Get.lazyPut(() => RegisterController());
    Get.lazyPut(() => LoginController());

    Get.lazyPut(() => LearnController());
    Get.lazyPut(() => QuizController());

    // Profile controller (fetch/update user profile)
    Get.lazyPut(() => ProfileController());
  }
}
