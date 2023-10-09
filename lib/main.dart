import 'package:flutter/material.dart';
import 'package:glauber/src/modulos/home/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'glauber',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.black),
      home: Home(),
    );
  }
}
