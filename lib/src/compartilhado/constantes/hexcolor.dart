import 'package:flutter/material.dart';

class HexColor extends Color {
  HexColor(final String hex) : super(_getColor(hex));
  static int _getColor(String hex) {
    String formattedHex = hex.toUpperCase().replaceAll("#", "");
    String stropacity = 150.toRadixString(16);
    return int.parse("$stropacity$formattedHex", radix: 16);
  }
}
