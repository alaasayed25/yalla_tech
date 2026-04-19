import 'package:flutter/material.dart';
import 'package:yalla_tech/routes/app_routes.dart'; // المسار المضمون لاسم مشروعك
class AuthGateScreen extends StatelessWidget {
  const AuthGateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.rocket_launch, size: 80, color: Colors.blue), // أيقونة تعبر عن يالا تيك
            const SizedBox(height: 20),
            const Text(
              "Yalla Tech",
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "طريقك لاحتراف البرمجة يبدأ من هنا",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 60),

            // زرار إنشاء حساب
            SPlatformButton(
              text: "إنشاء حساب جديد",
              onTap: () => Navigator.pushNamed(context, AppRoutes.register),
              isSolid: true,
            ),

            const SizedBox(height: 20),

            // زرار تسجيل دخول
            SPlatformButton(
              text: "تسجيل دخول",
              onTap: () => Navigator.pushNamed(context, AppRoutes.login),
              isSolid: false,
            ),
          ],
        ),
      ),
    );
  }
}

// Widget بسيط للزراير عشان الكود يبقى نضيف
class SPlatformButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isSolid;

  const SPlatformButton({super.key, required this.text, required this.onTap, required this.isSolid});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: isSolid
          ? ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        onPressed: onTap,
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 18)),
      )
          : OutlinedButton(
        style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.blue),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        onPressed: onTap,
        child: Text(text, style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}