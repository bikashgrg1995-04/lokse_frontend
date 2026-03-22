import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lokse/core/utils/extensions.dart';
import 'splash_controller.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject controller
    Get.put(SplashController());

    return const Scaffold(
      body: _SplashAnimation(),
    );
  }
}

class _SplashAnimation extends StatefulWidget {
  const _SplashAnimation();

  @override
  State<_SplashAnimation> createState() => _SplashAnimationState();
}

class _SplashAnimationState extends State<_SplashAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _textOpacity;
  late final Animation<Offset> _textSlide;
  late final Animation<double> _taglineOpacity;
  late final Animation<Offset> _taglineSlide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // Logo pops in
    _logoScale = Tween<double>(begin: 0.7, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _logoOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.6)),
    );

    // App Name fades & slides
    _textOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.5, 1.0)),
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Tagline fades & slides
    _taglineOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.6, 1.0)),
    );
    _taglineSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFD0D3DC), // light grey
            Color(0xFF163EEF), // deep blue
          ],
        ),
      ),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // LOGO
              Opacity(
                opacity: _logoOpacity.value,
                child: Transform.scale(
                  scale: _logoScale.value,
                  child: Image.asset(
                    'assets/images/logo.png',
                    width:
                        0.9.sw(context), // reduced width for better mobile fit
                    height: 0.4.sh(context),
                  ),
                ),
              ),
              SizedBox(height: 0.04.sh(context)),

              // APP NAME
              FadeTransition(
                opacity: _textOpacity,
                child: SlideTransition(
                  position: _textSlide,
                  child: Text(
                    'Lokse',
                    style: TextStyle(
                      fontSize: 0.02.toRes(context),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.05.sw(context),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 0.01.sh(context)),

              // TAGLINE
              FadeTransition(
                opacity: _taglineOpacity,
                child: SlideTransition(
                  position: _taglineSlide,
                  child: Text(
                    'Learn • Practice • Crack',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 0.014.toRes(context),
                      color: Colors.white.withOpacity(0.7),
                      letterSpacing: 0.01.sw(context),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
