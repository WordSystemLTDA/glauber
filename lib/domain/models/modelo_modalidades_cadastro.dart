// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ModeloModalidadesCadastro {
  final String id;
  final String nome;

  ModeloModalidadesCadastro({required this.id, required this.nome});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
    };
  }

  factory ModeloModalidadesCadastro.fromMap(Map<String, dynamic> map) {
    return ModeloModalidadesCadastro(
      id: map['id'] as String,
      nome: map['nome'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ModeloModalidadesCadastro.fromJson(String source) => ModeloModalidadesCadastro.fromMap(json.decode(source) as Map<String, dynamic>);
}
