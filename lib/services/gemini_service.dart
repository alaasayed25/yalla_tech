import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GeminiException implements Exception {
  final String message;
  GeminiException(this.message);
  @override
  String toString() => message;
}

class GeminiService {
  static const String modelName = 'gemini-2.5-flash';
  static const Duration _timeout = Duration(seconds: 30);
  static const int _maxRetries = 2;

  static String get _apiKey {
    final key = dotenv.env['GEMINI_API_KEY'] ?? '';
    if (key.isEmpty) {
      throw GeminiException('GEMINI_API_KEY is not set in .env');
    }
    return key;
  }

  static Future<String> generate(
    String prompt, {
    String? cacheKey,
    Duration cacheTtl = const Duration(hours: 24),
    int maxInputChars = 12000,
  }) async {
    if (prompt.trim().isEmpty) {
      throw GeminiException('Prompt is empty.');
    }
    if (prompt.length > maxInputChars) {
      throw GeminiException(
        'Prompt exceeds max length of $maxInputChars characters.',
      );
    }

    if (cacheKey != null) {
      final cached = await _readCache(cacheKey);
      if (cached != null) return cached;
    }

    final model = GenerativeModel(model: modelName, apiKey: _apiKey);
    final content = [Content.text(prompt)];

    Object? lastError;
    for (var attempt = 0; attempt <= _maxRetries; attempt++) {
      try {
        final response =
            await model.generateContent(content).timeout(_timeout);
        final text = response.text;
        if (text == null || text.isEmpty) {
          throw GeminiException('Empty response from Gemini.');
        }
        if (cacheKey != null) {
          await _writeCache(cacheKey, text, cacheTtl);
        }
        return text;
      } on TimeoutException catch (e) {
        lastError = e;
      } on GenerativeAIException catch (e) {
        final msg = e.message.toLowerCase();
        final isTransient = msg.contains('500') ||
            msg.contains('502') ||
            msg.contains('503') ||
            msg.contains('504') ||
            msg.contains('unavailable');
        if (!isTransient) rethrow;
        lastError = e;
      }
      if (attempt < _maxRetries) {
        await Future.delayed(Duration(seconds: 2 * (attempt + 1)));
      }
    }
    throw GeminiException('Gemini request failed: $lastError');
  }

  static Future<void> clearCache({String? cacheKey}) async {
    final prefs = await SharedPreferences.getInstance();
    if (cacheKey != null) {
      await prefs.remove(_prefsKey(cacheKey));
      return;
    }
    final keys = prefs.getKeys().where((k) => k.startsWith(_prefsPrefix));
    for (final k in keys) {
      await prefs.remove(k);
    }
  }

  static const String _prefsPrefix = 'gemini_cache_';
  static String _prefsKey(String cacheKey) => '$_prefsPrefix$cacheKey';

  static Future<String?> _readCache(String cacheKey) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey(cacheKey));
    if (raw == null) return null;
    try {
      final map = json.decode(raw) as Map<String, dynamic>;
      final expiresAt = map['expiresAt'] as int?;
      if (expiresAt == null ||
          expiresAt < DateTime.now().millisecondsSinceEpoch) {
        await prefs.remove(_prefsKey(cacheKey));
        return null;
      }
      return map['value'] as String?;
    } catch (_) {
      await prefs.remove(_prefsKey(cacheKey));
      return null;
    }
  }

  static Future<void> _writeCache(
    String cacheKey,
    String value,
    Duration ttl,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final payload = json.encode({
      'value': value,
      'expiresAt': DateTime.now().add(ttl).millisecondsSinceEpoch,
    });
    await prefs.setString(_prefsKey(cacheKey), payload);
  }
}
