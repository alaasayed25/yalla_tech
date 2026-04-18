
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // سيرفر مخصص للتعليم ومبيعملش بلوك Cloudflare
  static const String baseUrl = "https://dummyjson.com";

  static Future<Map<String, dynamic>> postData({
    required String endpoint,
    required Map<String, dynamic> body,
  }) async {
    final url = Uri.parse("$baseUrl/$endpoint");

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          // بنعرف السيرفر إننا موبايل حقيقي
          "Accept": "application/json",
        },
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 15));

      print("Status Code: ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        print("Error detail: ${response.body}");
        return {};
      }
    } catch (e) {
      print("Network error: $e");
      return {};
    }
  }
}