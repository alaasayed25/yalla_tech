import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {

  static const String baseUrl = "https://reqres.in/api";

  /// POST Request
  static Future<Map<String, dynamic>> postData({
    required String endpoint,
    required Map<String, dynamic> body,
  }) async {

    final url = Uri.parse("$baseUrl/$endpoint");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json"
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed request");
    }
  }

}