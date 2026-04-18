import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../profile/profile_screen.dart';
import '../recommendations/recommendations_screen.dart';
import '../roadmap/roadmap_screen.dart';
import '../ai_chat/ai_chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;

  final List<Widget> screens = [
    const Dashboard(),
    const CareerRoadmapScreen(careerPathName: 'My Path', steps: []),
    const AiChatScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      body: IndexedStack(index: index, children: screens),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(canvasColor: const Color(0xFF030A12)),
        child: BottomNavigationBar(
          currentIndex: index,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF00E5FF),
          unselectedItemColor: const Color(0xFFB0BEC5),
          onTap: (val) => setState(() => index = val),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.alt_route), label: "My Path"),
            BottomNavigationBarItem(icon: Icon(Icons.smart_toy_outlined), label: "AI Tutor"),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
          ],
        ),
      ),
    );
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final Color bgColor = const Color(0xFF0D1B2A);
  final Color blockColor = const Color(0xFF1B263B);
  final Color primaryCyan = const Color(0xFF00E5FF);

  bool _isLoadingPicks = true;
  List<String> _dailyPicks = [];

  @override
  void initState() {
    super.initState();
    _fetchDailyPicks(); // أول ما الشاشة تفتح، نجيب الأسئلة
  }

  Future<void> _fetchDailyPicks() async {
    setState(() {
      _isLoadingPicks = true; // بنظهر اللودينج كل ما بنحدث الأسئلة
    });

    try {
      // ⚠️ يفضل تغيير هذا المفتاح لاحقاً لأسباب أمنية
      const apiKey = 'AIzaSyD_MU2A8_-kU0YI7f4s_YB2RjbzTUWZktQ';
      final model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: apiKey);

      // الـ Prompt الجديد: يركز على طالب مدرسة وأساسيات التكنولوجيا
      final prompt = "Generate 3 very short, basic technology questions for a middle school student. "
          "Focus on basics like (What is RAM, What is Software, How does a router work, What is an IP address, etc.). "
          "The questions must be simple and easy to understand. "
          "Return ONLY the 3 questions separated by '|' without any numbering or extra text.";

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      if (response.text != null) {
        final questions = response.text!.split('|').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

        setState(() {
          _dailyPicks = questions.take(3).toList();
          _isLoadingPicks = false;
        });
      }
    } catch (e) {
      setState(() {
        // أسئلة افتراضية في حال حدوث خطأ أو انقطاع النت
        _dailyPicks = ["What is Hardware?", "What is an IP?", "What is Software?"];
        _isLoadingPicks = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. الهيدر
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Hello, Ahmad", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(color: Colors.orange.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                        child: const Row(
                          children: [
                            Text("🔥 3", style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold, fontSize: 14)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.notifications_none_rounded, color: Colors.white.withOpacity(0.8), size: 28),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 24),

              // 2. اقتراحات الذكاء الاصطناعي (Daily Picks)
              _buildAIDailyPicks(context),
              const SizedBox(height: 24),

              // 3. مستطيل عريض: الشات مع الذكاء الاصطناعي
              _buildWideRectangle(
                context: context,
                title: "Chat with AI Tutor",
                subtitle: "Ask questions & get instant help",
                icon: Icons.smart_toy,
                color: primaryCyan,
                targetScreen: const AiChatScreen(),
              ),
              const SizedBox(height: 16),

              // 4. مستطيل عريض: منهج المدرسة
              _buildWideRectangle(
                context: context,
                title: "School Curriculum (ICT)",
                subtitle: "Prep & High School lessons",
                icon: Icons.menu_book_rounded,
                color: Colors.orangeAccent,
                targetScreen: const Scaffold(body: Center(child: Text("ICT Screen", style: TextStyle(color: Colors.white)))),
              ),
              const SizedBox(height: 16),

              // 5. مستطيل عريض: مكتبتي
              _buildWideRectangle(
                context: context,
                title: "My AI Library",
                subtitle: "Your saved notes & explanations",
                icon: Icons.auto_stories,
                color: Colors.lightGreenAccent,
                targetScreen: const Scaffold(body: Center(child: Text("Saved Notes Screen", style: TextStyle(color: Colors.white)))),
              ),
              const SizedBox(height: 16),

              // 6. مربعات جنب بعض
              Row(
                children: [
                  Expanded(
                    child: _buildSquareBlock(
                      context: context,
                      title: "Tech Fields\nVideos",
                      icon: Icons.play_circle_fill,
                      color: Colors.greenAccent,
                      targetScreen: const Scaffold(body: Center(child: Text("Videos Screen", style: TextStyle(color: Colors.white)))),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSquareBlock(
                      context: context,
                      title: "AI Career\nTest",
                      icon: Icons.psychology,
                      color: Colors.purpleAccent,
                      targetScreen: const RecommendationScreen(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 7. مستطيل عريض: استكمال المسار الحالي
              _buildWideRectangle(
                context: context,
                title: "My Active Roadmap",
                subtitle: "Continue: Web Development",
                icon: Icons.route,
                color: Colors.pinkAccent,
                targetScreen: const CareerRoadmapScreen(careerPathName: 'Web Dev', steps: []),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // === ويدجت اقتراحات اليوم (Daily Picks) ===
  Widget _buildAIDailyPicks(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("AI Suggested for you:", style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 12),
        _isLoadingPicks
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            // بنبعت السؤال صافي من غير إيموجي للدالة اللي تحت
            children: _dailyPicks.map((q) => _buildPickChip(context, q)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPickChip(BuildContext context, String questionText) {
    return InkWell(
      onTap: () async {
        // استخدام await هنا هيوقف الكود لحد ما الطالب يقفل شاشة الشات ويرجع للهوم
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AiChatScreen(initialMessage: questionText),
          ),
        );

        // أول ما يرجع للهوم، الدالة دي هتتنفذ وتجيب أسئلة جديدة أوتوماتيك
        _fetchDailyPicks();
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: blockColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: primaryCyan.withOpacity(0.3)),
        ),
        // اللمبة بتتحط هنا في الديزاين بس، ومش بتتبعت للشات
        child: Text("💡 $questionText", style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13, fontWeight: FontWeight.w600)),
      ),
    );
  }

  // === ويدجت المستطيل العريض (Rectangles) ===
  Widget _buildWideRectangle({required BuildContext context, required String title, required String subtitle, required IconData icon, required Color color, required Widget targetScreen}) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => targetScreen)),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: blockColor, borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: color, size: 32)),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 4), Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 13))])),
            const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 16),
          ],
        ),
      ),
    );
  }

  // === ويدجت المربع (Squares) ===
  Widget _buildSquareBlock({required BuildContext context, required String title, required IconData icon, required Color color, required Widget targetScreen}) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => targetScreen)),
      borderRadius: BorderRadius.circular(16),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: blockColor, borderRadius: BorderRadius.circular(16)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 40),
              const SizedBox(height: 16),
              Text(title, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}