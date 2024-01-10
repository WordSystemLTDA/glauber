import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provadelaco/src/app_routes.dart';
import 'package:provadelaco/src/compartilhado/theme/theme_controller.dart';
import 'package:provadelaco/src/compartilhado/theme/theme_data.dart';
import 'package:provadelaco/src/route_generator.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: context.read<ThemeController>(),
      builder: (context, state, _) {
        return MaterialApp(
          title: 'GS Equine',
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: state,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            SfGlobalLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('pt', 'BR'),
          ],
          locale: const Locale('pt', 'BR'),
          initialRoute: AppRotas.paginaInicial,
          navigatorKey: AppRotas.navigatorKey,
          onGenerateRoute: RouteGenerator.generateRoute,
        );
      },
    );
  }
}
