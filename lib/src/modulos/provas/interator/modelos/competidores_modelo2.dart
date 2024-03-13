import 'dart:convert';

import 'package:equatable/equatable.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore: must_be_immutable
class CompetidoresModelo2 extends Equatable {
  String id;
  String nome;
  String apelido;
  String nomeCidade;
  String siglaEstado;
  String ativo;
  bool jaExistente;

  CompetidoresModelo2({
    required this.id,
    required this.nome,
    required this.apelido,
    required this.nomeCidade,
    required this.siglaEstado,
    required this.ativo,
    required this.jaExistente,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
      'apelido': apelido,
      'nomeCidade': nomeCidade,
      'siglaEstado': siglaEstado,
      'ativo': ativo,
      'jaExistente': jaExistente,
    };
  }

  factory CompetidoresModelo2.fromMap(Map<String, dynamic> map) {
    return CompetidoresModelo2(
      id: map['id'] as String,
      nome: map['nome'] as String,
      apelido: map['apelido'] as String,
      nomeCidade: map['nomeCidade'] as String,
      siglaEstado: map['siglaEstado'] as String,
      ativo: map['ativo'] as String,
      jaExistente: map['jaExistente'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory CompetidoresModelo2.fromJson(String source) => CompetidoresModelo2.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object?> get props => [
        id,
        nome,
        apelido,
        nomeCidade,
        siglaEstado,
      ];
}
