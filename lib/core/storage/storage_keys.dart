/// 🗝 StorageKeys — every GetStorage key as a typed constant.
/// Never use raw strings like 'isFirstTime' directly in code.
abstract class StorageKeys {
  // ── Onboarding ────────────────────────────────────────
  static const String isFirstTime = 'isFirstTime';

  // ── Theme ─────────────────────────────────────────────
  static const String isDarkMode = 'isDarkMode';

  // ── User progress (local cache) ───────────────────────
  static const String totalXp = 'totalXp';
  static const String totalCoins = 'totalCoins';
  static const String currentStreak = 'currentStreak';
  static const String lastLoginDate = 'lastLoginDate';
  static const String quizLevels = 'quizLevels';

  // ── Daily reward ──────────────────────────────────────
  static const String lastDailyClaim = 'lastDailyClaim';
}
