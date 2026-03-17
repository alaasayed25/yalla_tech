import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: IntroductionScreen(
        globalBackgroundColor: const Color(0xFFF8FAFF),

        pages: [
          PageViewModel(
            title: "Study Smarter with AI 🧠",
            body: "Upload your lessons and let our AI summarize and explain complex topics simply.",
            image: const Center(child: Icon(Icons.auto_stories, size: 100, color: Color(0xFF2196F3))),
            decoration: _getPageDecoration(),
          ),
          PageViewModel(
            title: "Test Your Knowledge 📝",
            body: "Take AI-generated quizzes, get instant feedback, and track your progress.",
            image: const Center(child: Icon(Icons.quiz_rounded, size: 100, color: Colors.green)),
            decoration: _getPageDecoration(),
          ),
          PageViewModel(
            title: "Find Your Tech Path 🚀",
            body: "Discover the best tech careers for you and get a personalized learning roadmap.",
            image: const Center(child: Icon(Icons.explore_rounded, size: 100, color: Colors.purple)),
            decoration: _getPageDecoration(),
          ),
        ],

        showSkipButton: true,
        skip: const Text("Skip", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
        next: const Icon(Icons.arrow_forward, color: Color(0xFF2196F3)),
        done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF2196F3))),

        onDone: () => _goToLogin(context),
        onSkip: () => _goToLogin(context),

        dotsDecorator: DotsDecorator(
            size: const Size.square(10.0),
            activeSize: const Size(25.0, 10.0),
            activeColor: const Color(0xFF2196F3),
            color: Colors.black26,
            spacing: const EdgeInsets.symmetric(horizontal: 3.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)
            )
        ),
      ),
    );
  }

  Future<void> _goToLogin(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenIntro', true);

    if (context.mounted) {
      // --- التعديل هنا: هيروح للـ AuthGate عشان تختار لوجين أو إنشاء حساب ---
      Navigator.of(context).pushReplacementNamed('/authGate');
    }
  }

  PageDecoration _getPageDecoration() {
    return const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black87),
      bodyTextStyle: TextStyle(fontSize: 16.0, color: Colors.grey),
      imagePadding: EdgeInsets.only(top: 50),
      pageColor: Color(0xFFF8FAFF),
    );
  }
}