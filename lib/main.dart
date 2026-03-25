import 'package:flutter/material.dart';
import 'package:quran_app_mvp/screens/home_screen.dart';
import 'package:quran_app_mvp/services/quran_repository.dart';

void main() {
  runApp(const QuranApp());
}

class QuranApp extends StatelessWidget {
  const QuranApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'تطبيق القرآن',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: HomeScreen(repository: QuranRepository()),
    );
  }
}
