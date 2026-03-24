import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lokse/core/constants/app_colors.dart';
import 'package:lokse/core/constants/app_sizes.dart';
import 'package:lokse/core/constants/app_strings.dart';
import 'package:lokse/modules/quiz/quiz_model.dart';
import 'package:lokse/widgets/common_widgets.dart';
import 'quiz_controller.dart';

class QuizPage extends StatelessWidget {
  const QuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(QuizController());
    return Obx(() {
      if (c.showResult.value && c.quizResult.value != null) {
        return _ResultScreen(c: c);
      }
      if (c.isQuizActive.value) return _QuizScreen(c: c);
      return _MapScreen(c: c);
    });
  }
}

// ═══════════════════════════════════════════════════════════════
// MAP SCREEN
// ═══════════════════════════════════════════════════════════════
class _MapScreen extends StatelessWidget {
  final QuizController c;
  const _MapScreen({required this.c});

  bool _isLeft(int i) {
    if (c.levels[i].isBoss) return false;
    int nb = 0;
    for (int j = 0; j < i; j++) {
      if (!c.levels[j].isBoss) nb++;
    }
    return nb.isEven;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mapBg,
      body: SafeArea(
        child: Column(
          children: [
            // Header with live XP badge
            Container(
              padding:
                  const EdgeInsets.fromLTRB(AppSizes.xl, 14, AppSizes.xl, 14),
              color: AppColors.primary,
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppStrings.quizPath,
                            style: TextStyle(
                                color: AppColors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.w700)),
                        SizedBox(height: 2),
                        Text(AppStrings.quizSubtitle,
                            style: TextStyle(
                                color: AppColors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ),
                  const CoinBadge(dark: true),
                ],
              ),
            ),

            Expanded(
              child: Obx(() => ListView.builder(
                    padding: const EdgeInsets.fromLTRB(0, 12, 0, 32),
                    itemCount: c.levels.length,
                    itemBuilder: (_, i) => _LevelNode(
                      level: c.levels[i],
                      isLeft: _isLeft(i),
                      onTap: () => c.startLevel(c.levels[i]),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

// ── LEVEL NODE ────────────────────────────────────────────────
class _LevelNode extends StatelessWidget {
  final QuizLevel level;
  final bool isLeft;
  final VoidCallback onTap;
  const _LevelNode(
      {required this.level, required this.isLeft, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (level.isBoss) return _BossNode(level: level, onTap: onTap);

    final diff = level.difficulty;
    final isCompleted = level.status == LevelStatus.completed;
    final isCurrent = level.status == LevelStatus.current;
    final isLocked = level.status == LevelStatus.locked;

    final nodeColor = isLocked ? const Color(0xFF2D3E8A) : diff.color;
    final borderColor = isLocked ? const Color(0xFF3D4E9A) : diff.darkColor;
    final shadowColor = isLocked ? Colors.transparent : diff.darkColor;

    return Column(
      children: [
        Container(
          width: 3,
          height: 16,
          color: AppColors.white.withOpacity(0.12),
          margin:
              EdgeInsets.only(left: isLeft ? 72 : 0, right: isLeft ? 0 : 72),
        ),
        Padding(
          padding:
              EdgeInsets.only(left: isLeft ? 48 : 0, right: isLeft ? 0 : 48),
          child: Row(
            mainAxisAlignment:
                isLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (!isLeft) ...[
                if (isCompleted) StarRow(stars: level.stars),
                const SizedBox(width: 10),
              ],
              GestureDetector(
                onTap: onTap,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: isCurrent ? AppSizes.nodeCurrent : AppSizes.nodeNormal,
                  height:
                      isCurrent ? AppSizes.nodeCurrent : AppSizes.nodeNormal,
                  decoration: BoxDecoration(
                    color: nodeColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: borderColor, width: 4),
                    boxShadow: isCurrent
                        ? [
                            BoxShadow(
                                color: diff.color.withOpacity(0.6),
                                blurRadius: 20,
                                spreadRadius: 2),
                            BoxShadow(
                                color: shadowColor,
                                offset: const Offset(0, 5),
                                blurRadius: 0,
                                spreadRadius: -2),
                          ]
                        : [
                            BoxShadow(
                                color: shadowColor,
                                offset: const Offset(0, 4),
                                blurRadius: 0),
                          ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isCompleted)
                        const Icon(Icons.check_rounded,
                            color: AppColors.white, size: 22)
                      else if (isLocked)
                        Icon(Icons.lock_rounded,
                            color: AppColors.white.withOpacity(0.35), size: 20)
                      else
                        const Icon(Icons.play_arrow_rounded,
                            color: AppColors.white, size: 26),
                      const SizedBox(height: 1),
                      Text('${level.number}',
                          style: TextStyle(
                              color: isLocked
                                  ? AppColors.white.withOpacity(0.3)
                                  : AppColors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ),
              if (isLeft) ...[
                const SizedBox(width: 10),
                if (isCompleted) StarRow(stars: level.stars),
                if (isCurrent)
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                        color: diff.color,
                        borderRadius: BorderRadius.circular(AppSizes.radiusSm)),
                    child: Text(level.label,
                        style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700)),
                  ),
              ],
              if (!isLeft && isCurrent) ...[
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                      color: diff.color,
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm)),
                  child: Text(level.label,
                      style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700)),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

// ── BOSS NODE ─────────────────────────────────────────────────
class _BossNode extends StatelessWidget {
  final QuizLevel level;
  final VoidCallback onTap;
  const _BossNode({required this.level, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isLocked = level.status == LevelStatus.locked;
    final isCurrent = level.status == LevelStatus.current;
    final isCompleted = level.status == LevelStatus.completed;

    return Column(
      children: [
        Container(
            width: 3, height: 20, color: AppColors.white.withOpacity(0.12)),
        GestureDetector(
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isLocked
                  ? const Color(0xFF2A1F5A)
                  : isCompleted
                      ? const Color(0xFF4C1D95)
                      : const Color(0xFF5B21B6),
              borderRadius: BorderRadius.circular(AppSizes.radiusXxl),
              border: Border.all(
                  color:
                      isLocked ? const Color(0xFF3B2F7A) : AppColors.bossDark,
                  width: 2),
              boxShadow: isCurrent
                  ? [
                      BoxShadow(
                          color: AppColors.boss.withOpacity(0.5),
                          blurRadius: 24,
                          spreadRadius: 2)
                    ]
                  : [],
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                      color: isLocked
                          ? AppColors.white.withOpacity(0.05)
                          : AppColors.bossDark,
                      shape: BoxShape.circle),
                  child: Icon(
                      isCompleted
                          ? Icons.emoji_events_rounded
                          : isLocked
                              ? Icons.lock_rounded
                              : Icons.local_fire_department_rounded,
                      color: isLocked ? AppColors.grey50 : AppColors.white,
                      size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Text(AppStrings.mockTest,
                            style: TextStyle(
                                color: isLocked
                                    ? AppColors.white.withOpacity(0.3)
                                    : AppColors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700)),
                        const SizedBox(width: 8),
                        if (!isLocked)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                                color: AppColors.bossDark,
                                borderRadius: BorderRadius.circular(6)),
                            child: const Text(AppStrings.boss,
                                style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5)),
                          ),
                      ]),
                      const SizedBox(height: 3),
                      Text(
                          isLocked
                              ? AppStrings.lockedLevel
                              : 'Level ${level.number} · 15 questions · 15s each',
                          style: TextStyle(
                              color: isLocked
                                  ? AppColors.white.withOpacity(0.24)
                                  : AppColors.white.withOpacity(0.54),
                              fontSize: 11)),
                      if (isCompleted) ...[
                        const SizedBox(height: 6),
                        StarRow(stars: level.stars),
                      ],
                    ],
                  ),
                ),
                if (!isLocked)
                  Icon(
                      isCompleted
                          ? Icons.replay_rounded
                          : Icons.arrow_forward_ios_rounded,
                      color: AppColors.white.withOpacity(0.54),
                      size: 16),
              ],
            ),
          ),
        ),
        Container(
            width: 3, height: 20, color: AppColors.white.withOpacity(0.12)),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// ACTIVE QUIZ SCREEN
// ═══════════════════════════════════════════════════════════════
class _QuizScreen extends StatelessWidget {
  final QuizController c;
  const _QuizScreen({required this.c});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: SafeArea(
        child: Obx(() {
          if (c.questions.isEmpty) return const LoadingOverlay();

          final level = c.currentLevel.value!;
          final q = c.currentQuestion;
          final diff = level.difficulty;

          return Column(
            children: [
              // Top bar
              Container(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                color: AppColors.white,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => _confirmExit(c),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                            color: AppColors.grey100,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.close_rounded,
                            size: 18, color: AppColors.grey400),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Level ${level.number} · ${diff.label}',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: diff.color,
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: (c.currentQIndex.value + 1) /
                                  c.totalQuestions,
                              minHeight: 6,
                              backgroundColor: AppColors.grey200,
                              color: diff.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text('${c.currentQIndex.value + 1}/${c.totalQuestions}',
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.grey400)),
                  ],
                ),
              ),

              // Timer
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: SizedBox(
                  width: 68,
                  height: 68,
                  child: Stack(fit: StackFit.expand, children: [
                    CircularProgressIndicator(
                      value: c.timerProgress,
                      strokeWidth: 6,
                      backgroundColor: AppColors.grey200,
                      color:
                          c.timeLeft.value <= 5 ? AppColors.error : diff.color,
                    ),
                    Center(
                      child: Text('${c.timeLeft.value}',
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: c.timeLeft.value <= 5
                                  ? AppColors.error
                                  : diff.color)),
                    ),
                  ]),
                ),
              ),

              // Question + options
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSizes.lg),
                  child: Column(
                    children: [
                      AppCard(
                        padding: const EdgeInsets.all(AppSizes.xl),
                        child: Text(q.question,
                            style: AppTextStylesLocal.question,
                            textAlign: TextAlign.center),
                      ),
                      const SizedBox(height: 16),
                      ...List.generate(
                          q.options.length,
                          (i) => _OptionTile(
                                text: q.options[i],
                                index: i,
                                correctIndex: q.correctIndex,
                                selectedIndex: c.selectedAnswer.value,
                                isAnswered: c.isAnswered.value,
                                accentColor: diff.color,
                                onTap: () => c.selectAnswer(i),
                              )),
                      if (c.isAnswered.value && q.explanation != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                              color: AppColors.primarySurface,
                              borderRadius: BorderRadius.circular(14)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.lightbulb_outline_rounded,
                                  color: AppColors.primary, size: 16),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(q.explanation!,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.primary,
                                        height: 1.5)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  void _confirmExit(QuizController c) {
    Get.dialog(AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(AppStrings.exitQuiz),
      content: const Text(AppStrings.exitWarning),
      actions: [
        TextButton(
            onPressed: () => Get.back(),
            child: const Text(AppStrings.continueQuiz)),
        ElevatedButton(
          onPressed: () {
            Get.back();
            c.exitQuiz();
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          child: const Text(AppStrings.exit,
              style: TextStyle(color: AppColors.white)),
        ),
      ],
    ));
  }
}

// Inline text styles to avoid import cycle
abstract class AppTextStylesLocal {
  static const question =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1.5);
}

// ── OPTION TILE ───────────────────────────────────────────────
class _OptionTile extends StatelessWidget {
  final String text;
  final int index, correctIndex;
  final int? selectedIndex;
  final bool isAnswered;
  final Color accentColor;
  final VoidCallback onTap;

  const _OptionTile({
    required this.text,
    required this.index,
    required this.correctIndex,
    required this.selectedIndex,
    required this.isAnswered,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color bg = AppColors.white;
    Color border = AppColors.cardBorder;
    Color textColor = AppColors.grey800;
    Widget? trailing;

    if (isAnswered) {
      if (index == correctIndex) {
        bg = AppColors.easySurface;
        border = AppColors.easy;
        textColor = AppColors.easyDark;
        trailing = const Icon(Icons.check_circle_rounded,
            color: AppColors.easy, size: 20);
      } else if (index == selectedIndex) {
        bg = AppColors.hardSurface;
        border = AppColors.hard;
        textColor = AppColors.hardDark;
        trailing =
            const Icon(Icons.cancel_rounded, color: AppColors.hard, size: 20);
      }
    }

    return GestureDetector(
      onTap: isAnswered ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          border: Border.all(color: border, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: isAnswered && index == correctIndex
                    ? AppColors.easy
                    : isAnswered && index == selectedIndex
                        ? AppColors.hard
                        : AppColors.grey100,
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
              child: Center(
                child: Text(['A', 'B', 'C', 'D'][index],
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isAnswered &&
                                (index == correctIndex ||
                                    index == selectedIndex)
                            ? AppColors.white
                            : AppColors.grey400)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
                child: Text(text,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: textColor))),
            if (trailing != null) ...[const SizedBox(width: 8), trailing],
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// RESULT SCREEN
// ═══════════════════════════════════════════════════════════════
class _ResultScreen extends StatelessWidget {
  final QuizController c;
  const _ResultScreen({required this.c});

  @override
  Widget build(BuildContext context) {
    final result = c.quizResult.value!;
    final level = c.currentLevel.value!;
    final diff = level.difficulty;
    final isPassed = result.starsEarned > 0;

    return Scaffold(
      backgroundColor: AppColors.mapBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.xxl),
          child: Column(
            children: [
              const SizedBox(height: AppSizes.lg),

              // Trophy / sad icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: (isPassed ? diff.color : AppColors.error)
                      .withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: isPassed ? diff.color : AppColors.error, width: 3),
                ),
                child: Icon(
                    isPassed
                        ? Icons.emoji_events_rounded
                        : Icons.sentiment_dissatisfied_rounded,
                    size: 48,
                    color: isPassed ? diff.color : AppColors.error),
              ),
              const SizedBox(height: 16),

              Text(isPassed ? AppStrings.levelComplete : AppStrings.tryAgain,
                  style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              Text('Level ${level.number} · ${diff.label}',
                  style: TextStyle(
                      color: AppColors.white.withOpacity(0.54), fontSize: 13)),
              const SizedBox(height: 20),

              // Stars
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) {
                  final filled = i < result.starsEarned;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Icon(Icons.star_rounded,
                        size: filled ? 48 : 36,
                        color: filled
                            ? AppColors.coin
                            : AppColors.white.withOpacity(0.15)),
                  );
                }),
              ),
              const SizedBox(height: 24),

              // Score panel
              Container(
                padding: const EdgeInsets.all(AppSizes.xl),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(AppSizes.radiusXxl),
                  border: Border.all(
                      color: AppColors.white.withOpacity(0.1), width: 0.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatBox(AppStrings.score, '${result.score}%', diff.color),
                    _StatBox(AppStrings.correct,
                        '${result.correct}/${result.total}', AppColors.easy),
                    _StatBox(AppStrings.xpEarned, '+${result.xpEarned}',
                        AppColors.coin),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Review
              Container(
                padding: const EdgeInsets.all(AppSizes.lg),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(AppSizes.radiusXl),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppStrings.answerReview,
                        style: TextStyle(
                            color: AppColors.white.withOpacity(0.7),
                            fontSize: 13,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    ...result.attempts.map((a) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Icon(
                                  a.isCorrect
                                      ? Icons.check_circle_rounded
                                      : Icons.cancel_rounded,
                                  size: 16,
                                  color: a.isCorrect
                                      ? AppColors.easy
                                      : AppColors.hard),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(a.question.question,
                                    style: TextStyle(
                                        color: AppColors.white.withOpacity(0.6),
                                        fontSize: 12),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: c.exitQuiz,
                      child: Container(
                        height: AppSizes.buttonLg,
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(0.1),
                          borderRadius:
                              BorderRadius.circular(AppSizes.radiusLg),
                          border: Border.all(
                              color: AppColors.white.withOpacity(0.24),
                              width: 0.5),
                        ),
                        child: const Center(
                          child: Text(AppStrings.map,
                              style: TextStyle(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: isPassed ? c.exitQuiz : c.retryLevel,
                      child: Container(
                        height: AppSizes.buttonLg,
                        decoration: BoxDecoration(
                          color: isPassed ? diff.color : AppColors.error,
                          borderRadius:
                              BorderRadius.circular(AppSizes.radiusLg),
                          boxShadow: [
                            BoxShadow(
                              color: (isPassed ? diff.color : AppColors.error)
                                  .withOpacity(0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                              isPassed
                                  ? AppStrings.nextLevel
                                  : AppStrings.tryAgain,
                              style: const TextStyle(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15)),
                        ),
                      ),
                    ),
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

class _StatBox extends StatelessWidget {
  final String label, value;
  final Color color;
  const _StatBox(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                color: color, fontSize: 22, fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        Text(label,
            style: TextStyle(
                color: AppColors.white.withOpacity(0.54), fontSize: 11)),
      ],
    );
  }
}
