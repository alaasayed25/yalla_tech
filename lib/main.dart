import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:yalla_tech/routes/app_routes.dart';
import 'firebase_options.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. تحميل ملف الـ .env
  await dotenv.load(fileName: ".env");

  // 2. تجربة الاتصال البسيطة (عشان نشوف المفتاح شغال ولا لا)
  final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
  if (apiKey.isNotEmpty) {
    try {
      // بنجرب نبعت رسالة تجريبية صغيرة جداً أول ما التطبيق يفتح
      final model = GenerativeModel(
        model: 'gemini-pro', // استخدم gemini-pro فقط بدون أي إضافات
        apiKey: apiKey,
      );      final response = await model.generateContent([Content.text('say hi')]);
      print("-----------------------------------------");
      print("✅ مبروك! الـ AI شغال وبيرد: ${response.text}");
      print("-----------------------------------------");
    } catch (e) {
      print("-----------------------------------------");
      print("❌ لسه فيه مشكلة في المفتاح أو الموديل: $e");
      print("-----------------------------------------");
    }
  }

  // 3. تهيئة الفايربيز
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const YallaTech());
}

class YallaTech extends StatelessWidget {
  const YallaTech({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      title: "Yalla Tech",
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}