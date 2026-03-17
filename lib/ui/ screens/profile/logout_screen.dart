import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // سطر مهم جداً للخروج الحقيقي

class LogoutScreen extends StatelessWidget {
  const LogoutScreen({super.key});

  // دالة الخروج المنفصلة عشان الكود يكون منظم
  Future<void> _signOut(BuildContext context) async {
    try {
      // 1. أمر الخروج من Firebase
      await FirebaseAuth.instance.signOut();

      // 2. الرجوع لصفحة اللوجين ومسح الـ History
      // تأكد أن الاسم في app_routes هو '/login'
      if (context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
      }
    } catch (e) {
      // لو حصل مشكلة اظهر رسالة خطأ
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("خطأ أثناء تسجيل الخروج: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تسجيل الخروج'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.logout_rounded,
              size: 120,
              color: Colors.redAccent, // غيرت اللون لأحمر خفيف عشان يعبر عن التنبيه
            ),
            const SizedBox(height: 30),
            const Text(
              'هل أنت متأكد؟',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            const Text(
              'سيتم إغلاق الجلسة الحالية، وستحتاج لإدخال بياناتك مرة أخرى للدخول.',
              style: TextStyle(fontSize: 16, color: Colors.blueGrey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),

            // --- زرار تأكيد الخروج ---
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => _signOut(context), // استدعاء دالة الخروج
              child: const Text(
                'تأكيد تسجيل الخروج',
                style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 15),

            // --- زرار الإلغاء ---
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // يرجعك لصفحة الـ Profile أو الـ Home
              },
              child: const Text(
                'إلغاء',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}