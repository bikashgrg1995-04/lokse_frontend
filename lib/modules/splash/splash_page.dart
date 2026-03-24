import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'splash_controller.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
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
    with TickerProviderStateMixin {
  // ── Controllers ───────────────────────────────────────────
  late final AnimationController _bgController;
  late final AnimationController _logoController;
  late final AnimationController _textController;
  late final AnimationController _dotsController;
  late final AnimationController _shimmerController;

  // ── Background ────────────────────────────────────────────
  late final Animation<double> _bgScale;

  // ── Logo ──────────────────────────────────────────────────
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _logoY;

  // ── Ring pulse around logo ────────────────────────────────
  late final Animation<double> _ring1Scale;
  late final Animation<double> _ring1Opacity;
  late final Animation<double> _ring2Scale;
  late final Animation<double> _ring2Opacity;

  // ── Text ──────────────────────────────────────────────────
  late final Animation<double> _titleOpacity;
  late final Animation<double> _titleY;
  late final Animation<double> _subtitleOpacity;
  late final Animation<double> _badgeOpacity;
  late final Animation<double> _badgeScale;

  // ── Loading dots ──────────────────────────────────────────
  late final Animation<double> _dotsOpacity;

  // ── Shimmer on logo ───────────────────────────────────────
  late final Animation<double> _shimmer;

  @override
  void initState() {
    super.initState();

    // Background subtle zoom
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    )..forward();

    _bgScale = Tween<double>(begin: 1.08, end: 1.0).animate(
      CurvedAnimation(parent: _bgController, curve: Curves.easeOut),
    );

    // Logo entrance
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..forward();

    _logoScale = TweenSequence<double>([
      TweenSequenceItem(
          tween: Tween(begin: 0.0, end: 1.12)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 60),
      TweenSequenceItem(
          tween: Tween(begin: 1.12, end: 0.95)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 20),
      TweenSequenceItem(
          tween: Tween(begin: 0.95, end: 1.0)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 20),
    ]).animate(_logoController);

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: const Interval(0.0, 0.4)),
    );

    _logoY = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
          parent: _logoController,
          curve: const Interval(0.0, 0.7, curve: Curves.easeOut)),
    );

    // Ring pulse
    _ring1Scale = Tween<double>(begin: 0.6, end: 1.4).animate(
      CurvedAnimation(
          parent: _logoController,
          curve: const Interval(0.3, 1.0, curve: Curves.easeOut)),
    );
    _ring1Opacity = Tween<double>(begin: 0.5, end: 0.0).animate(
      CurvedAnimation(parent: _logoController, curve: const Interval(0.3, 1.0)),
    );
    _ring2Scale = Tween<double>(begin: 0.6, end: 1.7).animate(
      CurvedAnimation(
          parent: _logoController,
          curve: const Interval(0.4, 1.0, curve: Curves.easeOut)),
    );
    _ring2Opacity = Tween<double>(begin: 0.3, end: 0.0).animate(
      CurvedAnimation(parent: _logoController, curve: const Interval(0.4, 1.0)),
    );

    // Text entrance — starts after logo settles
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    Future.delayed(
        const Duration(milliseconds: 900), () => _textController.forward());

    _titleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: const Interval(0.0, 0.6)),
    );
    _titleY = Tween<double>(begin: 18.0, end: 0.0).animate(
      CurvedAnimation(
          parent: _textController,
          curve: const Interval(0.0, 0.7, curve: Curves.easeOut)),
    );
    _subtitleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: const Interval(0.3, 0.9)),
    );
    _badgeOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: const Interval(0.5, 1.0)),
    );
    _badgeScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
          parent: _textController,
          curve: const Interval(0.5, 1.0, curve: Curves.easeOutBack)),
    );

    // Loading dots — starts near end
    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _dotsOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: const Interval(0.8, 1.0)),
    );

    // Shimmer sweep
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    Future.delayed(
        const Duration(milliseconds: 1200), () => _shimmerController.forward());
    _shimmer = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _bgController.dispose();
    _logoController.dispose();
    _textController.dispose();
    _dotsController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: Listenable.merge([
        _bgController,
        _logoController,
        _textController,
        _dotsController,
        _shimmerController,
      ]),
      builder: (context, _) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          // Rich deep navy-to-royal-blue gradient
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0A1628), // near black navy
                Color(0xFF0F2354), // deep navy
                Color(0xFF1A3A8A), // rich blue
                Color(0xFF1E3EBF), // brand blue
              ],
              stops: [0.0, 0.3, 0.7, 1.0],
            ),
          ),
          child: Stack(
            children: [
              // ── Decorative background circles ──────────────
              ..._buildBgCircles(size),

              // ── Main content ───────────────────────────────
              Column(
                children: [
                  const Spacer(flex: 2),

                  // ── Logo area ──────────────────────────────
                  SizedBox(
                    height: size.height * 0.28,
                    child: Center(
                      child: Transform.translate(
                        offset: Offset(0, _logoY.value),
                        child: Opacity(
                          opacity: _logoOpacity.value.clamp(0.0, 1.0),
                          child: Transform.scale(
                            scale: _logoScale.value,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Ring 2 (outer)
                                Transform.scale(
                                  scale: _ring2Scale.value,
                                  child: Opacity(
                                    opacity:
                                        _ring2Opacity.value.clamp(0.0, 1.0),
                                    child: Container(
                                      width: 160,
                                      height: 160,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.15),
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // Ring 1 (inner)
                                Transform.scale(
                                  scale: _ring1Scale.value,
                                  child: Opacity(
                                    opacity:
                                        _ring1Opacity.value.clamp(0.0, 1.0),
                                    child: Container(
                                      width: 140,
                                      height: 140,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.25),
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // Logo container with shimmer
                                Container(
                                  width: 110,
                                  height: 110,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(0.08),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.18),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: ClipOval(
                                    child: Stack(
                                      children: [
                                        // Logo
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(18),
                                            child: Image.asset(
                                              'assets/images/logo.png',
                                              fit: BoxFit.contain,
                                              errorBuilder: (_, __, ___) =>
                                                  const Icon(
                                                Icons.school_rounded,
                                                color: Colors.white,
                                                size: 52,
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Shimmer sweep
                                        Positioned.fill(
                                          child: Transform.translate(
                                            offset:
                                                Offset(_shimmer.value * 200, 0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Colors.white
                                                        .withOpacity(0.0),
                                                    Colors.white
                                                        .withOpacity(0.15),
                                                    Colors.white
                                                        .withOpacity(0.0),
                                                  ],
                                                  stops: const [0.0, 0.5, 1.0],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ── App name ────────────────────────────────
                  Transform.translate(
                    offset: Offset(0, _titleY.value),
                    child: Opacity(
                      opacity: _titleOpacity.value.clamp(0.0, 1.0),
                      child: const Text(
                        'Lokse',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 42,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 3,
                          height: 1,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ── Nepali tagline ──────────────────────────
                  Opacity(
                    opacity: _subtitleOpacity.value.clamp(0.0, 1.0),
                    child: Text(
                      'लोकसेवाको तयारी, अब सजिलो',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.65),
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),

                  const SizedBox(height: 6),

                  // ── English tagline ─────────────────────────
                  Opacity(
                    opacity: _subtitleOpacity.value.clamp(0.0, 1.0),
                    child: Text(
                      'Learn · Practice · Crack',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.4),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 2.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── PSC badge ────────────────────────────────
                  Transform.scale(
                    scale: _badgeScale.value,
                    child: Opacity(
                      opacity: _badgeOpacity.value.clamp(0.0, 1.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                          color: Colors.white.withOpacity(0.07),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Color(0xFF4ADE80),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Nepal PSC Preparation Platform',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const Spacer(flex: 3),

                  // ── Loading dots ─────────────────────────────
                  Opacity(
                    opacity: _dotsOpacity.value.clamp(0.0, 1.0),
                    child: _LoadingDots(controller: _dotsController),
                  ),

                  const SizedBox(height: 48),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildBgCircles(Size size) {
    return [
      // Top-right large circle
      Positioned(
        top: -size.height * 0.12,
        right: -size.width * 0.2,
        child: Transform.scale(
          scale: _bgScale.value,
          child: Container(
            width: size.width * 0.7,
            height: size.width * 0.7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.03),
            ),
          ),
        ),
      ),
      // Bottom-left medium circle
      Positioned(
        bottom: -size.height * 0.08,
        left: -size.width * 0.15,
        child: Transform.scale(
          scale: _bgScale.value,
          child: Container(
            width: size.width * 0.55,
            height: size.width * 0.55,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.04),
            ),
          ),
        ),
      ),
      // Center subtle glow
      Positioned(
        top: size.height * 0.22,
        left: size.width * 0.1,
        right: size.width * 0.1,
        child: Opacity(
          opacity: _logoOpacity.value.clamp(0.0, 0.6),
          child: Container(
            height: size.height * 0.25,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(200),
              color: const Color(0xFF3B6FE8).withOpacity(0.15),
            ),
          ),
        ),
      ),
      // Small accent dots — static opacity, no dynamic math
      Positioned(
        top: size.height * 0.12,
        left: size.width * 0.08,
        child: _AccentDot(size: 6, color: Colors.white.withOpacity(0.25)),
      ),
      Positioned(
        top: size.height * 0.16,
        left: size.width * 0.18,
        child: _AccentDot(size: 4, color: Colors.white.withOpacity(0.15)),
      ),
      Positioned(
        top: size.height * 0.08,
        right: size.width * 0.12,
        child: _AccentDot(size: 5, color: Colors.white.withOpacity(0.2)),
      ),
    ];
  }
}

// ── LOADING DOTS ──────────────────────────────────────────────
class _LoadingDots extends StatelessWidget {
  final AnimationController controller;
  const _LoadingDots({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            // staggered bounce: each dot offset by 0.25
            final offset = i * 0.25;
            final t = ((controller.value + offset) % 1.0);
            // sine wave for smooth bob
            final scale = 0.6 + 0.4 * math.sin(t * math.pi);
            // sin(t*pi) for t in [0,1] gives 0→1→0, always non-negative
            // Using abs() to ensure we never get negative opacity
            final opacity = (0.3 + 0.7 * math.sin(t * math.pi)).clamp(0.0, 1.0);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Transform.scale(
                scale: scale,
                child: Opacity(
                  opacity: opacity.clamp(0.0, 1.0),
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

// ── ACCENT DOT ────────────────────────────────────────────────
class _AccentDot extends StatelessWidget {
  final double size;
  final Color color;
  const _AccentDot({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
