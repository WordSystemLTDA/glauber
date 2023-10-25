import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class UsuarioProvider {
  static late SharedPreferences _preferences;

  static Future init() async => _preferences = await SharedPreferences.getInstance();

  static Future<bool> setUsuario(String usuario) async {
    _preferences.reload();
    return await _preferences.setString('usuario', usuario);
  }

  static Future<void> atualizar() async {
    return _preferences.reload();
  }

  static Future<bool> removerUsuario() async {
    return await _preferences.remove('usuario');
  }

  static Map<String, dynamic> getUsuario() {
    _preferences.reload();
    return _preferences.getString('usuario') != null ? jsonDecode(_preferences.getString('usuario') ?? '') : {};
  }
}
