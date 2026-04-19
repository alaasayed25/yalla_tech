import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../routes/app_routes.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  // المحتوى بتاعك
  final List<Map<String, String>> _introData = [
    {
      "title": "Study Smarter with AI 🧠",
      "desc": "Upload your lessons and let our AI summarize and explain complex topics simply.",
      "icon": "📚"
    },
    {
      "title": "Test Your Knowledge 📝",
      "desc": "Take AI-generated quizzes, get instant feedback, and track your progress.",
      "icon": "🎯"
    },
    {
      "title": "Find Your Tech Path 🚀",
      "desc": "Discover the best tech careers for you and get a personalized learning roadmap.",
      "icon": "💻"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // أسود فخم
      body: Stack(
        children: [
          // الصفحات
          PageView.builder(
            controller: _controller,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemCount: _introData.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_introData[index]['icon']!,
                        style: const TextStyle(fontSize: 100)),
                    const SizedBox(height: 40),
                    Text(
                      _introData[index]['title']!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _introData[index]['desc']!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                  ],
                ),
              );
            },
          ),

          // الجزء اللي تحت (الزراير والانديكيتور)
          Positioned(
            bottom: 60,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // نقط الانديكيتور
                Row(
                  children: List.generate(
                    _introData.length,
                        (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.all(4),
                      width: _currentIndex == index ? 25 : 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: _currentIndex == index ? Colors.blueAccent : Colors.grey,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),

                // زرار Next / Get Started
                ElevatedButton(
                  onPressed: () async {
                    if (_currentIndex == _introData.length - 1) {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('hasSeenIntro', true);
                      if (context.mounted) {
                        // هيروح للـ authGate عشان يختار لوجين أو ريجستر
                        Navigator.pushReplacementNamed(context, AppRoutes.authGate);
                      }
                    } else {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                  ),
                  child: Text(
                    _currentIndex == _introData.length - 1 ? "Get Started" : "Next",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}