import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'Presentation/User_Panel/User_HomePage/menu_Screen.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QUICK BITES',
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        splash: 'assets/images/logo.png',
        nextScreen: const MenuScreen(),
        splashTransition: SplashTransition.slideTransition,
      ),
    );
  }
}
