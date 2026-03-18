import 'package:flutter/material.dart';
import 'package:yalla_tech/data/services/auth_service.dart';
import 'package:yalla_tech/widgets/custom_button.dart';
import 'package:yalla_tech/widgets/custom_textfield.dart';
import '../../../routes/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() async {
    if (emailController.text.trim().isEmpty || passwordController.text.isEmpty) {
      _showSnackBar("Please enter email and password", color: Colors.orange);
      return;
    }

    setState(() => isLoading = true);

    try {
      final user = await AuthService.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (!mounted) return;
      setState(() => isLoading = false);

      if (user != null) {
        _showSnackBar("Welcome Back! 🚀", color: Colors.green);
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
      } else {
        _showSnackBar("Login Failed: Wrong email or password", color: Colors.red);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      _showSnackBar("Error: ${e.toString()}", color: Colors.red);
    }
  }

  void _showSnackBar(String message, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: color ?? Colors.blueAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Dark Mode Theme
      body: SafeArea(
        child: Center( // عشان يخلي المحتوى في نص الشاشة لو الشاشة كبيرة
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.bolt_rounded, size: 80, color: Colors.blueAccent), // لوجو بسيط
                const SizedBox(height: 20),
                const Text(
                  "Yalla Tech",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Login to access your AI tutor",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 50),

                // حقل الإيميل
                CustomTextField(
                  hint: "Email Address",
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 20),

                // حقل الباسورد
                CustomTextField(
                  hint: "Password",
                  obscure: true,
                  controller: passwordController,
                ),

                const SizedBox(height: 10),

                // زرار نسيت كلمة السر
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Navigator.pushNamed(context, AppRoutes.forgotPassword);
                    },
                    child: const Text("Forgot Password?", style: TextStyle(color: Colors.blueAccent)),
                  ),
                ),

                const SizedBox(height: 20),

                // زرار الدخول
                if (isLoading)
                  const CircularProgressIndicator(color: Colors.blueAccent)
                else
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: CustomButton(
                      text: "Login",
                      onPressed: login,
                    ),
                  ),

                const SizedBox(height: 30),

                // ربط شاشة التسجيل
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?", style: TextStyle(color: Colors.white70)),
                    TextButton(
                      onPressed: () {
                        // الآن الزرار شغال وبيروح للريجيستر 🚀
                        Navigator.pushNamed(context, AppRoutes.register);
                      },
                      child: const Text(
                          "Register Now",
                          style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}