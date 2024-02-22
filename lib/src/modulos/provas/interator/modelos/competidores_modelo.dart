import 'dart:convert';

import 'package:equatable/equatable.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore: must_be_immutable
class CompetidoresModelo extends Equatable {
  String id;
  String nome;
  String apelido;

  CompetidoresModelo({
    required this.id,
    required this.nome,
    required this.apelido,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
      'apelido': apelido,
    };
  }

  factory CompetidoresModelo.fromMap(Map<String, dynamic> map) {
    return CompetidoresModelo(
      id: map['id'] as String,
      nome: map['nome'] as String,
      apelido: map['apelido'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CompetidoresModelo.fromJson(String source) => CompetidoresModelo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object?> get props => [
        id,
        nome,
        apelido,
      ];
}
