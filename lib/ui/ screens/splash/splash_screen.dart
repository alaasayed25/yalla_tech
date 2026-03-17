// import 'dart:async';
// import 'package:flutter/material.dart';
// import '../auth/login_screen.dart';
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//
//   @override
//   void initState() {
//     super.initState();
//
//     Timer(const Duration(seconds: 3), () {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => const LoginScreen(),
//         ),
//       );
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return const Scaffold(
//       body: Center(
//         child: Text(
//           "Yalla Tech 🚀",
//           style: TextStyle(
//             fontSize: 30,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

    if (mounted) {
      if (user != null) {
        // لو مسجل (زي ze@gmail.com) -> ادخل على الهوم
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      } else {
        // لو جديد -> روح لشاشة الزرارين (Login / Signup)
        Navigator.pushReplacementNamed(context, AppRoutes.authGate);
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