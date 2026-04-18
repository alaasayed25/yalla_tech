
import 'package:flutter/material.dart';
import '../ui/ screens/auth/auth_gate_screen.dart';
import '../ui/ screens/auth/login_screen.dart';
import '../ui/ screens/auth/register_screen.dart';
import '../ui/ screens/home/home_screen.dart';
import '../ui/ screens/intro/intro_screen.dart';
import '../ui/ screens/profile/logout_screen.dart';
import '../ui/ screens/splash/splash_screen.dart';

class AppRoutes {
  static const String splash = "/";
  static const String login = "/login";
  static const String register = "/register";
  static const String authGate = "/authGate";
  static const String home = "/home";
  static const String logout = "/logout";
  static const String intro = "/intro";



  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    authGate: (context) => const AuthGateScreen(),
    home: (context) => const HomeScreen(),
    logout: (context) => const LogoutScreen(),
    intro: (context) => const IntroScreen(),
  };
}

