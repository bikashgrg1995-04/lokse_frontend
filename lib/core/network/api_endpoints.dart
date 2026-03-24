/// 🌐 ApiEndpoints — every backend URL in one place.
/// Change baseUrl here only when switching environments.
abstract class ApiEndpoints {
  // ── Base ──────────────────────────────────────────────
  // TODO: use --dart-define or .env for prod vs dev
  static const String baseUrl = 'http://192.168.1.99:8000/api';

  // ── Auth ──────────────────────────────────────────────
  static const String register = '/accounts/register/';
  static const String login = '/accounts/login/';
  static const String refresh = '/accounts/refresh/';
  static const String profile = '/accounts/profile/';
  static const String changePassword = '/accounts/change-password/';

  // ── Quiz ──────────────────────────────────────────────
  static const String questions = '/quiz/questions/';
  static const String submitResult = '/quiz/submit/';
  static const String leaderboard = '/quiz/leaderboard/';

  // ── Learn ─────────────────────────────────────────────
  static const String subjects = '/learn/subjects/';
  static const String lessons = '/learn/lessons/';

  // ── Rewards ───────────────────────────────────────────
  static const String dailyClaim = '/rewards/daily-claim/';
  static const String userCoins = '/rewards/coins/';
  static const String userXp = '/rewards/xp/';

  // ── Announcements ─────────────────────────────────────
  static const String announcements = '/announcements/';

  // ── Helper ────────────────────────────────────────────
  static String full(String endpoint) => '$baseUrl$endpoint';
}
