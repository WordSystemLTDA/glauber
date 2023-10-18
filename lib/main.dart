import 'package:flutter/material.dart';
import 'package:glauber/src/compartilhado/theme/theme_data.dart';

import 'package:glauber/src/modulos/home/home.dart';
import 'package:glauber/src/modulos/login/login.dart';
import 'package:glauber/src/modulos/cadastrar/cadastrar.dart';
import 'package:glauber/src/modulos/selecionar_ingresso/selecionar_ingresso.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'glauber',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      initialRoute: '/home',
      routes: {
        '/home': (context) => Home(),
        '/login': (context) => Login(),
        '/cadastrar': (context) => Cadastrar(),
        '/selecionar_ingresso': (context) => SelecionarIngresso(),
      },
    );
  }
}
