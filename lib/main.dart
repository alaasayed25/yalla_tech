import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'package:yalla_tech/ui/ screens/splash/splash_screen.dart';

void main() {
  runApp(const YallaTech());
}

class YallaTech extends StatelessWidget {
  const YallaTech({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Yalla Tech",
      routes: AppRoutes.routes,
      home: const SplashScreen(),
    );
  }
}