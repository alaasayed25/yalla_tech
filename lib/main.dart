import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:yalla_tech/routes/app_routes.dart';
import 'firebase_options.dart';

void main() async {
  // السطر ده مهم عشان الفلاتر يستنى الفايربيز يشتغل
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة الفايربيز
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const YallaTech());
}

class YallaTech extends StatelessWidget {
  const YallaTech({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(), // الثيم الدارك بتاعك زي ما هو
      title: "Yalla Tech",

      // هنا إنت رابط الـ Routes صح جداً
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}