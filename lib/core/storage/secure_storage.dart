import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static final _storage = const FlutterSecureStorage();

  static const _accessKey = 'ACCESS_TOKEN';
  static const _refreshKey = 'REFRESH_TOKEN';

  // Save tokens
  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: _accessKey, value: accessToken);
    await _storage.write(key: _refreshKey, value: refreshToken);
  }

  // Get access token
  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessKey);
  }

  // Get refresh token
  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshKey);
  }

  // Clear tokens
  static Future<void> clear() async {
    await _storage.delete(key: _accessKey);
    await _storage.delete(key: _refreshKey);
  }
}
