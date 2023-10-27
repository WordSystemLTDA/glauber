import 'package:flutter/material.dart';
import 'package:glauber/src/compartilhado/theme/theme_data.dart';
import 'package:glauber/src/modulos/autenticacao/ui/paginas/pagina_cadastro.dart';
import 'package:glauber/src/modulos/autenticacao/ui/paginas/pagina_login.dart';
import 'package:glauber/src/modulos/inicio/ui/paginas/pagina_inicio.dart';
import 'package:glauber/src/modulos/finalizar_compra/ui/paginas/pagina_finalizar_compra.dart';
import 'package:glauber/src/modulos/splash/ui/paginas/pagina_splash.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

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
        '/finalizar_compra': (context) => const PaginaFinalizarCompra(),
      },
    );
  }
}
