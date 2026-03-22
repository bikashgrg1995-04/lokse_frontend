class ApiConfig {
  static const String baseUrl = "http://192.168.1.99:8000/api";

  // AUTH
  static const String register = "$baseUrl/accounts/register/";
  static const String login = "$baseUrl/accounts/login/";
  static const String refresh =
      "$baseUrl/accounts/refresh/"; // Refresh token endpoint
  static const String profile = "$baseUrl/accounts/profile/";
}
