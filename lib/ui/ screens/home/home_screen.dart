// import 'package:flutter/material.dart';
// import 'package:yalla_tech/routes/app_routes.dart';
// import '../../../features/summarize_lesson.dart';
// import '../../../features/tech_trends.dart';
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
//   // قائمة الشاشات الأساسية (الـ IndexedStack)
//   final List<Widget> screens = [
//     const Dashboard(), // شاشة الاستكشاف (الرئيسية المليانة)
//     const UploadCVScreen(), // شاشة المذاكرة (Study)
//     const QuizScreen(), // شاشة الامتحانات (Quiz)
//     const ProfileScreen(), // شاشة الملف الشخصي (Me)
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF121212), // Dark Mode Theme
//       body: IndexedStack(index: index, children: screens),
//       bottomNavigationBar: Container(
//         decoration: BoxDecoration(
//           border: Border(
//             top: BorderSide(color: Colors.white.withOpacity(0.05), width: 1),
//           ),
//         ),
//         child: BottomNavigationBar(
//           currentIndex: index,
//           type: BottomNavigationBarType.fixed,
//           backgroundColor: const Color(0xFF1E1E1E),
//           selectedItemColor: const Color(0xFF2196F3),
//           unselectedItemColor: Colors.grey,
//           showUnselectedLabels: true,
//
//           // --- حجم الخط الكبير اللي طلبته ---
//           selectedLabelStyle: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//           unselectedLabelStyle: const TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//           ),
//
//           // ---------------------------------
//           onTap: (value) {
//             if (value == 4) {
//               Navigator.of(context).pushNamed(AppRoutes.logout);
//             } else {
//               setState(() => index = value);
//             }
//           },
//           items: const [
//             BottomNavigationBarItem(
//               icon: Icon(Icons.dashboard_rounded),
//               label: "Home",
//             ), // اتصلحت من hmoe لـ Home
//             BottomNavigationBarItem(
//               icon: Icon(Icons.auto_stories),
//               label: "Study",
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.psychology),
//               label: "Quiz",
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.person_rounded),
//               label: "Me",
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.logout_rounded, color: Colors.redAccent),
//               label: "Logout",
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // الـ Dashboard: دي الشاشة اللي فيها كل "الخلطة السرية"
// class Dashboard extends StatelessWidget {
//   const Dashboard({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     // تخيل إننا بنجيب اسم الطالب من السيستم
//     String studentName = "يا بطل";
//
//     return Scaffold(
//       backgroundColor: const Color(0xFF121212), // Dark Background
//       appBar: AppBar(
//         title: const Text(
//           "Yalla Tech",
//           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//         ),
//         actions: [
//           IconButton(
//             onPressed: () {},
//             icon: const Icon(
//               Icons.notifications_none_rounded,
//               color: Colors.white,
//             ),
//           ),
//         ],
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // 1. الـ Header (الترحيب التحفيزي)
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "أهلاً $studentName! 👋",
//                         style: const TextStyle(
//                           fontSize: 26,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                       const SizedBox(height: 6),
//                       Text(
//                         "عاش إنك حملت التطبيق! 🚀\nباقي 60 يوم على الامتحانات، شد حيلك!",
//                         style: TextStyle(
//                           color: Colors.grey[400],
//                           fontSize: 14,
//                           height: 1.4,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 CircleAvatar(
//                   radius: 28,
//                   backgroundColor: Colors.blueAccent.withOpacity(0.1),
//                   child: const Icon(
//                     Icons.person,
//                     color: Color(0xFF2196F3),
//                     size: 30,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 30),
//
//             // 2. كارت الـ AI الـ Hero (التلخيص السريع)
//             _buildMainAICard(context),
//             const SizedBox(height: 30),
//
//             const Text(
//               "How can I help you today?",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//             const SizedBox(height: 15),
//
//             // 3. الـ Grid بتاع الـ Quick Actions (4 مربعات منظمة)
//             GridView.count(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               crossAxisCount: 2,
//               crossAxisSpacing: 15,
//               mainAxisSpacing: 15,
//               childAspectRatio: 1.1,
//               children: [
//                 // --- التعديل الجديد: ربطنا زرار التلخيص بالشاشة بتاعته ---
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const SummarizeLessonScreen(),
//                       ),
//                     );
//                   },
//                   child: _buildFeatureCard(
//                     "Summarize\nLesson",
//                     Icons.description_rounded,
//                     Colors.orangeAccent,
//                   ),
//                 ),
//
//                 // ----------------------------------------------------------
//                 _buildFeatureCard(
//                   "Mock\nExam",
//                   Icons.quiz_outlined,
//                   Colors.greenAccent,
//                 ),
//
//                 _buildFeatureCard(
//                   "Career\nRoadmap",
//                   Icons.alt_route_rounded,
//                   Colors.purpleAccent,
//                 ),
//
//                 // --- التعديل القديم: بتاع شاشة الأخبار ---
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const TechTrendsScreen(),
//                       ),
//                     );
//                   },
//                   child: _buildFeatureCard(
//                     "Tech\nTrends",
//                     Icons.trending_up_rounded,
//                     Colors.blueAccent,
//                   ),
//                 ),
//                 // -------------------------------------------------------------------
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // كارت الـ AI الكبير (الـ Hero Card)
//   Widget _buildMainAICard(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [Color(0xFF2196F3), Color(0xFF0D47A1)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.blue.withOpacity(0.2),
//             blurRadius: 15,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           const Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "دليل المسار (AI)",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   "حلل مهاراتك وشوف الـ AI بيقولك تدخل كلية إيه!",
//                   style: TextStyle(
//                     color: Colors.white70,
//                     fontSize: 13,
//                     height: 1.4,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: const BoxDecoration(
//               color: Colors.white24,
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(
//               Icons.bolt_rounded,
//               color: Colors.yellow,
//               size: 40,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // كروت الخدمات السريعة (الـ Quick Actions)
//   Widget _buildFeatureCard(String title, IconData icon, Color color) {
//     return Container(
//       decoration: BoxDecoration(
//         color: const Color(0xFF1E1E1E), // Dark Card
//         borderRadius: BorderRadius.circular(24),
//         border: Border.all(color: Colors.white.withOpacity(0.05)),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.1),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(icon, color: color, size: 28),
//           ),
//           const SizedBox(height: 12),
//           Text(
//             title,
//             textAlign: TextAlign.center,
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 14,
//               color: Colors.white,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:yalla_tech/routes/app_routes.dart';
import '../../../features/summarize_lesson.dart';
import '../../../features/tech_trends.dart';
import '../../../features/career_path_ai_screen.dart'; // السطر ده اتضاف عشان يقرا الشاشة الجديدة
import '../profile/profile_screen.dart';
import '../quiz/quiz_screen.dart';
import '../upload_cv/upload_cv_screen.dart';

// --- شاشات مؤقتة عشان الكود يشتغل بدون Errors لحد ما تصممهم ---
class MockExamScreen extends StatelessWidget {
  const MockExamScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(backgroundColor: Color(0xFF121212), body: Center(child: Text('Mock Exam Screen', style: TextStyle(color: Colors.white))));
}

class CareerRoadmapScreen extends StatelessWidget {
  const CareerRoadmapScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(backgroundColor: Color(0xFF121212), body: Center(child: Text('Career Roadmap Screen', style: TextStyle(color: Colors.white))));
}
// ---------------------------------------------------------------

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;

  // قائمة الشاشات الأساسية (الـ IndexedStack)
  final List<Widget> screens = [
    const Dashboard(), // شاشة الاستكشاف (الرئيسية المليانة)
    const UploadCVScreen(), // شاشة المذاكرة (Study)
    const QuizScreen(), // شاشة الامتحانات (Quiz)
    const ProfileScreen(), // شاشة الملف الشخصي (Me)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Dark Mode Theme
      body: IndexedStack(index: index, children: screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.white.withOpacity(0.05), width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: index,
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF1E1E1E),
          selectedItemColor: const Color(0xFF2196F3),
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,

          // --- كبرنا حجم الخط هنا زي ما طلبت ---
          selectedLabelStyle: const TextStyle(
            fontSize: 18, // كانت 16 وبقت 18
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 16, // كانت 14 وبقت 16
            fontWeight: FontWeight.w500,
          ),
          // ---------------------------------

          onTap: (value) {
            if (value == 4) {
              Navigator.of(context).pushNamed(AppRoutes.logout);
            } else {
              setState(() => index = value);
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_rounded),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.auto_stories),
              label: "Study",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.psychology),
              label: "Quiz",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: "Me",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.logout_rounded, color: Colors.redAccent),
              label: "Logout",
            ),
          ],
        ),
      ),
    );
  }
}

// الـ Dashboard: دي الشاشة اللي فيها كل "الخلطة السرية"
class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    // تخيل إننا بنجيب اسم الطالب من السيستم
    String studentName = "يا بطل";

    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Dark Background
      appBar: AppBar(
        title: const Text(
          "Yalla Tech",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: Colors.white,
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. الـ Header (الترحيب التحفيزي)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "أهلاً $studentName! 👋",
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "يوم جديد، فرصة جديدة للنجاح 💪\nيلا بينا نشوف هنتعلم إيه النهاردة في عالم الـ Tech   ",
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 20,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.blueAccent.withOpacity(0.1),
                  child: const Icon(
                    Icons.person,
                    color: Color(0xFF2196F3),
                    size: 30,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // 2. كارت الـ AI الـ Hero (التلخيص السريع) - هنا التعديل الجديد
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CareerPathAIScreen(),
                  ),
                );
              },
              child: _buildMainAICard(context),
            ),
            const SizedBox(height: 30),

            const Text(
              "How can I help you today?",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 15),

            // 3. الـ Grid بتاع الـ Quick Actions (4 مربعات منظمة)
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1.1,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SummarizeLessonScreen(),
                      ),
                    );
                  },
                  child: _buildFeatureCard(
                    "Summarize\nLesson",
                    Icons.description_rounded,
                    Colors.orangeAccent,
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MockExamScreen(),
                      ),
                    );
                  },
                  child: _buildFeatureCard(
                    "Mock\nExam",
                    Icons.quiz_outlined,
                    Colors.greenAccent,
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CareerRoadmapScreen(),
                      ),
                    );
                  },
                  child: _buildFeatureCard(
                    "Career\nRoadmap",
                    Icons.alt_route_rounded,
                    Colors.purpleAccent,
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TechTrendsScreen(),
                      ),
                    );
                  },
                  child: _buildFeatureCard(
                    "Tech\nTrends",
                    Icons.trending_up_rounded,
                    Colors.blueAccent,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // كارت الـ AI الكبير (الـ Hero Card)
  Widget _buildMainAICard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2196F3), Color(0xFF0D47A1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "دليل المسار (AI)",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "حلل مهاراتك وشوف الـ AI بيقولك تدخل كلية إيه!",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.white24,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.bolt_rounded,
              color: Colors.yellow,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }

  // كروت الخدمات السريعة (الـ Quick Actions)
  Widget _buildFeatureCard(String title, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E), // Dark Card
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}