import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provadelaco/src/compartilhado/theme/theme_controller.dart';
import 'package:provadelaco/src/compartilhado/theme/theme_data.dart';
import 'package:provadelaco/src/modulos/autenticacao/ui/paginas/pagina_cadastro.dart';
import 'package:provadelaco/src/modulos/autenticacao/ui/paginas/pagina_login.dart';
import 'package:provadelaco/src/modulos/inicio/ui/paginas/pagina_inicio.dart';
import 'package:provadelaco/src/modulos/splash/ui/paginas/pagina_splash.dart';
import 'package:provider/provider.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: context.read<ThemeController>(),
      builder: (context, state, _) {
        return MaterialApp(
          title: 'Gs Equine',
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: state,
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
      },
    );
  }
}
