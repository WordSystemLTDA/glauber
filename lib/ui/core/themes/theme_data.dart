import 'package:flutter/material.dart';

part 'color_schemes.g.dart';

ThemeData get darkTheme => ThemeData(
      useMaterial3: true,
      colorScheme: _darkColorScheme,
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      }),
      scaffoldBackgroundColor: _darkColorScheme.surface,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: _darkColorScheme.surface,
        surfaceTintColor: _darkColorScheme.surface,
      ),
      cardColor: _darkColorScheme.surface,
      cardTheme: CardThemeData(
        color: _darkColorScheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: _darkColorScheme.surface,
        surfaceTintColor: _darkColorScheme.surface,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _darkColorScheme.primary,
        foregroundColor: _darkColorScheme.onPrimary,
      ),
      inputDecorationTheme: _inputDecorationTheme,
      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: _inputDecorationTheme,
        textStyle: const TextStyle(fontSize: 16),
      ),
    );

ThemeData get lightTheme => ThemeData(
      useMaterial3: true,
      colorScheme: _lightColorScheme,
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      }),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _lightColorScheme.primary,
        foregroundColor: _lightColorScheme.onPrimary,
      ),
      inputDecorationTheme: _inputDecorationTheme,
      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: _inputDecorationTheme,
        textStyle: const TextStyle(fontSize: 16),
      ),
    );

InputDecorationTheme get _inputDecorationTheme => const InputDecorationTheme(
      contentPadding: EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 10.0),
      constraints: BoxConstraints(maxHeight: 45),
      border: OutlineInputBorder(),
    );
