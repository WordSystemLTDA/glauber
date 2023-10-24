import 'package:flutter/material.dart';
import 'package:glauber/src/compartilhado/theme/theme_data.dart';
import 'package:glauber/src/modulos/autenticacao/ui/paginas/pagina_cadastro.dart';
import 'package:glauber/src/modulos/autenticacao/ui/paginas/pagina_login.dart';
import 'package:glauber/src/modulos/inicio/ui/paginas/pagina_inicio.dart';
import 'package:glauber/src/modulos/pagamentos_inscricao/ui/paginas/pagina_pagamentos_inscricao.dart';
import 'package:glauber/src/modulos/selecionar_ingresso/ui/paginas/pagina_selecionar_ingresso.dart';
import 'package:glauber/src/modulos/splash/ui/paginas/pagina_splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prova de Laço',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const PaginaSplash(),
        '/inicio': (context) => const PaginaInicio(),
        '/autenticacao/login': (context) => const PaginaLogin(),
        '/autenticacao/cadastrar': (context) => const PaginaCadastro(),
        '/selecionar_ingresso': (context) => const PaginaSelecionarIngresso(),
        '/pagamentos_inscricao': (context) => const PaginaPagamentosInscricao(),
      },
    );
  }
}
