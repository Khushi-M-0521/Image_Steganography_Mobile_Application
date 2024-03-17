import 'package:flutter/material.dart';
import 'package:stego_image/appscreen.dart';
import 'package:stego_image/splashscreen.dart';
import 'package:stego_image/theme_constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stego App',
      theme: ThemeData.light().copyWith(
        colorScheme: lightColorScheme,
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: darkColorScheme,
        useMaterial3: true,
      ),

      home: const AppScreen(),
    );
  }
}
