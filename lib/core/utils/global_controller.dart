import 'dart:convert';
import 'package:get/get.dart';
import 'package:lokse/core/storage/secure_storage.dart';
import 'package:lokse/core/utils/dio_client.dart';
import 'package:lokse/core/constants/app_constants.dart';

class GlobalController extends GetxController {
  static GlobalController get instance => Get.find();

  var isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkLogin();
  }

  /// Check if user has a valid access token
  Future<void> checkLogin() async {
    final accessToken = await TokenStorage.getAccessToken();
    final refreshToken = await TokenStorage.getRefreshToken();

    if (accessToken == null || accessToken.isEmpty) {
      isLoggedIn.value = false;
      return;
    }

    try {
      final parts = accessToken.split('.');
      if (parts.length != 3) throw Exception('Invalid token');

      final payload = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );

      final exp = payload['exp'];
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      if (exp != null && now < exp) {
        isLoggedIn.value = true;
      } else if (refreshToken != null) {
        final refreshed = await DioClient.refreshToken();
        isLoggedIn.value = refreshed;
      } else {
        isLoggedIn.value = false;
        await TokenStorage.clear();
      }
    } catch (e, s) {
      logger.e('Token validation failed', error: e, stackTrace: s);
      isLoggedIn.value = false;
      await TokenStorage.clear();
    }
  }

  void setLoggedIn(bool value) => isLoggedIn.value = value;
}
