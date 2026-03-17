// import 'package:flutter/material.dart';
// import 'routes/app_routes.dart';
// import 'package:yalla_tech/ui/screens/splash/splash_screen.dart';
//
// void main() {
//   runApp(const YallaTech());
// }

// class YallaTech extends StatelessWidget {
//   const YallaTech({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: "Yalla Tech",
//       routes: AppRoutes.routes,
//       home: const SplashScreen(),
//     );
//   }
// }
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:yalla_tech/routes/app_routes.dart';
import 'package:yalla_tech/ui/%20screens/splash/splash_screen.dart';
import 'firebase_options.dart'; // السطر ده مهم جداً عشان يربط الملف الجديد
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const YallaTech());
}

class YallaTech extends StatelessWidget {
  const YallaTech({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      title: "Yalla Tech",
      // بدل كلمة home، هنستخدم initialRoute وننادي على اسم الـ route بتاع الاسبلاش
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}