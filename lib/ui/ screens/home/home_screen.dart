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

  final screens = [

    const Dashboard(),
    const UploadCVScreen(),
    const QuizScreen(),
    const ProfileScreen(),

  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: screens[index],

      bottomNavigationBar: BottomNavigationBar(

        currentIndex: index,

        onTap: (value){
          setState(() {
            index = value;
          });
        },

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.upload),
            label: "Upload",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.quiz),
            label: "Quiz",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {

    return const Center(
      child: Text(
        "Welcome to Yalla Tech 🚀",
        style: TextStyle(fontSize: 22),
      ),
    );
  }
}