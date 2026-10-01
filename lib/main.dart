import 'package:flutter/material.dart';
import 'package:kuis/root.dart';

void main() {
  runApp(const MyApp());
}

// MyApp — StatelessWidget karena tidak punya state sendiri.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Menu Resto',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFFF8F3),
      ),
      home: const RootPage(),
    );
  }
}
