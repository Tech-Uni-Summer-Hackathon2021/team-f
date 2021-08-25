import 'package:flutter/material.dart';
import '../main.dart';
import '../screens/auth/login.dart';
import '../screens/auth/register.dart';

class AppRoutes {
  AppRoutes._();

  static const String authLogin = '/auth-login';
  static const String authRegister = '/auth-register';
  static const String home = '/home';

  static Map<String, WidgetBuilder> define() {
    return {
      authLogin: (context) => Login(),
      authRegister: (context) => Register(),
      home: (context) => TodoListPage(),
    };
  }
}