import 'package:flutter/material.dart';

// ── POST (Kharidar, Subba, etc.) ──────────────────────────────
class LoksewaPost {
  final String id;
  final String label;

  const LoksewaPost({required this.id, required this.label});

  static const List<LoksewaPost> all = [
    LoksewaPost(id: 'all', label: 'All Posts'),
    LoksewaPost(id: 'kharidar', label: 'Kharidar'),
    LoksewaPost(id: 'subba', label: 'Subba'),
    LoksewaPost(id: 'nayab_subba', label: 'Nayab Subba'),
    LoksewaPost(id: 'officer', label: 'Officer'),
    LoksewaPost(id: 'inspector', label: 'Inspector'),
  ];
}

// ── CONTENT TYPE ──────────────────────────────────────────────
enum ContentType { notes, mcq, previousYear }

extension ContentTypeExt on ContentType {
  String get label {
    switch (this) {
      case ContentType.notes:
        return 'Notes';
      case ContentType.mcq:
        return 'MCQ Sets';
      case ContentType.previousYear:
        return 'Previous Year';
    }
  }

  IconData get icon {
    switch (this) {
      case ContentType.notes:
        return Icons.article_outlined;
      case ContentType.mcq:
        return Icons.quiz_outlined;
      case ContentType.previousYear:
        return Icons.history_edu_outlined;
    }
  }
}

// ── SUBJECT ───────────────────────────────────────────────────
class SubjectModel {
  final String id;
  final String name;
  final String category;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final int totalLessons;
  final int completedLessons;
  final bool isFree;
  final int coinCost;
  final bool isUnlocked;
  final List<String> applicablePosts; // [] means all posts

  const SubjectModel({
    required this.id,
    required this.name,
    required this.category,
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.totalLessons,
    required this.completedLessons,
    this.isFree = false,
    this.coinCost = 0,
    this.isUnlocked = false,
    this.applicablePosts = const [],
  });

  double get progress =>
      totalLessons == 0 ? 0 : completedLessons / totalLessons;

  SubjectModel copyWith({bool? isUnlocked}) => SubjectModel(
        id: id,
        name: name,
        category: category,
        icon: icon,
        color: color,
        bgColor: bgColor,
        totalLessons: totalLessons,
        completedLessons: completedLessons,
        isFree: isFree,
        coinCost: coinCost,
        isUnlocked: isUnlocked ?? this.isUnlocked,
        applicablePosts: applicablePosts,
      );

  // ── Default seed data ──────────────────────────────────────
  static List<SubjectModel> get defaults => [
        // FREE
        SubjectModel(
          id: 'gk',
          name: 'General Knowledge',
          category: 'General',
          icon: Icons.public_rounded,
          color: const Color(0xFF1E3EBF),
          bgColor: const Color(0xFFEEF1FB),
          totalLessons: 24,
          completedLessons: 16,
          isFree: true,
          isUnlocked: true,
          applicablePosts: [],
        ),
        SubjectModel(
          id: 'nepali',
          name: 'Nepali Language',
          category: 'General',
          icon: Icons.translate_rounded,
          color: const Color(0xFF059669),
          bgColor: const Color(0xFFECFDF5),
          totalLessons: 18,
          completedLessons: 7,
          isFree: true,
          isUnlocked: true,
          applicablePosts: [],
        ),
        SubjectModel(
          id: 'current_affairs',
          name: 'Current Affairs',
          category: 'General',
          icon: Icons.newspaper_rounded,
          color: const Color(0xFF0369A1),
          bgColor: const Color(0xFFE0F2FE),
          totalLessons: 12,
          completedLessons: 0,
          isFree: true,
          isUnlocked: true,
          applicablePosts: [],
        ),

        // LOCKED — General
        SubjectModel(
          id: 'constitution',
          name: 'Constitution of Nepal',
          category: 'General',
          icon: Icons.account_balance_rounded,
          color: const Color(0xFF7C3AED),
          bgColor: const Color(0xFFF5F3FF),
          totalLessons: 30,
          completedLessons: 0,
          coinCost: 200,
          applicablePosts: [],
        ),
        SubjectModel(
          id: 'maths',
          name: 'Mathematics',
          category: 'General',
          icon: Icons.calculate_rounded,
          color: const Color(0xFFD97706),
          bgColor: const Color(0xFFFFFBEB),
          totalLessons: 20,
          completedLessons: 0,
          coinCost: 150,
          applicablePosts: [],
        ),
        SubjectModel(
          id: 'reasoning',
          name: 'Logical Reasoning',
          category: 'General',
          icon: Icons.psychology_rounded,
          color: const Color(0xFFDB2777),
          bgColor: const Color(0xFFFDF2F8),
          totalLessons: 16,
          completedLessons: 0,
          coinCost: 180,
          applicablePosts: [],
        ),
        SubjectModel(
          id: 'english',
          name: 'English',
          category: 'General',
          icon: Icons.menu_book_rounded,
          color: const Color(0xFF0369A1),
          bgColor: const Color(0xFFF0F9FF),
          totalLessons: 14,
          completedLessons: 0,
          coinCost: 120,
          applicablePosts: [],
        ),

        // POST-SPECIFIC — Kharidar / Subba
        SubjectModel(
          id: 'admin_kharidar',
          name: 'General Administration',
          category: 'Post-Specific',
          icon: Icons.business_center_rounded,
          color: const Color(0xFF1E3EBF),
          bgColor: const Color(0xFFEEF1FB),
          totalLessons: 22,
          completedLessons: 0,
          coinCost: 250,
          applicablePosts: ['kharidar', 'subba', 'nayab_subba'],
        ),
        SubjectModel(
          id: 'accounting',
          name: 'Accounting & Finance',
          category: 'Post-Specific',
          icon: Icons.account_balance_wallet_rounded,
          color: const Color(0xFF059669),
          bgColor: const Color(0xFFECFDF5),
          totalLessons: 18,
          completedLessons: 0,
          coinCost: 250,
          applicablePosts: ['subba', 'officer'],
        ),
        SubjectModel(
          id: 'law',
          name: 'Law & Governance',
          category: 'Post-Specific',
          icon: Icons.gavel_rounded,
          color: const Color(0xFF7C3AED),
          bgColor: const Color(0xFFF5F3FF),
          totalLessons: 20,
          completedLessons: 0,
          coinCost: 300,
          applicablePosts: ['officer', 'inspector'],
        ),
      ];
}

// ── REWARD EARN METHOD ────────────────────────────────────────
class EarnMethod {
  final String title;
  final String reward;
  final IconData icon;
  final Color color;
  final Color bgColor;

  const EarnMethod({
    required this.title,
    required this.reward,
    required this.icon,
    required this.color,
    required this.bgColor,
  });

  static const List<EarnMethod> all = [
    EarnMethod(
      title: 'Daily Claim',
      reward: '+50 coins',
      icon: Icons.calendar_today_rounded,
      color: Color(0xFFD97706),
      bgColor: Color(0xFFFEF3C7),
    ),
    EarnMethod(
      title: 'Quiz Score',
      reward: '+10–100',
      icon: Icons.quiz_rounded,
      color: Color(0xFF1E3EBF),
      bgColor: Color(0xFFEEF1FB),
    ),
    EarnMethod(
      title: 'Watch Ad',
      reward: '+30 coins',
      icon: Icons.play_circle_outline_rounded,
      color: Color(0xFF059669),
      bgColor: Color(0xFFECFDF5),
    ),
    EarnMethod(
      title: 'Referral',
      reward: '+200 coins',
      icon: Icons.people_rounded,
      color: Color(0xFFDB2777),
      bgColor: Color(0xFFFDF2F8),
    ),
    EarnMethod(
      title: 'Streak Bonus',
      reward: '+75 at 7 days',
      icon: Icons.local_fire_department_rounded,
      color: Color(0xFF059669),
      bgColor: Color(0xFFECFDF5),
    ),
  ];
}
