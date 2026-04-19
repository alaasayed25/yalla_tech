import 'package:flutter/material.dart';
import 'package:yalla_tech/data/services/auth_service.dart';
import 'package:yalla_tech/widgets/custom_button.dart';
import 'package:yalla_tech/widgets/custom_textfield.dart';
import '../../../routes/app_routes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void handleRegister() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty ||
        nameController.text.trim().isEmpty) {
      _showSnackBar("Please fill all fields", color: Colors.orange);
      return;
    }

    setState(() => isLoading = true);

    try {
      final user = await AuthService.register(
        email: emailController.text.trim(),
        password: passwordController.text,
        name: nameController.text.trim(),
      );

      if (!mounted) return;
      setState(() => isLoading = false);

      if (user != null) {
        _showSnackBar("Account Created Successfully! 🎉", color: Colors.green);
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
      } else {
        _showSnackBar("Registration Failed. Try again.", color: Colors.red);
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
        content: Text(message),
        backgroundColor: color ?? Colors.blueAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // توحيد اللون مع الـ Login
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              const Icon(Icons.person_add_rounded, size: 80, color: Colors.blueAccent),
              const SizedBox(height: 20),
              const Text(
                "Create Account",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const Text(
                "Join Yalla Tech community today",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),

              // الاسم
              CustomTextField(
                hint: "Full Name",
                controller: nameController,
              ),
              const SizedBox(height: 15),

              // الإيميل
              CustomTextField(
                hint: "Email",
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 15),

              // الباسورد
              CustomTextField(
                hint: "Password",
                controller: passwordController,
                obscure: true,
              ),
              const SizedBox(height: 30),

              if (isLoading)
                const CircularProgressIndicator(color: Colors.blueAccent)
              else
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: CustomButton(
                    text: "Register",
                    onPressed: handleRegister,
                  ),
                ),

              const SizedBox(height: 20),

              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Already have an account? Login",
                  style: TextStyle(color: Colors.blueAccent),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}