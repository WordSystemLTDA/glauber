import 'package:flutter/foundation.dart';
import 'package:provadelaco/src/essencial/providers/config/config_modelo.dart';

class ConfigProvider extends ChangeNotifier {
  ConfigModelo? _configs;

  ConfigModelo? get configs => _configs;

  void setVersoes(ConfigModelo? configs) {
    _configs = configs;
    notifyListeners();
  }
}
