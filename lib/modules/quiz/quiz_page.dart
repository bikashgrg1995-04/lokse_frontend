import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lokse/modules/quiz/quiz_model.dart';
import 'quiz_controller.dart';

class QuizPage extends StatelessWidget {
  const QuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(QuizController());

    return Obx(() {
      if (controller.showResult.value && controller.quizResult.value != null) {
        return _ResultScreen(controller: controller);
      }
      if (controller.isQuizActive.value) {
        return _ActiveQuizScreen(controller: controller);
      }
      return _MapScreen(controller: controller);
    });
  }
}

// ═══════════════════════════════════════════════════════════════
// MAP SCREEN  — Candy Crush style zigzag path
// ═══════════════════════════════════════════════════════════════
class _MapScreen extends StatelessWidget {
  final QuizController controller;
  const _MapScreen({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B2B6B),
      body: SafeArea(
        child: Column(
          children: [
            _MapHeader(controller: controller),
            Expanded(
              child: Obx(() => ListView.builder(
                    padding: const EdgeInsets.fromLTRB(0, 12, 0, 32),
                    itemCount: controller.levels.length,
                    itemBuilder: (_, i) => _LevelNode(
                      level: controller.levels[i],
                      isLeft: _isLeft(i),
                      onTap: () => controller.startLevel(controller.levels[i]),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  // zigzag: boss levels always centred, others alternate left/right
  bool _isLeft(int i) {
    if (controller.levels[i].isBoss)
      return false; // boss centred via special widget
    // count non-boss levels before i
    int nonBoss = 0;
    for (int j = 0; j < i; j++) {
      if (!controller.levels[j].isBoss) nonBoss++;
    }
    return nonBoss.isEven;
  }
}

// ── MAP HEADER ────────────────────────────────────────────────
class _MapHeader extends StatelessWidget {
  final QuizController controller;
  const _MapHeader({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
      decoration: const BoxDecoration(
        color: Color(0xFF1E3EBF),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Quiz Path',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.w700)),
                SizedBox(height: 2),
                Text('Level up to ace Loksewa',
                    style: TextStyle(color: Colors.white60, fontSize: 12)),
              ],
            ),
          ),
          Obx(() => Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        color: Color(0xFFF59E0B), size: 16),
                    const SizedBox(width: 5),
                    Text(
                      '${controller.totalXp.value} XP',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

// ── SINGLE LEVEL NODE ─────────────────────────────────────────
class _LevelNode extends StatelessWidget {
  final QuizLevel level;
  final bool isLeft;
  final VoidCallback onTap;

  const _LevelNode({
    required this.level,
    required this.isLeft,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (level.isBoss) return _BossNode(level: level, onTap: onTap);

    final diff = level.difficulty;
    final isCompleted = level.status == LevelStatus.completed;
    final isCurrent = level.status == LevelStatus.current;
    final isLocked = level.status == LevelStatus.locked;

    final nodeColor = isLocked
        ? const Color(0xFF2D3E8A)
        : isCompleted
            ? diff.color
            : diff.color;
    final borderColor = isLocked ? const Color(0xFF3D4E9A) : diff.darkColor;
    final shadowColor = isLocked ? Colors.transparent : diff.darkColor;

    return Column(
      children: [
        // connector line from previous
        Container(
          width: 3,
          height: 16,
          color: Colors.white.withOpacity(0.12),
          margin: EdgeInsets.only(
            left: isLeft ? 72 : 0,
            right: isLeft ? 0 : 72,
          ),
        ),
        // row with node
        Padding(
          padding: EdgeInsets.only(
            left: isLeft ? 48 : 0,
            right: isLeft ? 0 : 48,
          ),
          child: Row(
            mainAxisAlignment:
                isLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (!isLeft) ...[
                // stars on left for right-aligned nodes
                if (isCompleted) _StarRow(stars: level.stars),
                const SizedBox(width: 10),
              ],
              GestureDetector(
                onTap: onTap,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: isCurrent ? 72 : 64,
                  height: isCurrent ? 72 : 64,
                  decoration: BoxDecoration(
                    color: nodeColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: borderColor, width: 4),
                    boxShadow: isCurrent
                        ? [
                            BoxShadow(
                              color: diff.color.withOpacity(0.6),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
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
                            color: Colors.white, size: 22)
                      else if (isLocked)
                        Icon(Icons.lock_rounded,
                            color: Colors.white.withOpacity(0.35), size: 20)
                      else
                        Icon(Icons.play_arrow_rounded,
                            color: Colors.white, size: 26),
                      const SizedBox(height: 1),
                      Text(
                        '${level.number}',
                        style: TextStyle(
                          color: isLocked ? Colors.white30 : Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isLeft) ...[
                const SizedBox(width: 10),
                if (isCompleted) _StarRow(stars: level.stars),
                if (isCurrent)
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: diff.color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      level.label,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
              ],
              if (!isLeft && isCurrent) ...[
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: diff.color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    level.label,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700),
                  ),
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
          width: 3,
          height: 20,
          color: Colors.white.withOpacity(0.12),
        ),
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
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isLocked
                    ? const Color(0xFF3B2F7A)
                    : const Color(0xFF7C3AED),
                width: 2,
              ),
              boxShadow: isCurrent
                  ? [
                      BoxShadow(
                          color: const Color(0xFF8B5CF6).withOpacity(0.5),
                          blurRadius: 24,
                          spreadRadius: 2),
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
                        ? Colors.white.withOpacity(0.05)
                        : const Color(0xFF7C3AED),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isCompleted
                        ? Icons.emoji_events_rounded
                        : isLocked
                            ? Icons.lock_rounded
                            : Icons.local_fire_department_rounded,
                    color: isLocked ? Colors.white24 : Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Mock Test',
                            style: TextStyle(
                              color: isLocked ? Colors.white30 : Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (!isLocked)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF7C3AED),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'BOSS',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        isLocked
                            ? 'Complete previous levels to unlock'
                            : 'Level ${level.number} · 15 questions · 15s each',
                        style: TextStyle(
                          color: isLocked ? Colors.white24 : Colors.white54,
                          fontSize: 11,
                        ),
                      ),
                      if (isCompleted) ...[
                        const SizedBox(height: 6),
                        _StarRow(stars: level.stars),
                      ],
                    ],
                  ),
                ),
                if (!isLocked)
                  Icon(
                    isCompleted
                        ? Icons.replay_rounded
                        : Icons.arrow_forward_ios_rounded,
                    color: Colors.white54,
                    size: 16,
                  ),
              ],
            ),
          ),
        ),
        Container(
          width: 3,
          height: 20,
          color: Colors.white.withOpacity(0.12),
        ),
      ],
    );
  }
}

// ── STAR ROW ─────────────────────────────────────────────────
class _StarRow extends StatelessWidget {
  final int stars;
  const _StarRow({required this.stars});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        3,
        (i) => Icon(
          Icons.star_rounded,
          size: 14,
          color: i < stars
              ? const Color(0xFFF59E0B)
              : Colors.white.withOpacity(0.2),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// ACTIVE QUIZ SCREEN
// ═══════════════════════════════════════════════════════════════
class _ActiveQuizScreen extends StatelessWidget {
  final QuizController controller;
  const _ActiveQuizScreen({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      body: SafeArea(
        child: Obx(() {
          if (controller.questions.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          final level = controller.currentLevel.value!;
          final q = controller.currentQuestion;
          final diff = level.difficulty;

          return Column(
            children: [
              // ── Quiz top bar ────────────────────────────────
              Container(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                color: Colors.white,
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => _showExitDialog(controller),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.close_rounded,
                                size: 18, color: Colors.grey),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Level ${level.number} · ${diff.label}',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: diff.color,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 4),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: (controller.currentQIndex.value + 1) /
                                      controller.totalQuestions,
                                  minHeight: 6,
                                  backgroundColor: Colors.grey.shade200,
                                  color: diff.color,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${controller.currentQIndex.value + 1}/${controller.totalQuestions}',
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ── Timer ring ──────────────────────────────────
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: SizedBox(
                  width: 68,
                  height: 68,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        value: controller.timerProgress,
                        strokeWidth: 6,
                        backgroundColor: Colors.grey.shade200,
                        color: controller.timeLeft.value <= 5
                            ? Colors.red
                            : diff.color,
                      ),
                      Center(
                        child: Text(
                          '${controller.timeLeft.value}',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: controller.timeLeft.value <= 5
                                ? Colors.red
                                : diff.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Question card ───────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                              color: Colors.black.withOpacity(0.07),
                              width: 0.5),
                        ),
                        child: Text(
                          q.question,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              height: 1.5),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...List.generate(q.options.length, (i) {
                        return _OptionTile(
                          text: q.options[i],
                          index: i,
                          correctIndex: q.correctIndex,
                          selectedIndex: controller.selectedAnswer.value,
                          isAnswered: controller.isAnswered.value,
                          accentColor: diff.color,
                          onTap: () => controller.selectAnswer(i),
                        );
                      }),

                      // explanation after answer
                      if (controller.isAnswered.value &&
                          q.explanation != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEF1FB),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.lightbulb_outline_rounded,
                                  color: Color(0xFF1E3EBF), size: 16),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  q.explanation!,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF1E3EBF),
                                      height: 1.5),
                                ),
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

  void _showExitDialog(QuizController c) {
    Get.dialog(AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Exit Quiz?'),
      content: const Text('Your progress in this level will be lost.'),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Continue')),
        ElevatedButton(
          onPressed: () {
            Get.back();
            c.exitQuiz();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text('Exit', style: TextStyle(color: Colors.white)),
        ),
      ],
    ));
  }
}

// ── OPTION TILE ───────────────────────────────────────────────
class _OptionTile extends StatelessWidget {
  final String text;
  final int index;
  final int correctIndex;
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
    Color bgColor = Colors.white;
    Color borderColor = Colors.black.withOpacity(0.08);
    Color textColor = Colors.black87;
    Widget? trailingIcon;

    if (isAnswered) {
      if (index == correctIndex) {
        bgColor = const Color(0xFFDCFCE7);
        borderColor = const Color(0xFF22C55E);
        textColor = const Color(0xFF15803D);
        trailingIcon = const Icon(Icons.check_circle_rounded,
            color: Color(0xFF22C55E), size: 20);
      } else if (index == selectedIndex) {
        bgColor = const Color(0xFFFEE2E2);
        borderColor = const Color(0xFFEF4444);
        textColor = const Color(0xFFDC2626);
        trailingIcon = const Icon(Icons.cancel_rounded,
            color: Color(0xFFEF4444), size: 20);
      }
    }

    return GestureDetector(
      onTap: isAnswered ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          children: [
            // letter badge
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: isAnswered && index == correctIndex
                    ? const Color(0xFF22C55E)
                    : isAnswered && index == selectedIndex
                        ? const Color(0xFFEF4444)
                        : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  ['A', 'B', 'C', 'D'][index],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isAnswered &&
                            (index == correctIndex || index == selectedIndex)
                        ? Colors.white
                        : Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: textColor),
              ),
            ),
            if (trailingIcon != null) ...[
              const SizedBox(width: 8),
              trailingIcon,
            ],
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
  final QuizController controller;
  const _ResultScreen({required this.controller});

  @override
  Widget build(BuildContext context) {
    final result = controller.quizResult.value!;
    final level = controller.currentLevel.value!;
    final diff = level.difficulty;
    final isPassed = result.starsEarned > 0;

    return Scaffold(
      backgroundColor: const Color(0xFF1B2B6B),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 16),

              // ── Result icon ─────────────────────────────────
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: isPassed
                      ? diff.color.withOpacity(0.2)
                      : Colors.red.withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isPassed ? diff.color : Colors.red,
                    width: 3,
                  ),
                ),
                child: Icon(
                  isPassed
                      ? Icons.emoji_events_rounded
                      : Icons.sentiment_dissatisfied_rounded,
                  size: 48,
                  color: isPassed ? diff.color : Colors.red,
                ),
              ),
              const SizedBox(height: 16),

              Text(
                isPassed ? 'Level Complete!' : 'Try Again!',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              Text(
                'Level ${level.number} · ${diff.label}',
                style: const TextStyle(color: Colors.white54, fontSize: 13),
              ),
              const SizedBox(height: 20),

              // ── Stars ───────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) {
                  final filled = i < result.starsEarned;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Icon(
                      Icons.star_rounded,
                      size: filled ? 48 : 36,
                      color: filled
                          ? const Color(0xFFF59E0B)
                          : Colors.white.withOpacity(0.15),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),

              // ── Score card ──────────────────────────────────
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: Colors.white.withOpacity(0.1), width: 0.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatBox(
                        label: 'Score',
                        value: '${result.score}%',
                        color: diff.color),
                    _StatBox(
                        label: 'Correct',
                        value: '${result.correct}/${result.total}',
                        color: const Color(0xFF22C55E)),
                    _StatBox(
                        label: 'XP Earned',
                        value: '+${result.xpEarned}',
                        color: const Color(0xFFF59E0B)),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Answer review ───────────────────────────────
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Answer Review',
                        style: TextStyle(
                            color: Colors.white70,
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
                                    ? const Color(0xFF22C55E)
                                    : const Color(0xFFEF4444),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  a.question.question,
                                  style: const TextStyle(
                                      color: Colors.white60, fontSize: 12),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // ── Buttons ─────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: controller.exitQuiz,
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white24, width: 0.5),
                        ),
                        child: const Center(
                          child: Text('Map',
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: isPassed
                          ? controller.exitQuiz
                          : controller.retryLevel,
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: isPassed ? diff.color : Colors.red,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: (isPassed ? diff.color : Colors.red)
                                  .withOpacity(0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            isPassed ? 'Next Level' : 'Try Again',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 15),
                          ),
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
  final String label;
  final String value;
  final Color color;
  const _StatBox(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                color: color, fontSize: 22, fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(color: Colors.white54, fontSize: 11)),
      ],
    );
  }
}
