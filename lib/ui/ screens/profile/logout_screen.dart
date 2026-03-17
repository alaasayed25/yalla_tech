import 'package:flutter/material.dart';

// Import local screens to reference them
import '../home/home_screen.dart'; // Adjust if path is different
// import '../auth/login_screen.dart'; // We'll use routes, but this is for reference

class LogoutScreen extends StatelessWidget {
  const LogoutScreen({super.key});

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
              color: Colors.grey,
            ),
            const SizedBox(height: 30),
            const Text(
              'هل أنت متأكد؟',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            const Text(
              'تنبيه: سيؤدي تسجيل الخروج إلى حذف جميع البيانات المحلية غير المحفوظة.',
              style: TextStyle(fontSize: 16, color: Colors.blueGrey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),

            // --- زرار تأكيد الخروج (أحمر) ---
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                // TODO: 1. أضف هنا كود الـ Logic لمسح الـ Token (SharedPrefs, Firebase, etc.)

                // 2. النقل لصفحة اللوجين ومسح الـ Back Stack
                // بنستخدم pushNamedAndRemoveUntil عشان نضمن إنه ما يرجعش للصفحة دي
                Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
              },
              child: const Text(
                'تسجيل الخروج',
                style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 15),

            // --- زرار الإلغاء (رمادي) ---
            TextButton(
              onPressed: () {
                // بيرجع للصفحة اللي قبلها (مثلاً HomeScreen)
                Navigator.of(context).pop();
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