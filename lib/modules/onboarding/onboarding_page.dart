import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lokse/core/utils/extensions.dart';
import 'onboarding_controller.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 70, 95, 206),
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: controller.skip,
                child: Text(
                  'Skip',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 0.014.toRes(context),
                  ),
                ),
              ),
            ),

            // PageView
            Expanded(
              child: PageView(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                children: const [
                  _OnboardingItem(
                    icon: Icons.menu_book_rounded,
                    title: 'Learn Smartly',
                    subtitle:
                        'Structured syllabus and clear concepts designed for Loksewa.',
                  ),
                  _OnboardingItem(
                    icon: Icons.quiz_rounded,
                    title: 'Practice Confidently',
                    subtitle:
                        'Daily quizzes, mock tests and performance tracking.',
                  ),
                  _OnboardingItem(
                    icon: Icons.emoji_events_rounded,
                    title: 'Crack Loksewa',
                    subtitle:
                        'Move closer to your government job goal with confidence.',
                    isLast: true,
                  ),
                ],
              ),
            ),

            // Bottom Controls
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 0.07.sw(context),
                vertical: 0.01.sh(context),
              ),
              child: Obx(() {
                final isLast = controller.currentIndex.value == 2;

                return Column(
                  children: [
                    // Indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        3,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: EdgeInsets.symmetric(
                              horizontal: 0.02.sw(context)),
                          height: 0.008.sh(context),
                          width: controller.currentIndex.value == index
                              ? 0.06.sw(context)
                              : 0.02.sw(context),
                          decoration: BoxDecoration(
                            color: controller.currentIndex.value == index
                                ? Colors.white
                                : Colors.white24,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 0.03.sh(context)),

                    // Buttons
                    if (!isLast)
                      SizedBox(
                        width: double.infinity,
                        height: 0.06.sh(context),
                        child: ElevatedButton(
                          onPressed: controller.nextPage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(0.035.sw(context)),
                            ),
                          ),
                          child: Text(
                            'Next',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 0.014.toRes(context),
                            ),
                          ),
                        ),
                      )
                    else
                      Column(
                        children: [
                          // Login Button
                          SizedBox(
                            width: double.infinity,
                            height: 0.06.sh(context),
                            child: ElevatedButton(
                              onPressed: controller.goToLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(0.035.sw(context)),
                                ),
                              ),
                              child: Text(
                                'Login / Sign in',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 0.014.toRes(context),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 0.015.sh(context)),

                          // Guest Button
                          SizedBox(
                            width: double.infinity,
                            height: 0.065.sh(context),
                            child: OutlinedButton(
                              onPressed: controller.continueAsGuest,
                              style: OutlinedButton.styleFrom(
                                side:
                                    BorderSide(color: Colors.white38, width: 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(0.035.sw(context)),
                                ),
                              ),
                              child: Text(
                                'Continue as Guest',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 0.014.toRes(context),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isLast;

  const _OnboardingItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.07.sw(context)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon Box
          Container(
            height: 0.15.sh(context),
            width: 0.15.sh(context),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(0.04.sh(context)),
            ),
            child: Icon(icon, size: 0.1.sh(context), color: Colors.white),
          ),
          SizedBox(height: 0.05.sh(context)),

          // Title
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 0.06.sw(context),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 0.02.sh(context)),

          // Subtitle
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 0.038.sw(context),
              height: 1.6,
              color: Colors.white.withOpacity(0.65),
            ),
          ),
        ],
      ),
    );
  }
}
