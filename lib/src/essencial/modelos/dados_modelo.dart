// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DadosModelo {
  final String celularSuporte;
  final String atualizacaoAndroid;
  final String atualizacaoIos;

  DadosModelo({
    required this.celularSuporte,
    required this.atualizacaoAndroid,
    required this.atualizacaoIos,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'celularSuporte': celularSuporte,
      'atualizacaoAndroid': atualizacaoAndroid,
      'atualizacaoIos': atualizacaoIos,
    };
  }

  factory DadosModelo.fromMap(Map<String, dynamic> map) {
    return DadosModelo(
      celularSuporte: map['celularSuporte'] as String,
      atualizacaoAndroid: map['atualizacaoAndroid'] as String,
      atualizacaoIos: map['atualizacaoIos'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory DadosModelo.fromJson(String source) => DadosModelo.fromMap(json.decode(source) as Map<String, dynamic>);
}
