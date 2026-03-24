import 'dart:async';
import 'package:get/get.dart';
import 'package:lokse/core/constants/app_strings.dart';
import 'package:lokse/core/utils/global_controller.dart';
import 'package:lokse/core/utils/status_message.dart';
import 'package:lokse/modules/quiz/quiz_model.dart';

class QuizController extends GetxController {
  // ── Map state ─────────────────────────────────────────
  final levels = <QuizLevel>[].obs;

  // ── Active quiz ───────────────────────────────────────
  final isQuizActive = false.obs;
  final currentLevel = Rxn<QuizLevel>();
  final questions = <QuizQuestion>[].obs;
  final currentQIndex = 0.obs;
  final selectedAnswer = Rxn<int>();
  final isAnswered = false.obs;
  final timeLeft = 30.obs;
  final attempts = <QuestionAttempt>[].obs;
  Timer? _timer;

  // ── Result ────────────────────────────────────────────
  final quizResult = Rxn<QuizResult>();
  final showResult = false.obs;

  @override
  void onInit() {
    super.onInit();
    levels.assignAll(QuizLevel.generateLevels());
  }

  // ── Convenience ───────────────────────────────────────
  QuizQuestion get currentQuestion => questions[currentQIndex.value];
  int get totalQuestions => questions.length;
  double get timerProgress =>
      timeLeft.value / (currentLevel.value?.difficulty.timePerQuestion ?? 30);

  // ── Start level ───────────────────────────────────────
  void startLevel(QuizLevel level) {
    if (level.status == LevelStatus.locked) {
      StatusMessage.warning(AppStrings.lockedLevel);
      return;
    }
    currentLevel.value = level;
    questions.assignAll(QuestionBank.getQuestions(level.difficulty));
    currentQIndex.value = 0;
    attempts.clear();
    selectedAnswer.value = null;
    isAnswered.value = false;
    quizResult.value = null;
    showResult.value = false;
    isQuizActive.value = true;
    _startTimer();
  }

  // ── Timer ─────────────────────────────────────────────
  void _startTimer() {
    _timer?.cancel();
    timeLeft.value = currentLevel.value!.difficulty.timePerQuestion;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (timeLeft.value > 0) {
        timeLeft.value--;
      } else {
        if (!isAnswered.value) {
          _recordAttempt(null);
          _moveNext();
        }
      }
    });
  }

  // ── Answer ────────────────────────────────────────────
  void selectAnswer(int index) {
    if (isAnswered.value) return;
    _timer?.cancel();
    selectedAnswer.value = index;
    isAnswered.value = true;
    _recordAttempt(index);
    Future.delayed(const Duration(milliseconds: 900), _moveNext);
  }

  void _recordAttempt(int? index) {
    final q = questions[currentQIndex.value];
    attempts.add(QuestionAttempt(
      question: q,
      selectedIndex: index,
      isCorrect: index == q.correctIndex,
    ));
  }

  void _moveNext() {
    if (currentQIndex.value < questions.length - 1) {
      currentQIndex.value++;
      selectedAnswer.value = null;
      isAnswered.value = false;
      _startTimer();
    } else {
      _finishQuiz();
    }
  }

  // ── Finish ────────────────────────────────────────────
  void _finishQuiz() {
    _timer?.cancel();
    isQuizActive.value = false;

    final correct = attempts.where((a) => a.isCorrect).length;
    final total = attempts.length;
    final score = total == 0 ? 0 : (correct * 100 ~/ total);
    final stars = score >= 90
        ? 3
        : score >= 60
            ? 2
            : score >= 40
                ? 1
                : 0;
    final xp = correct * 10 + stars * 20;

    quizResult.value = QuizResult(
      correct: correct,
      total: total,
      xpEarned: xp,
      starsEarned: stars,
      attempts: List.from(attempts),
    );

    // ✅ Report to GlobalController — XP + coins update everywhere
    GlobalController.instance.onQuizComplete(
      xp: xp,
      correct: correct,
      total: total,
    );

    // Update level state
    final idx =
        levels.indexWhere((l) => l.number == currentLevel.value!.number);
    if (idx != -1 && stars > 0) {
      final prev = levels[idx];
      levels[idx] = prev.copyWith(
        status: LevelStatus.completed,
        stars: stars > prev.stars ? stars : prev.stars,
        bestScore: score > prev.bestScore ? score : prev.bestScore,
      );
      if (idx + 1 < levels.length &&
          levels[idx + 1].status == LevelStatus.locked) {
        levels[idx + 1] = levels[idx + 1].copyWith(status: LevelStatus.current);
      }
      levels.refresh();
    }

    showResult.value = true;
  }

  // ── Exit / Retry ──────────────────────────────────────
  void exitQuiz() {
    _timer?.cancel();
    isQuizActive.value = false;
    showResult.value = false;
    currentLevel.value = null;
  }

  void retryLevel() {
    final level = currentLevel.value;
    if (level == null) return;
    showResult.value = false;
    startLevel(level);
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
