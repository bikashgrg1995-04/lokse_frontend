import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:lokse/core/constants/app_constants.dart';
import 'package:lokse/core/utils/api_config.dart';
import 'package:lokse/core/utils/dio_client.dart';
import 'package:lokse/core/utils/status_message.dart';
import 'package:lokse/core/storage/secure_storage.dart';
import 'package:lokse/routes/app_routes.dart';
import 'package:lokse/core/utils/global_controller.dart';
import 'package:lokse/core/network/getx_network_manager.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final obscurePassword = true.obs;

  final networkManager = GetXNetworkManager.instance;
  bool get isConnected => networkManager.connectionType.value != 0;

  // Reference to GlobalController
  final globalController = Get.find<GlobalController>();

  void togglePassword() => obscurePassword.value = !obscurePassword.value;

  /// ================= LOGIN =================
  Future<void> login() async {
    if (isLoading.value) return;

    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      StatusMessage.error("Email and password are required");
      return;
    }

    if (!isConnected) {
      StatusMessage.error("No internet connection");
      return;
    }

    try {
      isLoading.value = true;

      final response = await DioClient.client.post(
        ApiConfig.login,
        data: {"email": email, "password": password},
        options: Options(extra: {'noAuth': true}),
      );

      final access = response.data['access'];
      final refresh = response.data['refresh'];

      await TokenStorage.saveTokens(
        accessToken: access,
        refreshToken: refresh,
      );

      // Update global login state
      globalController.setLoggedIn(true);

      StatusMessage.success("Login successful");

      // Navigate to NavigationPage with Profile tab
      Get.offAllNamed(AppRoutes.navigation, arguments: 3);
    } on DioException catch (e) {
      String msg = "Server failed";
      if (e.response?.data is Map) {
        final data = e.response!.data as Map;
        final firstValue = data.values.first;
        msg = firstValue is List
            ? firstValue.first.toString()
            : firstValue.toString();
      }
      StatusMessage.error(msg);
    } catch (e, s) {
      logger.wtf("Unexpected error", error: e, stackTrace: s);
      StatusMessage.error("Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
