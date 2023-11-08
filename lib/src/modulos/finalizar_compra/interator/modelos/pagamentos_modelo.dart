// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PagamentosModelo {
  final String id;
  final String nome;

  PagamentosModelo({required this.id, required this.nome});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
    };
  }

  factory PagamentosModelo.fromMap(Map<String, dynamic> map) {
    return PagamentosModelo(
      id: map['id'] as String,
      nome: map['nome'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PagamentosModelo.fromJson(String source) => PagamentosModelo.fromMap(json.decode(source) as Map<String, dynamic>);
}
