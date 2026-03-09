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

  void login() async {

    setState(() {
      isLoading = true;
    });

    final token = await AuthService.login(
      email: emailController.text,
      password: passwordController.text,
    );

    setState(() {
      isLoading = false;
    });

    if (token != null) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login Success")),
      );

      Navigator.pushNamed(context, AppRoutes.home);

    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login Failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(title: const Text("Login")),

      body: Padding(

        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            CustomTextField(
              hint: "Email",
              controller: emailController,
            ),

            const SizedBox(height: 15),

            CustomTextField(
              hint: "Password",
              obscure: true,
              controller: passwordController,
            ),

            const SizedBox(height: 20),

            isLoading
                ? const CircularProgressIndicator()
                : CustomButton(
              text: "Login",
              onPressed: login,
            ),

          ],
        ),
      ),
    );
  }
}