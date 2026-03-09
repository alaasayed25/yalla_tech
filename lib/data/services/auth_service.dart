import '../services/api_service.dart';

class AuthService {

  /// Login
  static Future<String?> login({
    required String email,
    required String password,
  }) async {

    try {

      final response = await ApiService.postData(
        endpoint: "login",
        body: {
          "email": email,
          "password": password,
        },
      );

      return response["token"];

    } catch (e) {
      return null;
    }
  }

  /// Register
  static Future<String?> register({
    required String email,
    required String password,
  }) async {

    try {

      final response = await ApiService.postData(
        endpoint: "register",
        body: {
          "email": email,
          "password": password,
        },
      );

      return response["token"];

    } catch (e) {
      return null;
    }
  }
}