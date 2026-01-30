import 'package:flutter/material.dart';
import 'package:provadelaco/domain/models/config/config.dart';

class ConfigProvider extends ChangeNotifier {
  ConfigModelo? _configs;

  ConfigModelo? get configs => _configs;

  void setConfig(ConfigModelo? configs) {
    _configs = configs;
    notifyListeners();
  }
}
