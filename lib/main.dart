import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/services/resume_service.dart';
import 'features/cv_builder/cv_builder_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ResumeService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CV Generator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Use the deep navy as primary color
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0A2540),
          primary: const Color(0xFF0A2540),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC), // Surface Light Gray
        useMaterial3: true,
        // Optional: you can add Google Fonts 'Inter' later here!
      ),
      home: const CvBuilderScreen(),
    );
  }
}
