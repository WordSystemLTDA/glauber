import 'dart:convert';

import 'package:equatable/equatable.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore: must_be_immutable
class CompetidoresModelo extends Equatable {
  String id;
  String nome;
  String apelido;
  String nomeCidade;
  String siglaEstado;
  String ativo;
  String idProva;
  bool? jaExistente;
  String? idParceiroTrocado;
  String? celular;
  String? hccabeceira;
  String? hcpezeiro;

  CompetidoresModelo({
    required this.id,
    required this.nome,
    required this.apelido,
    required this.nomeCidade,
    required this.siglaEstado,
    required this.ativo,
    required this.idProva,
    this.jaExistente,
    this.idParceiroTrocado,
    this.celular,
    this.hccabeceira,
    this.hcpezeiro,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
      'apelido': apelido,
      'nomeCidade': nomeCidade,
      'siglaEstado': siglaEstado,
      'ativo': ativo,
      'idProva': idProva,
      'jaExistente': jaExistente,
      'idParceiroTrocado': idParceiroTrocado,
      'celular': celular,
      'hccabeceira': hccabeceira,
      'hcpezeiro': hcpezeiro,
    };
  }

  factory CompetidoresModelo.fromMap(Map<String, dynamic> map) {
    return CompetidoresModelo(
      id: map['id'] as String,
      nome: map['nome'] as String,
      apelido: map['apelido'] as String,
      nomeCidade: map['nomeCidade'] as String,
      siglaEstado: map['siglaEstado'] as String,
      ativo: map['ativo'] as String,
      idProva: map['idProva'] as String,
      jaExistente: map['jaExistente'] != null ? map['jaExistente'] as bool : null,
      idParceiroTrocado: map['idParceiroTrocado'] != null ? map['idParceiroTrocado'] as String : null,
      celular: map['celular'] != null ? map['celular'] as String : null,
      hccabeceira: map['hccabeceira'] != null ? map['hccabeceira'] as String : null,
      hcpezeiro: map['hcpezeiro'] != null ? map['hcpezeiro'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CompetidoresModelo.fromJson(String source) => CompetidoresModelo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object?> get props => [
        id,
        nome,
        apelido,
        nomeCidade,
        siglaEstado,
      ];
}
