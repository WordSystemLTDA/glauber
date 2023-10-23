import 'package:flutter/material.dart';
import 'package:glauber/src/compartilhado/theme/theme_data.dart';
import 'package:glauber/src/modulos/autenticacao/ui/paginas/pagina_cadastro.dart';
import 'package:glauber/src/modulos/autenticacao/ui/paginas/pagina_login.dart';
import 'package:glauber/src/modulos/inicio/ui/pagina_inicio.dart';
import 'package:glauber/src/modulos/pagamentos_inscricao/ui/pagina_pagamentos_inscricao.dart';
import 'package:glauber/src/modulos/selecionar_ingresso/ui/pagina_selecionar_ingresso.dart';

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
      initialRoute: '/inicio',
      routes: {
        '/inicio': (context) => const PaginaInicio(),
        '/login': (context) => const PaginaLogin(),
        '/cadastrar': (context) => const PaginaCadastro(),
        '/selecionar_ingresso': (context) => const PaginaSelecionarIngresso(),
        '/pagamentos_inscricao': (context) => const PaginaPagamentosInscricao(),
      },
    );
  }
}
