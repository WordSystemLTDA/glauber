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
  final String hcCabeceira;
  final String hcPezeiro;
  final String? tipo;
  final String? primeiroAcesso;
  final String? cpf;
  final String? dataNascimento;
  final String? sexo;
  final String? rg;
  final String? telefone;
  final String? celular;
  final String? cep;
  final String? endereco;
  final String? numero;
  final String? bairro;
  final String? complemento;
  final String? cidade;

  DadosModelo({
    required this.id,
    required this.email,
    required this.senha,
    required this.hcCabeceira,
    required this.hcPezeiro,
    required this.nome,
    required this.token,
    required this.tipo,
    required this.primeiroAcesso,
    required this.cpf,
    required this.dataNascimento,
    required this.sexo,
    required this.rg,
    required this.telefone,
    required this.celular,
    required this.cep,
    required this.endereco,
    required this.numero,
    required this.bairro,
    required this.complemento,
    required this.cidade,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'senha': senha,
      'nome': nome,
      'token': token,
      'hcCabeceira': hcCabeceira,
      'hcPezeiro': hcPezeiro,
      'tipo': tipo,
      'primeiroAcesso': primeiroAcesso,
      'cpf': cpf,
      'dataNascimento': dataNascimento,
      'sexo': sexo,
      'rg': rg,
      'telefone': telefone,
      'celular': celular,
      'cep': cep,
      'endereco': endereco,
      'numero': numero,
      'bairro': bairro,
      'complemento': complemento,
      'cidade': cidade,
    };
  }

  factory DadosModelo.fromMap(Map<String, dynamic> map) {
    return DadosModelo(
      id: map['id'] != null ? map['id'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      senha: map['senha'] != null ? map['senha'] as String : null,
      nome: map['nome'] != null ? map['nome'] as String : null,
      token: map['token'] != null ? map['token'] as String : null,
      hcCabeceira: map['hcCabeceira'] as String,
      hcPezeiro: map['hcPezeiro'] as String,
      tipo: map['tipo'] != null ? map['tipo'] as String : null,
      primeiroAcesso: map['primeiroAcesso'] != null ? map['primeiroAcesso'] as String : null,
      cpf: map['cpf'] != null ? map['cpf'] as String : null,
      dataNascimento: map['dataNascimento'] != null ? map['dataNascimento'] as String : null,
      sexo: map['sexo'] != null ? map['sexo'] as String : null,
      rg: map['rg'] != null ? map['rg'] as String : null,
      telefone: map['telefone'] != null ? map['telefone'] as String : null,
      celular: map['celular'] != null ? map['celular'] as String : null,
      cep: map['cep'] != null ? map['cep'] as String : null,
      endereco: map['endereco'] != null ? map['endereco'] as String : null,
      numero: map['numero'] != null ? map['numero'] as String : null,
      bairro: map['bairro'] != null ? map['bairro'] as String : null,
      complemento: map['complemento'] != null ? map['complemento'] as String : null,
      cidade: map['cidade'] != null ? map['cidade'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DadosModelo.fromJson(String source) => DadosModelo.fromMap(json.decode(source) as Map<String, dynamic>);
}
