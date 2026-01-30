// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CategoriaModelo {
  final String id;
  final String nome;

  CategoriaModelo({required this.id, required this.nome});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
    };
  }

  factory CategoriaModelo.fromMap(Map<String, dynamic> map) {
    return CategoriaModelo(
      id: map['id'] as String,
      nome: map['nome'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoriaModelo.fromJson(String source) => CategoriaModelo.fromMap(json.decode(source) as Map<String, dynamic>);
}
