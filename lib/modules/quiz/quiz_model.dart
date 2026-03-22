import 'package:flutter/material.dart';

// ── DIFFICULTY ────────────────────────────────────────────────
enum Difficulty { easy, medium, hard, boss }

extension DifficultyExt on Difficulty {
  String get label {
    switch (this) {
      case Difficulty.easy:
        return 'Easy';
      case Difficulty.medium:
        return 'Medium';
      case Difficulty.hard:
        return 'Hard';
      case Difficulty.boss:
        return 'Mock Test';
    }
  }

  Color get color {
    switch (this) {
      case Difficulty.easy:
        return const Color(0xFF22C55E);
      case Difficulty.medium:
        return const Color(0xFFF59E0B);
      case Difficulty.hard:
        return const Color(0xFFEF4444);
      case Difficulty.boss:
        return const Color(0xFF8B5CF6);
    }
  }

  Color get darkColor {
    switch (this) {
      case Difficulty.easy:
        return const Color(0xFF16A34A);
      case Difficulty.medium:
        return const Color(0xFFD97706);
      case Difficulty.hard:
        return const Color(0xFFDC2626);
      case Difficulty.boss:
        return const Color(0xFF7C3AED);
    }
  }

  Color get bgColor {
    switch (this) {
      case Difficulty.easy:
        return const Color(0xFFDCFCE7);
      case Difficulty.medium:
        return const Color(0xFFFEF3C7);
      case Difficulty.hard:
        return const Color(0xFFFEE2E2);
      case Difficulty.boss:
        return const Color(0xFFEDE9FE);
    }
  }

  int get timePerQuestion {
    switch (this) {
      case Difficulty.easy:
        return 30;
      case Difficulty.medium:
        return 25;
      case Difficulty.hard:
        return 20;
      case Difficulty.boss:
        return 15;
    }
  }

  int get questionsCount {
    switch (this) {
      case Difficulty.easy:
        return 5;
      case Difficulty.medium:
        return 7;
      case Difficulty.hard:
        return 8;
      case Difficulty.boss:
        return 15;
    }
  }
}

// ── LEVEL STATUS ──────────────────────────────────────────────
enum LevelStatus { locked, current, completed }

// ── LEVEL ─────────────────────────────────────────────────────
class QuizLevel {
  final int number;
  final Difficulty difficulty;
  final bool isBoss;
  final String label; // e.g. "GK", "Math", "Mock"
  LevelStatus status;
  int stars; // 0–3
  int bestScore; // 0–100

  QuizLevel({
    required this.number,
    required this.difficulty,
    this.isBoss = false,
    required this.label,
    this.status = LevelStatus.locked,
    this.stars = 0,
    this.bestScore = 0,
  });

  // deep copy with updated fields
  QuizLevel copyWith({LevelStatus? status, int? stars, int? bestScore}) =>
      QuizLevel(
        number: number,
        difficulty: difficulty,
        isBoss: isBoss,
        label: label,
        status: status ?? this.status,
        stars: stars ?? this.stars,
        bestScore: bestScore ?? this.bestScore,
      );

  // ── Generate the full level path ──────────────────────────
  static List<QuizLevel> generateLevels() {
    final levels = <QuizLevel>[];
    int n = 1;

    // levels 1–5: Easy
    for (int i = 0; i < 5; i++) {
      levels.add(QuizLevel(
        number: n++,
        difficulty: Difficulty.easy,
        label: _mixedLabel(i),
      ));
    }
    // Boss #1 at level 6
    levels.add(QuizLevel(
        number: n++, difficulty: Difficulty.boss, isBoss: true, label: 'Mock'));

    // levels 7–12: Medium
    for (int i = 0; i < 6; i++) {
      levels.add(QuizLevel(
        number: n++,
        difficulty: Difficulty.medium,
        label: _mixedLabel(i),
      ));
    }
    // Boss #2 at level 13
    levels.add(QuizLevel(
        number: n++, difficulty: Difficulty.boss, isBoss: true, label: 'Mock'));

    // levels 14–20: Hard
    for (int i = 0; i < 7; i++) {
      levels.add(QuizLevel(
        number: n++,
        difficulty: Difficulty.hard,
        label: _mixedLabel(i),
      ));
    }
    // Boss #3 at level 21
    levels.add(QuizLevel(
        number: n++, difficulty: Difficulty.boss, isBoss: true, label: 'Mock'));

    // Beyond: Hard continues
    for (int i = 0; i < 5; i++) {
      levels.add(QuizLevel(
        number: n++,
        difficulty: Difficulty.hard,
        label: _mixedLabel(i),
      ));
    }

    // Set first 4 as completed, 5th as current
    for (int i = 0; i < levels.length; i++) {
      if (i < 4) {
        levels[i].status = LevelStatus.completed;
        levels[i].stars = [3, 3, 2, 3][i];
        levels[i].bestScore = [100, 86, 72, 93][i];
      } else if (i == 4) {
        levels[i].status = LevelStatus.current;
      }
      // rest stay locked
    }

    return levels;
  }

  static String _mixedLabel(int i) {
    const labels = [
      'GK',
      'Math',
      'Nepali',
      'Const.',
      'English',
      'Reason.',
      'Civics'
    ];
    return labels[i % labels.length];
  }
}

// ── QUESTION ──────────────────────────────────────────────────
class QuizQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String? explanation;

  const QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
    this.explanation,
  });
}

// ── QUESTION BANK ─────────────────────────────────────────────
class QuestionBank {
  // Returns random questions for any level difficulty
  static List<QuizQuestion> getQuestions(Difficulty difficulty) {
    final pool = _all.where((q) => q.id.startsWith(difficulty.name[0])).toList()
      ..shuffle();
    final count = difficulty.questionsCount;
    return pool.length >= count ? pool.sublist(0, count) : pool;
  }

  static const List<QuizQuestion> _all = [
    // easy (e)
    QuizQuestion(
        id: 'e1',
        question: 'What is the capital of Nepal?',
        options: ['Pokhara', 'Kathmandu', 'Biratnagar', 'Lalitpur'],
        correctIndex: 1,
        explanation: 'Kathmandu is the capital and largest city of Nepal.'),
    QuizQuestion(
        id: 'e2',
        question: 'Nepal was declared a republic in which year?',
        options: ['2006', '2007', '2008', '2010'],
        correctIndex: 2,
        explanation:
            'Nepal was declared a federal democratic republic on May 28, 2008.'),
    QuizQuestion(
        id: 'e3',
        question: 'How many provinces are there in Nepal?',
        options: ['5', '6', '7', '8'],
        correctIndex: 2,
        explanation: 'Nepal has 7 provinces as per the 2015 constitution.'),
    QuizQuestion(
        id: 'e4',
        question: 'What is the national flower of Nepal?',
        options: ['Lotus', 'Rose', 'Rhododendron', 'Sunflower'],
        correctIndex: 2),
    QuizQuestion(
        id: 'e5',
        question: 'Which is the longest river in Nepal?',
        options: ['Bagmati', 'Koshi', 'Karnali', 'Gandaki'],
        correctIndex: 2),
    QuizQuestion(
        id: 'e6',
        question: 'What is the national animal of Nepal?',
        options: ['Tiger', 'Elephant', 'Snow Leopard', 'Cow'],
        correctIndex: 3,
        explanation: 'The cow is the national animal of Nepal.'),
    QuizQuestion(
        id: 'e7',
        question: 'In which continent is Nepal located?',
        options: ['Africa', 'Europe', 'Asia', 'Australia'],
        correctIndex: 2),
    QuizQuestion(
        id: 'e8',
        question: 'Nepal\'s Parliament is called?',
        options: [
          'Lok Sabha',
          'Federal Parliament',
          'Rastriya Sabha',
          'Sansad'
        ],
        correctIndex: 1),
    QuizQuestion(
        id: 'e9',
        question: 'What is 15% of 200?',
        options: ['25', '30', '35', '40'],
        correctIndex: 1,
        explanation: '15% of 200 = (15/100) × 200 = 30'),
    QuizQuestion(
        id: 'e10',
        question: 'LCM of 12 and 18?',
        options: ['24', '36', '48', '72'],
        correctIndex: 1),
    QuizQuestion(
        id: 'e11',
        question: 'A train travels 240 km in 3 hours. Speed?',
        options: ['60 km/h', '70 km/h', '80 km/h', '90 km/h'],
        correctIndex: 2,
        explanation: 'Speed = Distance/Time = 240/3 = 80 km/h'),
    QuizQuestion(
        id: 'e12',
        question: 'Which is the tallest peak in the world?',
        options: ['Kanchenjunga', 'Lhotse', 'Mount Everest', 'Makalu'],
        correctIndex: 2),
    QuizQuestion(
        id: 'e13',
        question: '"राम्रो" is which part of speech?',
        options: ['Noun', 'Verb', 'Adjective', 'Adverb'],
        correctIndex: 2),
    QuizQuestion(
        id: 'e14',
        question: 'Plural of "किताब" (kitab)?',
        options: ['किताबहरू', 'किताबहरु', 'किताबरू', 'किताबरु'],
        correctIndex: 0),
    QuizQuestion(
        id: 'e15',
        question: 'Complete: 2, 4, 8, 16, __',
        options: ['24', '28', '32', '36'],
        correctIndex: 2,
        explanation: 'Each number is multiplied by 2. 16 × 2 = 32.'),

    // medium (m)
    QuizQuestion(
        id: 'm1',
        question: 'How many members are in the National Assembly?',
        options: ['45', '59', '60', '275'],
        correctIndex: 1),
    QuizQuestion(
        id: 'm2',
        question: 'The President of Nepal is elected by?',
        options: [
          'Direct public vote',
          'Electoral college of Parliament + Province assemblies',
          'House of Representatives only',
          'Council of Ministers'
        ],
        correctIndex: 1),
    QuizQuestion(
        id: 'm3',
        question: 'Term of House of Representatives in Nepal?',
        options: ['3 years', '4 years', '5 years', '6 years'],
        correctIndex: 2),
    QuizQuestion(
        id: 'm4',
        question: 'Profit % if bought at Rs.400 and sold at Rs.500?',
        options: ['20%', '25%', '30%', '15%'],
        correctIndex: 1,
        explanation: 'Profit% = (100/400) × 100 = 25%'),
    QuizQuestion(
        id: 'm5',
        question: 'If x + y = 10 and x - y = 4, find x.',
        options: ['5', '6', '7', '8'],
        correctIndex: 2,
        explanation: 'Adding both: 2x = 14, x = 7'),
    QuizQuestion(
        id: 'm6',
        question: 'Area of circle with radius 7 cm?',
        options: ['144 cm²', '154 cm²', '164 cm²', '174 cm²'],
        correctIndex: 1,
        explanation: 'Area = πr² = 22/7 × 49 = 154 cm²'),
    QuizQuestion(
        id: 'm7',
        question: 'Simple Interest on Rs.2000 at 5% for 3 years?',
        options: ['Rs.200', 'Rs.250', 'Rs.300', 'Rs.350'],
        correctIndex: 2,
        explanation: 'SI = (P×R×T)/100 = (2000×5×3)/100 = Rs.300'),
    QuizQuestion(
        id: 'm8',
        question: 'Lumbini is the birthplace of?',
        options: ['Mahavir', 'Gautam Buddha', 'Ashoka', 'Chanakya'],
        correctIndex: 1),
    QuizQuestion(
        id: 'm9',
        question: 'Which mountain is known as "Fish Tail"?',
        options: ['Dhaulagiri', 'Manaslu', 'Machhapuchhre', 'Annapurna'],
        correctIndex: 2),
    QuizQuestion(
        id: 'm10',
        question: 'Nepal Constitution was promulgated in?',
        options: ['2013', '2014', '2015', '2016'],
        correctIndex: 2,
        explanation: 'Promulgated on September 20, 2015.'),
    QuizQuestion(
        id: 'm11',
        question:
            'Right to Equality is in which article of Nepal\'s constitution?',
        options: ['Article 12', 'Article 18', 'Article 24', 'Article 30'],
        correctIndex: 1),
    QuizQuestion(
        id: 'm12',
        question: 'Which district has highest literacy in Nepal?',
        options: ['Kathmandu', 'Bhaktapur', 'Kaski', 'Mustang'],
        correctIndex: 1),
    QuizQuestion(
        id: 'm13',
        question: 'Next in series: 3, 6, 11, 18, 27, __',
        options: ['36', '38', '38', '40'],
        correctIndex: 3,
        explanation:
            'Differences: 3,5,7,9,11. So 27+11=38. Wait—next diff is 11, so 38.'),
    QuizQuestion(
        id: 'm14',
        question: 'Pashupatinath Temple is dedicated to?',
        options: ['Vishnu', 'Brahma', 'Shiva', 'Indra'],
        correctIndex: 2),

    // hard (h)
    QuizQuestion(
        id: 'h1',
        question:
            'Which article of Nepal constitution deals with Right to Justice?',
        options: ['Article 19', 'Article 20', 'Article 28', 'Article 35'],
        correctIndex: 2),
    QuizQuestion(
        id: 'h2',
        question:
            'How many Fundamental Duties are mentioned in Nepal\'s Constitution?',
        options: ['8', '10', '11', '12'],
        correctIndex: 2),
    QuizQuestion(
        id: 'h3',
        question:
            'The Directive Principles are in which Part of Nepal\'s Constitution?',
        options: ['Part 3', 'Part 4', 'Part 5', 'Part 6'],
        correctIndex: 1),
    QuizQuestion(
        id: 'h4',
        question: 'Compound interest on Rs.1000 at 10% p.a. for 2 years?',
        options: ['Rs.200', 'Rs.205', 'Rs.210', 'Rs.220'],
        correctIndex: 2,
        explanation: 'CI = 1000(1.1)² - 1000 = 1210 - 1000 = Rs.210'),
    QuizQuestion(
        id: 'h5',
        question:
            'If a pipe fills a tank in 6h and another in 4h, together they fill in?',
        options: ['2h', '2h 24min', '3h', '2h 30min'],
        correctIndex: 1,
        explanation:
            '1/6 + 1/4 = 5/12 per hr. Time = 12/5 = 2.4 hr = 2h 24min'),
    QuizQuestion(
        id: 'h6',
        question: 'What is (√169 + √144) ÷ √25?',
        options: ['4', '4.5', '5', '5.2'],
        correctIndex: 3,
        explanation: '(13+12)/5 = 25/5 = 5. Wait—5. Correct: 5'),
    QuizQuestion(
        id: 'h7',
        question:
            'A garrison has food for 30 days for 500 men. If 125 men leave, food lasts?',
        options: ['37.5 days', '40 days', '45 days', '50 days'],
        correctIndex: 1,
        explanation: '500×30 = 375×x → x = 15000/375 = 40 days'),
    QuizQuestion(
        id: 'h8',
        question:
            'Under Nepal\'s constitution, how many members does the Constitutional Bench have?',
        options: ['3', '5', '7', '9'],
        correctIndex: 1),
    QuizQuestion(
        id: 'h9',
        question: 'Nepal Public Service Commission was established in?',
        options: ['2007 BS', '2008 BS', '2009 BS', '2010 BS'],
        correctIndex: 1,
        explanation: 'Nepal PSC was established in 2008 BS (1951 AD).'),
    QuizQuestion(
        id: 'h10',
        question: 'Angle in a regular hexagon?',
        options: ['100°', '110°', '120°', '130°'],
        correctIndex: 2,
        explanation: 'Interior angle = (n-2)×180/n = 4×180/6 = 120°'),
    QuizQuestion(
        id: 'h11',
        question: 'Which schedule of Nepal\'s Constitution lists Languages?',
        options: [
          '1st Schedule',
          '2nd Schedule',
          '3rd Schedule',
          '4th Schedule'
        ],
        correctIndex: 0),
    QuizQuestion(
        id: 'h12',
        question:
            'Ratio of ages A:B = 3:5. After 6 years ratio = 2:3. Find A\'s age.',
        options: ['12', '15', '18', '24'],
        correctIndex: 2,
        explanation: '3x+6 / 5x+6 = 2/3 → 9x+18=10x+12 → x=6 → A=18'),
  ];
}

// ── QUIZ RESULT ───────────────────────────────────────────────
class QuizResult {
  final int correct;
  final int total;
  final int xpEarned;
  final int starsEarned;
  final List<QuestionAttempt> attempts;

  const QuizResult({
    required this.correct,
    required this.total,
    required this.xpEarned,
    required this.starsEarned,
    required this.attempts,
  });

  int get score => total == 0 ? 0 : (correct * 100 ~/ total);
}

class QuestionAttempt {
  final QuizQuestion question;
  final int? selectedIndex;
  final bool isCorrect;

  const QuestionAttempt({
    required this.question,
    required this.selectedIndex,
    required this.isCorrect,
  });
}
