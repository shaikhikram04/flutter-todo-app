import 'package:flutter/material.dart';
import 'package:up_todo/core/utils/theme/theme.dart';
import 'package:up_todo/features/splash/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Up Todo',
      debugShowCheckedModeBanner: false,
      theme: TodoAppTheme.darkTheme,
      home: SplashScreen(),
    );
  }
}
