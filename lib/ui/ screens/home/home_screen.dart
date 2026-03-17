// // import 'package:flutter/material.dart';
// // import '../profile/profile_screen.dart';
// // import '../quiz/quiz_screen.dart';
// // import '../upload_cv/upload_cv_screen.dart';
// //
// // class HomeScreen extends StatefulWidget {
// //   const HomeScreen({super.key});
// //
// //   @override
// //   State<HomeScreen> createState() => _HomeScreenState();
// // }
// //
// // class _HomeScreenState extends State<HomeScreen> {
// //
// //   int index = 0;
// //
// //   final screens = [
// //
// //     const Dashboard(),
// //     const UploadCVScreen(),
// //     const QuizScreen(),
// //     const ProfileScreen(),
// //
// //   ];
// //
// //   @override
// //   Widget build(BuildContext context) {
// //
// //     return Scaffold(
// //
// //       body: screens[index],
// //
// //       bottomNavigationBar: BottomNavigationBar(
// //
// //         currentIndex: index,
// //
// //         onTap: (value){
// //           setState(() {
// //             index = value;
// //           });
// //         },
// //
// //         items: const [
// //
// //           BottomNavigationBarItem(
// //             icon: Icon(Icons.home),
// //             label: "Home",
// //           ),
// //
// //           BottomNavigationBarItem(
// //             icon: Icon(Icons.upload),
// //             label: "Upload",
// //           ),
// //
// //           BottomNavigationBarItem(
// //             icon: Icon(Icons.quiz),
// //             label: "Quiz",
// //           ),
// //
// //           BottomNavigationBarItem(
// //             icon: Icon(Icons.person),
// //             label: "Profile",
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
// // class Dashboard extends StatelessWidget {
// //   const Dashboard({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //
// //     return const Center(
// //       child: Text(
// //         "Welcome to Yalla Tech 🚀",
// //         style: TextStyle(fontSize: 22),
// //       ),
// //     );
// //   }
// // }
//
// import 'package:flutter/material.dart';
// import '../profile/profile_screen.dart';
// import '../quiz/quiz_screen.dart';
// import '../upload_cv/upload_cv_screen.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   int index = 0;
//
//   final List<Widget> screens = [
//     const Dashboard(),
//     const UploadCVScreen(),
//     const QuizScreen(),
//     const ProfileScreen(),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: IndexedStack(
//         index: index,
//         children: screens,
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: index,
//         type: BottomNavigationBarType.fixed,
//         selectedItemColor: const Color(0xFF2196F3), // لون أزرق تكنولوجي
//         unselectedItemColor: Colors.grey,
//         showUnselectedLabels: true,
//         onTap: (value) => setState(() => index = value),
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: "Explore"),
//           BottomNavigationBarItem(icon: Icon(Icons.auto_stories), label: "Study"), // اتغير لـ Study
//           BottomNavigationBarItem(icon: Icon(Icons.psychology), label: "Career"), // اتغير لـ Career
//           BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: "Me"),
//         ],
//       ),
//     );
//   }
// }
//
// class Dashboard extends StatelessWidget {
//   const Dashboard({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFF), // خلفية هادية ومريحة
//       appBar: AppBar(
//         title: const Text("Yalla Tech", style: TextStyle(fontWeight: FontWeight.bold)),
//         actions: [
//           IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none_rounded)),
//         ],
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         foregroundColor: Colors.black,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // 1. قسم الترحيب والتحفيز
//             const Text("Hello, Future Techie! 👋",
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 8),
//             const Text("Ready to simplify your study or explore careers?",
//                 style: TextStyle(color: Colors.grey, fontSize: 16)),
//             const SizedBox(height: 25),
//
//             // 2. كارت الذكاء الاصطناعي (AI Summary)
//             _buildAICard(),
//             const SizedBox(height: 30),
//
//             // 3. قسم المميزات الرئيسية (Grid)
//             const Text("How can I help you today?",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 15),
//             GridView.count(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               crossAxisCount: 2,
//               crossAxisSpacing: 15,
//               mainAxisSpacing: 15,
//               childAspectRatio: 1.1,
//               children: [
//                 _buildFeatureCard("Summarize\nLesson", Icons.description_rounded, Colors.orange),
//                 _buildFeatureCard("Mock\nExam", Icons.quiz_outlined, Colors.green),
//                 _buildFeatureCard("Career\nRoadmap", Icons.alt_route_rounded, Colors.purple),
//                 _buildFeatureCard("Tech\nTrends", Icons.trending_up_rounded, Colors.blue),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // كارت مخصص لشرح ميزة الـ AI الرئيسية
//   Widget _buildAICard() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(colors: [Color(0xFF2196F3), Color(0xFF64B5F6)]),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
//       ),
//       child: Row(
//         children: [
//           const Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("AI Career Guide", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
//                 SizedBox(height: 8),
//                 Text("Analyze your skills & find the best tech path.", style: TextStyle(color: Colors.whiteee, fontSize: 14)),
//               ],
//             ),
//           ),
//           const Icon(Icons.bolt_rounded, color: Colors.yellow, size: 50),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildFeatureCard(String title, IconData icon, Color color) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircleAvatar(backgroundColor: color.withOpacity(0.1), child: Icon(icon, color: color)),
//           const SizedBox(height: 12),
//           Text(title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import '../profile/profile_screen.dart';
import '../quiz/quiz_screen.dart';
import '../upload_cv/upload_cv_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;

  final List<Widget> screens = [
    const Dashboard(),
    const UploadCVScreen(),
    const QuizScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: index,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF2196F3),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (value) => setState(() => index = value),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: "Explore"),
          BottomNavigationBarItem(icon: Icon(Icons.auto_stories), label: "Study"),
          BottomNavigationBarItem(icon: Icon(Icons.psychology), label: "Career"),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: "Me"),
        ],
      ),
    );
  }
}

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        title: const Text("Yalla Tech", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none_rounded)),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Hello, Future Techie! 👋",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("Ready to simplify your study or explore careers?",
                style: TextStyle(color: Colors.grey, fontSize: 16)),
            const SizedBox(height: 25),

            // 2. كارت الذكاء الاصطناعي (تم تصحيح الأخطاء هنا)
            _buildAICard(),
            const SizedBox(height: 30),

            const Text("How can I help you today?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1.1,
              children: [
                _buildFeatureCard("Summarize\nLesson", Icons.description_rounded, Colors.orange),
                _buildFeatureCard("Mock\nExam", Icons.quiz_outlined, Colors.green),
                _buildFeatureCard("Career\nRoadmap", Icons.alt_route_rounded, Colors.purple),
                _buildFeatureCard("Tech\nTrends", Icons.trending_up_rounded, Colors.blue),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAICard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF2196F3), Color(0xFF64B5F6)]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5)
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                    "AI Career Guide",
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)
                ),
                SizedBox(height: 8),
                Text(
                    "Analyze your skills & find the best tech path.",
                    style: TextStyle(color: Colors.white, fontSize: 14)
                ),
              ],
            ),
          ),
          const Icon(Icons.bolt_rounded, color: Colors.yellow, size: 50),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(String title, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(backgroundColor: color.withOpacity(0.1), child: Icon(icon, color: color)),
          const SizedBox(height: 12),
          Text(title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        ],
      ),
    );
  }
}