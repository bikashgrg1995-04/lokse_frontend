import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:lokse/core/constants/app_strings.dart';
import 'package:lokse/core/constants/logger.dart';
import 'package:lokse/core/network/api_endpoints.dart';
import 'package:lokse/core/network/getx_network_manager.dart';
import 'package:lokse/core/storage/secure_storage.dart';
import 'package:lokse/core/utils/dio_client.dart';
import 'package:lokse/core/utils/global_controller.dart';
import 'package:lokse/core/utils/status_message.dart';
import 'package:lokse/routes/app_routes.dart';

class LoginController extends GetxController {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  final isLoading = false.obs;
  final obscurePassword = true.obs;

  bool get _connected => GetXNetworkManager.instance.connectionType.value != 0;

  void togglePassword() => obscurePassword.toggle();

  Future<void> login() async {
    if (isLoading.value) return;

    final email = emailCtrl.text.trim();
    final password = passwordCtrl.text;

    if (email.isEmpty || password.isEmpty) {
      StatusMessage.error(AppStrings.errEmailRequired);
      return;
    }
    if (!_connected) {
      StatusMessage.error(AppStrings.errNoInternet);
      return;
    }

    try {
      isLoading.value = true;

      final res = await DioClient.client.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
        options: Options(extra: {'noAuth': true}),
      );

      await TokenStorage.saveTokens(
        accessToken: res.data['access'],
        refreshToken: res.data['refresh'],
      );

      GlobalController.instance.setLoggedIn(true);
      StatusMessage.success(AppStrings.loginSuccess);
      Get.offAllNamed(AppRoutes.navigation, arguments: 3);
    } on DioException catch (e) {
      final data = e.response?.data;
      String msg = AppStrings.errServerFailed;
      if (data is Map && data.isNotEmpty) {
        final v = data.values.first;
        msg = v is List ? v.first.toString() : v.toString();
      }
      StatusMessage.error(msg);
    } catch (e, s) {
      appLog.e('login error', error: e, stackTrace: s);
      StatusMessage.error(AppStrings.errSomethingWrong);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.onClose();
  }
}
