import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lokse/modules/auth/register/register_controller.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final controller = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  Center(
                    child: Column(
                      children: const [
                        Icon(Icons.school, size: 56, color: Colors.indigo),
                        SizedBox(height: 10),
                        Text(
                          'Create Account',
                          style: TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Start your Loksewa preparation',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // --- SHOW FORM ONLY IF EMAIL NOT SENT ---
                  if (!controller.emailSent.value) ...[
                    // FULL NAME
                    TextField(
                      controller: controller.fullNameController,
                      decoration:
                          _inputDecoration('Full Name', Icons.person_outline),
                    ),
                    const SizedBox(height: 16),

                    // EMAIL
                    TextField(
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration:
                          _inputDecoration('Email', Icons.email_outlined),
                    ),
                    const SizedBox(height: 16),

                    // PASSWORD
                    Obx(() => TextField(
                          controller: controller.passwordController,
                          obscureText: controller.obscurePassword.value,
                          decoration: _inputDecoration(
                            'Password',
                            Icons.lock_outline,
                            suffix: IconButton(
                              icon: Icon(controller.obscurePassword.value
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: controller.togglePassword,
                            ),
                          ),
                        )),
                    const SizedBox(height: 16),

                    // CONFIRM PASSWORD
                    Obx(() => TextField(
                          controller: controller.confirmPasswordController,
                          obscureText: controller.obscureConfirmPassword.value,
                          decoration: _inputDecoration(
                            'Confirm Password',
                            Icons.lock_outline,
                            suffix: IconButton(
                              icon: Icon(controller.obscureConfirmPassword.value
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: controller.toggleConfirmPassword,
                            ),
                          ),
                        )),
                    const SizedBox(height: 12),

                    // ERROR MESSAGE
                    if (controller.errorMessage.isNotEmpty)
                      Text(
                        controller.errorMessage.value,
                        style: const TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    const SizedBox(height: 24),

                    // REGISTER BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: controller.isLoading.value
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Register',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // --- SHOW EMAIL SENT MESSAGE ---
                  if (controller.emailSent.value) ...[
                    Center(
                        child: const Icon(Icons.email,
                            size: 80, color: Colors.green)),
                    const SizedBox(height: 16),
                    const Text(
                      'Email sent!',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Check your inbox to verify your account.',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: controller.goToLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Go to Login',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // LOGIN LINK (always shown)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account? '),
                      GestureDetector(
                        onTap: controller.goToLogin,
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.indigo,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon,
      {Widget? suffix}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      suffixIcon: suffix,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
