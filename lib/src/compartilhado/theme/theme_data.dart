import 'package:flutter/material.dart';

part 'color_schemes.g.dart';

ThemeData get darkTheme => ThemeData(
      useMaterial3: true,
      colorScheme: _darkColorScheme,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: _darkColorScheme.primaryContainer,
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
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: _lightColorScheme.primaryContainer,
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
