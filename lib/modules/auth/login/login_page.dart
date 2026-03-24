import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lokse/core/constants/app_colors.dart';
import 'package:lokse/core/constants/app_sizes.dart';
import 'package:lokse/core/constants/app_strings.dart';
import 'package:lokse/core/constants/app_assets.dart';
import 'package:lokse/routes/app_routes.dart';
import 'package:lokse/widgets/common_widgets.dart';
import 'login_controller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(LoginController());

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.xxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSizes.xxxl),

              // Logo + title
              Center(
                child: Column(
                  children: [
                    Image.asset(AppAssets.logo,
                        height: 72,
                        errorBuilder: (_, __, ___) => const Icon(Icons.school,
                            size: 60, color: AppColors.primary)),
                    const SizedBox(height: AppSizes.sm),
                    const Text(AppStrings.appName,
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1)),
                    const SizedBox(height: AppSizes.xs),
                    const Text('Prepare smart for Loksewa',
                        style: TextStyle(color: AppColors.grey400)),
                  ],
                ),
              ),

              const SizedBox(height: AppSizes.xxxl),

              // Email
              AppTextField(
                controller: c.emailCtrl,
                label: AppStrings.email,
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: AppSizes.lg),

              // Password
              Obx(() => AppTextField(
                    controller: c.passwordCtrl,
                    label: AppStrings.password,
                    prefixIcon: Icons.lock_outline,
                    obscureText: c.obscurePassword.value,
                    suffixIcon: IconButton(
                      icon: Icon(c.obscurePassword.value
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: c.togglePassword,
                    ),
                  )),

              // Forgot password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {}, // TODO
                  child: const Text(AppStrings.forgotPassword,
                      style: TextStyle(color: AppColors.primary)),
                ),
              ),

              const SizedBox(height: AppSizes.sm),

              // Login button
              Obx(() => AppButton(
                    label: AppStrings.login,
                    onTap: c.login,
                    isLoading: c.isLoading.value,
                  )),

              const SizedBox(height: AppSizes.xl),

              // Divider
              Row(children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm),
                  child: Text('OR', style: TextStyle(color: AppColors.grey400)),
                ),
                const Expanded(child: Divider()),
              ]),

              const SizedBox(height: AppSizes.xl),

              // Google
              SizedBox(
                width: double.infinity,
                height: AppSizes.buttonMd,
                child: OutlinedButton.icon(
                  icon: Image.network(
                      'https://developers.google.com/identity/images/g-logo.png',
                      height: 20,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.g_mobiledata)),
                  label: const Text(AppStrings.continueGoogle),
                  onPressed: () {}, // TODO
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.grey200),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
                  ),
                ),
              ),

              const SizedBox(height: AppSizes.xxxl),

              // Register link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(AppStrings.noAccount),
                  GestureDetector(
                    onTap: () => Get.offAndToNamed(AppRoutes.register),
                    child: const Text(AppStrings.register,
                        style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
