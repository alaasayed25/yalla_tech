import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // <-- ضفنا المكتبة هنا
import '../../../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  void _navigateToNext() async {
    // 1. هنستنى ثانيتين عشان اليوزر يلحق يشوف اللوجو
    await Future.delayed(const Duration(seconds: 2));

    // 2. هنشوف هل فيه مستخدم مسجل دخول (Firebase)؟
    User? user = FirebaseAuth.instance.currentUser;

    // 3. بنسأل الذاكرة: هل اليوزر ده شاف الانترو قبل كدا؟
    final prefs = await SharedPreferences.getInstance();
    final hasSeenIntro = prefs.getBool('hasSeenIntro') ?? false;

    if (mounted) {
      if (user != null) {
        // لو مسجل دخول جاهز -> ادخل على الهوم مباشرة
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      } else {
        // لو مش مسجل، هنشوف بقى هو شاف الانترو ولا لأ
        if (hasSeenIntro) {
          // لو شافها قبل كده -> روح لشاشة الزرارين (Login / Signup)
          Navigator.pushReplacementNamed(context, AppRoutes.authGate);
        } else {
          // لو أول مرة يفتح التطبيق خالص -> وديه لشاشة الانترو
          Navigator.pushReplacementNamed(context, AppRoutes.intro);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF121212),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Yalla Tech 🚀",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 30),
            CircularProgressIndicator(color: Colors.blue),
          ],
        ),
      ),
    );
  }
}