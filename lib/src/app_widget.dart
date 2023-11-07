import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:glauber/src/compartilhado/theme/theme_data.dart';
import 'package:glauber/src/modulos/autenticacao/ui/paginas/pagina_cadastro.dart';
import 'package:glauber/src/modulos/autenticacao/ui/paginas/pagina_login.dart';
import 'package:glauber/src/modulos/inicio/ui/paginas/pagina_inicio.dart';
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
      themeMode: ThemeMode.light,
      initialRoute: '/',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],
      locale: const Locale('pt', 'BR'),
      routes: {
        '/': (context) => const PaginaSplash(),
        '/inicio': (context) => const PaginaInicio(),
        '/autenticacao/login': (context) => const PaginaLogin(),
        '/autenticacao/cadastrar': (context) => const PaginaCadastro(),
      },
    );
  }
}
