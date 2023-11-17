// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class UsuarioProvider {
  static late SharedPreferences _preferences;

  static Future init() async => _preferences = await SharedPreferences.getInstance();

  static Future<bool> setUsuario(String usuario) async {
    return await _preferences.setString('usuario', usuario);
  }

  static Future<void> atualizar() async {
    return _preferences.reload();
  }

  static Future<bool> removerUsuario() async {
    return await _preferences.remove('usuario');
  }

  static DadosModelo? getUsuario() {
    atualizar();
    String? usuario = _preferences.getString('usuario');

    if (usuario != null) {
      return DadosModelo.fromMap(jsonDecode(_preferences.getString('usuario') ?? ''));
    }

    return null;
  }
}

class DadosModelo {
  final String? id;
  final String? email;
  final String? senha;
  final String? nome;
  final String? token;
  final String? tipo;
  final String? primeiroAcesso;

  DadosModelo({
    required this.id,
    required this.email,
    required this.senha,
    required this.nome,
    required this.token,
    required this.tipo,
    required this.primeiroAcesso,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'senha': senha,
      'nome': nome,
      'token': token,
      'tipo': tipo,
      'primeiroAcesso': primeiroAcesso,
    };
  }

  factory DadosModelo.fromMap(Map<String, dynamic> map) {
    return DadosModelo(
      id: map['id'] != null ? map['id'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      senha: map['senha'] != null ? map['senha'] as String : null,
      nome: map['nome'] != null ? map['nome'] as String : null,
      token: map['token'] != null ? map['token'] as String : null,
      tipo: map['tipo'] != null ? map['tipo'] as String : null,
      primeiroAcesso: map['primeiroAcesso'] != null ? map['primeiroAcesso'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DadosModelo.fromJson(String source) => DadosModelo.fromMap(json.decode(source) as Map<String, dynamic>);
}
