import 'package:flutter/material.dart';
import 'package:prototype_demo/pages/pages.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prototype Demo',
      home: const HomePage(),
    );
  }
}