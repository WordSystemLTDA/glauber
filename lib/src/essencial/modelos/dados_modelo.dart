// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DadosModelo {
  final String celularSuporte;
  final String atualizacaoAndroid;
  final String atualizacaoIos;
  final String possuiCadastro2;
  final String possuiCadastro1;
  final String ativoCadastro;

  DadosModelo({
    required this.celularSuporte,
    required this.atualizacaoAndroid,
    required this.atualizacaoIos,
    required this.possuiCadastro2,
    required this.possuiCadastro1,
    required this.ativoCadastro,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'celularSuporte': celularSuporte,
      'atualizacaoAndroid': atualizacaoAndroid,
      'atualizacaoIos': atualizacaoIos,
      'possuiCadastro2': possuiCadastro2,
      'possuiCadastro1': possuiCadastro1,
      'ativoCadastro': ativoCadastro,
    };
  }

  factory DadosModelo.fromMap(Map<String, dynamic> map) {
    return DadosModelo(
      celularSuporte: map['celularSuporte'] as String,
      atualizacaoAndroid: map['atualizacaoAndroid'] as String,
      atualizacaoIos: map['atualizacaoIos'] as String,
      possuiCadastro2: map['possuiCadastro2'] as String,
      possuiCadastro1: map['possuiCadastro1'] as String,
      ativoCadastro: map['ativoCadastro'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory DadosModelo.fromJson(String source) => DadosModelo.fromMap(json.decode(source) as Map<String, dynamic>);
}
