import 'dart:async';

import 'package:get/get.dart';
import 'package:lokse/core/utils/status_message.dart';
import 'package:lokse/modules/quiz/quiz_model.dart';

class QuizController extends GetxController {
  // ── Level map state ───────────────────────────────────────
  final levels = <QuizLevel>[].obs;
  final totalXp = 1240.obs;

  // ── Active quiz state ─────────────────────────────────────
  final isQuizActive = false.obs;
  final currentLevel = Rxn<QuizLevel>();
  final questions = <QuizQuestion>[].obs;
  final currentQIndex = 0.obs;
  final selectedAnswer = Rxn<int>();
  final isAnswered = false.obs;
  final timeLeft = 30.obs;
  final attempts = <QuestionAttempt>[].obs;

  Timer? _timer;

  // ── Result state ──────────────────────────────────────────
  final quizResult = Rxn<QuizResult>();
  final showResult = false.obs;

  @override
  void onInit() {
    super.onInit();
    levels.assignAll(QuizLevel.generateLevels());
  }

  // ── Start a level ─────────────────────────────────────────
  void startLevel(QuizLevel level) {
    if (level.status == LevelStatus.locked) {
      StatusMessage.warning('Complete the previous level first!');
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

  // ── Timer ─────────────────────────────────────────────────
  void _startTimer() {
    _timer?.cancel();
    timeLeft.value = currentLevel.value!.difficulty.timePerQuestion;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (timeLeft.value > 0) {
        timeLeft.value--;
      } else {
        _onTimeUp();
      }
    });
  }

  void _onTimeUp() {
    if (isAnswered.value) return;
    _recordAttempt(null); // timed out = wrong
    _moveNext();
  }

  // ── Select answer ─────────────────────────────────────────
  void selectAnswer(int index) {
    if (isAnswered.value) return;
    _timer?.cancel();
    selectedAnswer.value = index;
    isAnswered.value = true;
    _recordAttempt(index);

    // brief pause then advance
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

  // ── Move to next question ─────────────────────────────────
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

  // ── Finish quiz ───────────────────────────────────────────
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
    final xp = correct * 10 + (stars * 20);

    quizResult.value = QuizResult(
      correct: correct,
      total: total,
      xpEarned: xp,
      starsEarned: stars,
      attempts: List.from(attempts),
    );

    // Update level
    final idx =
        levels.indexWhere((l) => l.number == currentLevel.value!.number);
    if (idx != -1) {
      final prev = levels[idx];
      if (stars > 0) {
        levels[idx] = prev.copyWith(
          status: LevelStatus.completed,
          stars: stars > prev.stars ? stars : prev.stars,
          bestScore: score > prev.bestScore ? score : prev.bestScore,
        );
        // unlock next
        if (idx + 1 < levels.length &&
            levels[idx + 1].status == LevelStatus.locked) {
          levels[idx + 1] =
              levels[idx + 1].copyWith(status: LevelStatus.current);
        }
      }
      levels.refresh();
    }

    // Add XP
    totalXp.value += xp;
    showResult.value = true;
  }

  // ── Exit mid-quiz ─────────────────────────────────────────
  void exitQuiz() {
    _timer?.cancel();
    isQuizActive.value = false;
    showResult.value = false;
    currentLevel.value = null;
  }

  // ── Retry same level ──────────────────────────────────────
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

  // ── Helpers ───────────────────────────────────────────────
  QuizQuestion get currentQuestion => questions[currentQIndex.value];
  int get totalQuestions => questions.length;
  double get timerProgress =>
      timeLeft.value / (currentLevel.value?.difficulty.timePerQuestion ?? 30);
}
