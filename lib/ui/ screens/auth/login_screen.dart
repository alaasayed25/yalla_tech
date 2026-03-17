// import 'package:flutter/material.dart';
// import 'package:yalla_tech/data/services/auth_service.dart';
// import 'package:yalla_tech/widgets/custom_button.dart';
// import 'package:yalla_tech/widgets/custom_textfield.dart';
// import '../../../routes/app_routes.dart';
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//
//   bool isLoading = false;
//
//   void login() async {
//
//     setState(() {
//       isLoading = true;
//     });
//
//     final token = await AuthService.login(
//       email: emailController.text,
//       password: passwordController.text,
//     );
//
//     setState(() {
//       isLoading = false;
//     });
//
//     if (token != null) {
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Login Success")),
//       );
//
//       Navigator.pushNamed(context, AppRoutes.home);
//
//     } else {
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Login Failed")),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//
//       appBar: AppBar(title: const Text("Login")),
//
//       body: Padding(
//
//         padding: const EdgeInsets.all(20),
//
//         child: Column(
//
//           children: [
//
//             CustomTextField(
//               hint: "Email",
//               controller: emailController,
//             ),
//
//             const SizedBox(height: 15),
//
//             CustomTextField(
//               hint: "Password",
//               obscure: true,
//               controller: passwordController,
//             ),
//
//             const SizedBox(height: 20),
//
//             isLoading
//                 ? const CircularProgressIndicator()
//                 : CustomButton(
//               text: "Login",
//               onPressed: login,
//             ),
//
//           ],
//         ),
//       ),
//     );
//   }
// }



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
  // 1. استخدام final مع الـ Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  // 2. تنظيف الذاكرة (Memory Management)
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() async {
    // التحقق من البيانات قبل الإرسال (Validation بسيط)
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      _showSnackBar("Please enter email and password");
      return;
    }

    setState(() => isLoading = true);

    try {
      final token = await AuthService.login(
        email: emailController.text.trim(), // trim عشان تشيل المسافات الزيادة
        password: passwordController.text,
      );

      // 3. التأكد إن الـ Widget لسه موجودة قبل استخدام الـ Context
      if (!mounted) return;

      setState(() => isLoading = false);

      if (token != null) {
        _showSnackBar("Login Success", color: Colors.green);

        // 4. استخدام pushNamedAndRemoveUntil عشان ميرجعش لصفحة اللوج ان تاني
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.home,
              (route) => false,
        );
      } else {
        _showSnackBar("Login Failed: Check your credentials");
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      _showSnackBar("An error occurred: $e");
    }
  }

  // Helper method للـ SnackBar عشان الكود يكون أنظف
  void _showSnackBar(String message, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating, // شكل أشيك
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,
      ),
      // 5. استخدام SingleChildScrollView عشان الكيبورد لما تفتح ميعملش Error
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50), // مسافة من فوق

            CustomTextField(
              hint: "Email",
              controller: emailController,
              keyboardType: TextInputType.emailAddress, // تحديد نوع الكيبورد
            ),

            const SizedBox(height: 15),

            CustomTextField(
              hint: "Password",
              obscure: true,
              controller: passwordController,
            ),

            const SizedBox(height: 30),

            if (isLoading)
              const CircularProgressIndicator()
            else
              SizedBox(
                width: double.infinity, // يخلي الزرار بعرض الشاشة
                child: CustomButton(
                  text: "Login",
                  onPressed: login,
                ),
              ),
          ],
        ),
      ),
    );
  }
}