// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class HandiCapsModelos {
  final String id;
  final String valor;
  final String nome;

  HandiCapsModelos({required this.id, required this.valor, required this.nome});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'valor': valor,
      'nome': nome,
    };
  }

  factory HandiCapsModelos.fromMap(Map<String, dynamic> map) {
    return HandiCapsModelos(
      id: map['id'] as String,
      valor: map['valor'] as String,
      nome: map['nome'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory HandiCapsModelos.fromJson(String source) => HandiCapsModelos.fromMap(json.decode(source) as Map<String, dynamic>);
}
