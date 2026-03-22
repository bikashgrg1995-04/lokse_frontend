import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:lokse/core/constants/app_constants.dart';
import 'package:lokse/core/network/getx_network_manager.dart';
import 'package:lokse/core/utils/dio_client.dart';
import 'package:lokse/core/utils/api_config.dart';
import 'package:lokse/core/utils/status_message.dart';
import 'package:lokse/routes/app_routes.dart';
import 'package:flutter/material.dart';

class RegisterController extends GetxController {
  // Form controllers
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // UI states
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final emailSent = false.obs;

  // Password visibility
  final obscurePassword = true.obs;
  final obscureConfirmPassword = true.obs;

  // Dev activation link
  final activationLink = ''.obs;

  final networkManager = GetXNetworkManager.instance;
  bool get isConnected => networkManager.connectionType.value != 0;

  void togglePassword() => obscurePassword.value = !obscurePassword.value;
  void toggleConfirmPassword() =>
      obscureConfirmPassword.value = !obscureConfirmPassword.value;

  // ================= REGISTER =================
  Future<void> register() async {
    if (isLoading.value) return;

    errorMessage.value = '';
    activationLink.value = '';

    if (fullNameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      StatusMessage.error("All fields are required");
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      StatusMessage.error("Passwords do not match");
      return;
    }

    if (!isConnected) {
      StatusMessage.error("No internet connection");
      return;
    }

    try {
      isLoading.value = true;

      final response = await DioClient.client.post(
        ApiConfig.register,
        data: {
          "full_name": fullNameController.text.trim(),
          "email": emailController.text.trim(),
          "password": passwordController.text,
        },
        options: Options(
          extra: {'noAuth': true}, // 🔴 IMPORTANT
        ),
      );

      logger.i("✅ Register success: ${response.data}");

      if (response.data?['activation_url'] != null) {
        activationLink.value = response.data['activation_url'];
      }

      StatusMessage.success(
        "Email sent! Check your inbox to verify your account.",
      );

      emailSent.value = true;
      clearForm();
    } on DioException catch (e) {
      if (e.response?.data is Map) {
        final data = e.response!.data as Map;
        final firstValue = data.values.first;

        final msg = firstValue is List
            ? firstValue.first.toString()
            : firstValue.toString();

        errorMessage.value = msg;
        StatusMessage.error(msg);
      } else {
        StatusMessage.error("Server failed");
      }

      logger.e("❌ Register failed", error: e.response?.data);
    } catch (e, s) {
      logger.wtf("🔥 Unexpected error", error: e, stackTrace: s);
      StatusMessage.error("Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }

  // ================= HELPERS =================
  void clearForm() {
    fullNameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    errorMessage.value = '';
    activationLink.value = '';
  }

  void goToLogin() {
    Get.offAllNamed(AppRoutes.navigation, arguments: 3);
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
