import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lokse/core/constants/app_colors.dart';
import 'package:lokse/core/constants/app_assets.dart';
import 'package:lokse/modules/auth/register/register_controller.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final controller = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          // Top decoration (shorter than login)
          const _TopDecoration(),

          SafeArea(
            child: Column(
              children: [
                // Back button
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.2), width: 1),
                        ),
                        child: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: Colors.white, size: 16),
                      ),
                    ),
                  ),
                ),

                // Header
                const _RegisterHeader(),

                // Scrollable form
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                    child: Obx(() => controller.emailSent.value
                        ? const _EmailSentView()
                        : _RegisterForm(controller: controller)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopDecoration extends StatelessWidget {
  const _TopDecoration();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.28,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0A1628), Color(0xFF0F2354), Color(0xFF1E3EBF)],
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(36),
            bottomRight: Radius.circular(36),
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -30,
              right: -20,
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
            Positioned(
              bottom: -10,
              left: -20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.04),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RegisterHeader extends StatelessWidget {
  const _RegisterHeader();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Image.asset(
                    AppAssets.logo,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                        Icons.school_rounded,
                        color: Colors.white,
                        size: 18),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Lokse',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'Create your account',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Join 10,000+ Loksewa aspirants',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _RegisterForm extends StatelessWidget {
  final RegisterController controller;
  const _RegisterForm({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress steps
          const _StepIndicator(currentStep: 1, totalSteps: 2),
          const SizedBox(height: 24),

          _LabeledField(
            label: 'Full Name',
            child: _StyledTextField(
              controller: controller.fullNameController,
              hint: 'Ram Bahadur Thapa',
              icon: Icons.person_outline_rounded,
            ),
          ),
          const SizedBox(height: 16),

          _LabeledField(
            label: 'Email Address',
            child: _StyledTextField(
              controller: controller.emailController,
              hint: 'your@email.com',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          const SizedBox(height: 16),

          _LabeledField(
            label: 'Password',
            child: Obx(() => _StyledTextField(
                  controller: controller.passwordController,
                  hint: 'Min. 8 characters',
                  icon: Icons.lock_outline_rounded,
                  obscureText: controller.obscurePassword.value,
                  suffixIcon: GestureDetector(
                    onTap: controller.togglePassword,
                    child: Icon(
                      controller.obscurePassword.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 18,
                      color: AppColors.grey400,
                    ),
                  ),
                )),
          ),
          const SizedBox(height: 16),

          _LabeledField(
            label: 'Confirm Password',
            child: Obx(() => _StyledTextField(
                  controller: controller.confirmPasswordController,
                  hint: 'Re-enter password',
                  icon: Icons.lock_outline_rounded,
                  obscureText: controller.obscureConfirmPassword.value,
                  suffixIcon: GestureDetector(
                    onTap: controller.toggleConfirmPassword,
                    child: Icon(
                      controller.obscureConfirmPassword.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 18,
                      color: AppColors.grey400,
                    ),
                  ),
                )),
          ),

          // Error message
          Obx(() => controller.errorMessage.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.hardSurface,
                      borderRadius: BorderRadius.circular(10),
                      border:
                          Border.all(color: AppColors.hard.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline,
                            color: AppColors.hard, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            controller.errorMessage.value,
                            style: const TextStyle(
                                color: AppColors.hardDark, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox.shrink()),

          const SizedBox(height: 24),

          // Register button
          Obx(() => _PrimaryButton(
                label: 'Create Account',
                isLoading: controller.isLoading.value,
                onTap: controller.register,
              )),

          const SizedBox(height: 20),

          // Login link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Already have an account? ',
                  style: TextStyle(color: AppColors.grey500, fontSize: 13)),
              GestureDetector(
                onTap: controller.goToLogin,
                child: const Text(
                  'Login',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  const _StepIndicator({required this.currentStep, required this.totalSteps});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Step $currentStep of $totalSteps',
              style: TextStyle(color: AppColors.grey400, fontSize: 12),
            ),
            const Spacer(),
            Text(
              'Fill in your details',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(totalSteps, (i) {
            final active = i < currentStep;
            return Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsets.only(right: i < totalSteps - 1 ? 6 : 0),
                decoration: BoxDecoration(
                  color: active ? AppColors.primary : AppColors.grey200,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

// ── EMAIL SENT ─────────────────────────────────────────────────
class _EmailSentView extends StatelessWidget {
  const _EmailSentView();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Success animation circle
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.easySurface,
              shape: BoxShape.circle,
              border:
                  Border.all(color: AppColors.easy.withOpacity(0.3), width: 3),
            ),
            child: const Icon(Icons.mark_email_read_rounded,
                color: AppColors.success, size: 48),
          ),
          const SizedBox(height: 24),
          const Text(
            'Check your inbox!',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F2354),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'We\'ve sent a verification link to your email. Click it to activate your account.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.grey500,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 32),
          _PrimaryButton(
            label: 'Go to Login',
            isLoading: false,
            onTap: Get.find<RegisterController>().goToLogin,
          ),
          const SizedBox(height: 16),
          Text(
            'Didn\'t receive it? Check spam folder.',
            style: TextStyle(color: AppColors.grey400, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// ── SHARED COMPONENTS ─────────────────────────────────────────

class _LabeledField extends StatelessWidget {
  final String label;
  final Widget child;
  const _LabeledField({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF374151),
              letterSpacing: 0.3,
            )),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _StyledTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType keyboardType;

  const _StyledTextField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.grey200, width: 1),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF1F2937),
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: AppColors.grey400, fontSize: 14),
          prefixIcon: Icon(icon, color: AppColors.grey400, size: 18),
          suffixIcon: suffixIcon != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: suffixIcon,
                )
              : null,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback? onTap;

  const _PrimaryButton(
      {required this.label, required this.isLoading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isLoading
                ? [AppColors.grey300, AppColors.grey300]
                : [const Color(0xFF1E3EBF), const Color(0xFF4F6EF7)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: isLoading
              ? []
              : [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
              : Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
        ),
      ),
    );
  }
}
