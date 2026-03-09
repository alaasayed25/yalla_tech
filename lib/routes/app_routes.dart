import 'package:flutter/material.dart';
import 'package:yalla_tech/ui/%20screens/auth/login_screen.dart';
import 'package:yalla_tech/ui/%20screens/home/home_screen.dart';


class AppRoutes {

  static const login = "/login";
  static const home = "/home";

  static Map<String, WidgetBuilder> routes = {

    login: (context) => const LoginScreen(),
    home: (context) => const HomeScreen(),

  };

}