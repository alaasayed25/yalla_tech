import 'package:flutter/material.dart';
import '../auth/login_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            const Icon(
              Icons.psychology,
              size: 120,
              color: Colors.deepPurple,
            ),

            const SizedBox(height: 20),

            const Text(
              "Welcome to Yalla Tech",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(

              onPressed: (){

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context)=>const LoginScreen(),
                  ),
                );

              },

              child: const Text("Start"),

            )

          ],
        ),
      ),
    );
  }
}