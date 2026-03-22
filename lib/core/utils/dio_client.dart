import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:lokse/core/storage/secure_storage.dart';
import 'package:lokse/core/utils/api_config.dart';
import 'package:lokse/core/constants/app_constants.dart';

class DioClient {
  static late dio.Dio client;

  static bool _isRefreshing = false;

  /// Initialize Dio client
  static void init() {
    client = dio.Dio(
      dio.BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    client.interceptors.add(
      dio.InterceptorsWrapper(
        onRequest: _onRequest,
        onResponse: _onResponse,
        onError: _onError,
      ),
    );
  }

  // ================= REQUEST =================
  static Future<void> _onRequest(
    dio.RequestOptions options,
    dio.RequestInterceptorHandler handler,
  ) async {
    final noAuth = options.extra['noAuth'] == true;

    if (!noAuth) {
      final token = await TokenStorage.getAccessToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    logger.i(
      '[REQUEST] ${options.method} ${options.uri}\nDATA: ${options.data}',
    );
    handler.next(options);
  }

  // ================= RESPONSE =================
  static void _onResponse(
    dio.Response response,
    dio.ResponseInterceptorHandler handler,
  ) {
    logger.i(
      '[RESPONSE] ${response.statusCode} ${response.requestOptions.uri}\nDATA: ${response.data}',
    );
    handler.next(response);
  }

  // ================= ERROR =================
  static Future<void> _onError(
    dio.DioException error,
    dio.ErrorInterceptorHandler handler,
  ) async {
    logger.e(
      '[ERROR] ${error.response?.statusCode} ${error.requestOptions.uri}',
      error: error.response?.data,
    );

    final is401 = error.response?.statusCode == 401;
    final noAuth = error.requestOptions.extra['noAuth'] == true;

    if (is401 && !noAuth) {
      final refreshed = await _refreshToken();
      if (refreshed) {
        final newToken = await TokenStorage.getAccessToken();
        error.requestOptions.headers['Authorization'] = 'Bearer $newToken';

        // Retry original request
        final retryResponse = await client.fetch(error.requestOptions);
        return handler.resolve(retryResponse);
      } else {
        await _forceLogout();
        return;
      }
    }

    handler.next(error);
  }

  // ================= REFRESH TOKEN =================
  static refreshToken() async {
    await _refreshToken();
  }

  static Future<bool> _refreshToken() async {
    if (_isRefreshing) return false;
    _isRefreshing = true;

    try {
      final refreshToken = await TokenStorage.getRefreshToken();
      if (refreshToken == null) return false;

      final response = await dio.Dio().post(
        '${ApiConfig.baseUrl}${ApiConfig.refresh}',
        data: {'refresh': refreshToken},
        options: dio.Options(
          extra: {'noAuth': true},
        ),
      );

      final newAccess = response.data['access'];

      await TokenStorage.saveTokens(
        accessToken: newAccess,
        refreshToken: refreshToken, // SimpleJWT reuse
      );

      logger.i('JWT refreshed successfully');
      return true;
    } catch (e, s) {
      logger.e('JWT refresh failed', error: e, stackTrace: s);
      return false;
    } finally {
      _isRefreshing = false;
    }
  }

  // ================= LOGOUT =================
  static Future<void> _forceLogout() async {
    await TokenStorage.clear();
    Get.offAllNamed('/login');
  }
}
