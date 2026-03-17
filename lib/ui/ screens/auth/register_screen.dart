// import 'package:flutter/material.dart';
//
// class RegisterScreen extends StatelessWidget {
//   const RegisterScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//
//     TextEditingController name = TextEditingController();
//     TextEditingController email = TextEditingController();
//     TextEditingController password = TextEditingController();
//
//     return Scaffold(
//       appBar: AppBar(title: const Text("Register")),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//
//             TextField(
//               controller: name,
//               decoration: const InputDecoration(labelText: "Name"),
//             ),
//
//             TextField(
//               controller: email,
//               decoration: const InputDecoration(labelText: "Email"),
//             ),
//
//             TextField(
//               controller: password,
//               decoration: const InputDecoration(labelText: "Password"),
//               obscureText: true,
//             ),
//
//             const SizedBox(height: 20),
//
//             ElevatedButton(
//               onPressed: () {},
//               child: const Text("Register"),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:yalla_tech/data/services/auth_service.dart';
import '../../../routes/app_routes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // 1. التعريف بره الـ build عشان ميتكررش
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
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      _showError("Please fill all fields");
      return;
    }

    setState(() => isLoading = true);

    // 2. ربط الـ AuthService
    final token = await AuthService.register(
      email: emailController.text.trim(),
      password: passwordController.text,
      name: nameController.text.trim(), // السطر ده هو اللي ناقصك!
    );

    if (!mounted) return;
    setState(() => isLoading = false);

    if (token != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account Created Successfully!")),
      );
      // نروح للهوم ونقفل كل اللي فات
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
    } else {
      _showError("Registration Failed. Try again.");
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Account")),
      body: SingleChildScrollView( // عشان الكيبورد متعملش Overflow
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Full Name", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder()),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: "Password", border: OutlineInputBorder()),
              obscureText: true,
            ),
            const SizedBox(height: 25),

            isLoading
                ? const CircularProgressIndicator()
                : SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: handleRegister,
                child: const Text("Register"),
              ),
            ),

            TextButton(
              onPressed: () => Navigator.pop(context), // يرجعه للوج ان
              child: const Text("Already have an account? Login"),
            )
          ],
        ),
      ),
    );
  }
}