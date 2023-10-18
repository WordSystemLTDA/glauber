import 'package:flutter/material.dart';
import 'package:glauber/src/compartilhado/theme/theme_data.dart';
import 'package:glauber/src/modulos/autenticacao/ui/paginas/pagina_cadastro.dart';
import 'package:glauber/src/modulos/autenticacao/ui/paginas/pagina_login.dart';
import 'package:glauber/src/modulos/home/home.dart';
import 'package:glauber/src/modulos/pagamentos_inscricao/pagamentos_inscricao.dart';
import 'package:glauber/src/modulos/selecionar_ingresso/selecionar_ingresso.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'glauber',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      initialRoute: '/home',
      routes: {
        '/home': (context) => const Home(),
        '/login': (context) => const PaginaLogin(),
        '/cadastrar': (context) => const PaginaCadastro(),
        '/selecionar_ingresso': (context) => const SelecionarIngresso(),
        '/pagamentos_inscricao': (context) => const PagamentosInscricao(),
      },
    );
  }
}
