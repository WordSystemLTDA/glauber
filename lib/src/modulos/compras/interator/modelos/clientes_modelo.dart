// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ClientesModelo {
  final String id;
  final String nome;
  final String apelido;

  ClientesModelo({required this.id, required this.nome, required this.apelido});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
      'apelido': apelido,
    };
  }

  factory ClientesModelo.fromMap(Map<String, dynamic> map) {
    return ClientesModelo(
      id: map['id'] as String,
      nome: map['nome'] as String,
      apelido: map['apelido'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ClientesModelo.fromJson(String source) => ClientesModelo.fromMap(json.decode(source) as Map<String, dynamic>);
}
