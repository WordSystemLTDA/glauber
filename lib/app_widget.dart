import 'package:flutter/material.dart';
import 'package:provadelaco/routing/routes.dart';
import 'package:provadelaco/ui/core/themes/theme_controller.dart';
import 'package:provadelaco/ui/core/themes/theme_data.dart';
import 'package:provadelaco/routing/router.dart';
import 'package:provider/provider.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: context.read<ThemeController>(),
      builder: (context, state, _) {
        return MaterialApp(
          builder: (context, child) {
            return MediaQuery(data: MediaQuery.of(context).copyWith(boldText: false), child: child!);
          },
          title: 'GS Equine',
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: state,
          locale: const Locale('pt', 'BR'),
          initialRoute: AppRotas.paginaInicial,
          navigatorKey: AppRotas.navigatorKey,
          onGenerateRoute: RouteGenerator.generateRoute,
        );
      },
    );
  }
}
