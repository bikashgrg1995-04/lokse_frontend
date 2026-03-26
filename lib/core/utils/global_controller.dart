import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lokse/core/constants/logger.dart';
import 'package:lokse/core/storage/secure_storage.dart';
import 'package:lokse/core/storage/storage_keys.dart';
import 'package:lokse/core/utils/dio_client.dart';
import 'package:lokse/core/utils/status_message.dart';
import 'package:lokse/routes/app_routes.dart';

class GlobalController extends GetxController {
  static GlobalController get instance => Get.find<GlobalController>();

  final _box = GetStorage();

  // ── Auth ──────────────────────────────────────────────
  final isLoggedIn = false.obs;

  // ── Game state ────────────────────────────────────────
  final totalXp = 0.obs;
  final totalCoins = 1240.obs;
  final currentStreak = 0.obs;
  final accuracy = 0.0.obs;

  // ── Daily reward ──────────────────────────────────────
  final canClaimDaily = false.obs;

  // ── Cached user info ──────────────────────────────────
  final userName = ''.obs;
  final userEmail = ''.obs;

  // ── Getters ───────────────────────────────────────────
  String get accuracyPct => '${(accuracy.value * 100).toInt()}%';
  String get streakLabel => '${currentStreak.value} day streak 🔥';
  String get xpTier {
    final xp = totalXp.value;
    if (xp < 500) return 'Beginner';
    if (xp < 2000) return 'Learner';
    if (xp < 5000) return 'Practitioner';
    if (xp < 10000) return 'Expert';
    return 'Master';
  }

  @override
  void onInit() {
    super.onInit();
    _loadFromStorage();
    _checkDailyClaim();
    // ⚠️  Do NOT call checkLogin() here.
    // SplashController awaits checkLogin() before navigating,
    // so we avoid a duplicate async call and a race condition.
  }

  // ══════════════════════════════════════════════════════
  // AUTH
  // ══════════════════════════════════════════════════════

  /// Returns true if the user ends up authenticated.
  /// Called by SplashController (awaited) before navigation.
  Future<bool> checkLogin() async {
    final access = await TokenStorage.getAccessToken();
    final refresh = await TokenStorage.getRefreshToken();

    if (access == null || access.isEmpty) {
      isLoggedIn.value = false;
      return false;
    }

    try {
      final parts = access.split('.');
      if (parts.length != 3) throw Exception('malformed token');

      final payload = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );
      final exp = payload['exp'] as int?;
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      if (exp != null && now < exp) {
        // Access token still valid
        isLoggedIn.value = true;
        return true;
      } else if (refresh != null && refresh.isNotEmpty) {
        // Try to refresh
        final ok = await DioClient.refreshToken();
        isLoggedIn.value = ok;
        if (!ok) await TokenStorage.clear();
        return ok;
      } else {
        await TokenStorage.clear();
        isLoggedIn.value = false;
        return false;
      }
    } catch (e) {
      appLog.e('checkLogin error: $e');
      await TokenStorage.clear();
      isLoggedIn.value = false;
      return false;
    }
  }

  void setLoggedIn(bool v) {
    isLoggedIn.value = v;
    if (!v) _clearUserData();
  }

  Future<void> logout() async {
    await _forceLogout(navigate: true);
  }

  Future<void> _forceLogout({required bool navigate}) async {
    await TokenStorage.clear();
    _clearUserData();
    isLoggedIn.value = false;
    if (navigate) {
      // Go to navigation shell → profile tab shows LoginPage
      Get.offAllNamed(AppRoutes.navigation, arguments: 3);
    }
  }

  // ══════════════════════════════════════════════════════
  // XP
  // ══════════════════════════════════════════════════════

  void addXp(int amount) {
    if (amount <= 0) return;
    totalXp.value += amount;
    _saveToStorage();
    appLog.d('XP +$amount → ${totalXp.value}');
  }

  // ══════════════════════════════════════════════════════
  // COINS
  // ══════════════════════════════════════════════════════

  bool spendCoins(int amount) {
    if (totalCoins.value < amount) return false;
    totalCoins.value -= amount;
    _saveToStorage();
    appLog.d('Coins -$amount → ${totalCoins.value}');
    return true;
  }

  void addCoins(int amount) {
    if (amount <= 0) return;
    totalCoins.value += amount;
    _saveToStorage();
    appLog.d('Coins +$amount → ${totalCoins.value}');
  }

  // ══════════════════════════════════════════════════════
  // QUIZ REWARD
  // ══════════════════════════════════════════════════════

  void onQuizComplete({
    required int xp,
    required int correct,
    required int total,
  }) {
    addXp(xp);
    final coinBonus = (correct * 2).clamp(0, 50);
    addCoins(coinBonus);
    if (total > 0) {
      accuracy.value = ((accuracy.value + correct / total) / 2).clamp(0.0, 1.0);
    }
  }

  // ══════════════════════════════════════════════════════
  // DAILY CLAIM
  // ══════════════════════════════════════════════════════

  void _checkDailyClaim() {
    final last = _box.read<String>(StorageKeys.lastDailyClaim);
    if (last == null) {
      canClaimDaily.value = true;
      return;
    }
    final lastDt = DateTime.tryParse(last);
    canClaimDaily.value =
        lastDt == null || DateTime.now().difference(lastDt).inDays >= 1;
  }

  void claimDailyReward() {
    if (!canClaimDaily.value) {
      StatusMessage.info('Already claimed today!');
      return;
    }
    addCoins(50);
    _updateStreak();
    _box.write(StorageKeys.lastDailyClaim, DateTime.now().toIso8601String());
    canClaimDaily.value = false;
    StatusMessage.success('Daily reward claimed! +50 coins');
  }

  void _updateStreak() {
    final last = _box.read<String>(StorageKeys.lastLoginDate);
    final now = DateTime.now();
    if (last != null) {
      final lastDt = DateTime.tryParse(last);
      if (lastDt != null) {
        final diff = now.difference(lastDt).inDays;
        currentStreak.value = diff == 1 ? currentStreak.value + 1 : 1;
      }
    } else {
      currentStreak.value = 1;
    }
    _box.write(StorageKeys.lastLoginDate, now.toIso8601String());
    _saveToStorage();

    if (currentStreak.value % 7 == 0) {
      addCoins(75);
      StatusMessage.success('7-day streak! +75 bonus coins 🔥');
    }
  }

  // ══════════════════════════════════════════════════════
  // STORAGE
  // ══════════════════════════════════════════════════════

  void _loadFromStorage() {
    totalXp.value = _box.read<int>(StorageKeys.totalXp) ?? 0;
    totalCoins.value = _box.read<int>(StorageKeys.totalCoins) ?? 1240;
    currentStreak.value = _box.read<int>(StorageKeys.currentStreak) ?? 0;
  }

  void _saveToStorage() {
    _box.write(StorageKeys.totalXp, totalXp.value);
    _box.write(StorageKeys.totalCoins, totalCoins.value);
    _box.write(StorageKeys.currentStreak, currentStreak.value);
  }

  void _clearUserData() {
    totalXp.value = totalCoins.value = currentStreak.value = 0;
    userName.value = userEmail.value = '';
    _saveToStorage();
  }
}
