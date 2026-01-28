// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ModeloBannersCarrossel {
  final String foto;
  final String datadecadastro;
  final String horadecadastro;

  ModeloBannersCarrossel({required this.foto, required this.datadecadastro, required this.horadecadastro});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'foto': foto,
      'datadecadastro': datadecadastro,
      'horadecadastro': horadecadastro,
    };
  }

  factory ModeloBannersCarrossel.fromMap(Map<String, dynamic> map) {
    return ModeloBannersCarrossel(
      foto: map['foto'] as String,
      datadecadastro: map['datadecadastro'] as String,
      horadecadastro: map['horadecadastro'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ModeloBannersCarrossel.fromJson(String source) => ModeloBannersCarrossel.fromMap(json.decode(source) as Map<String, dynamic>);
}
