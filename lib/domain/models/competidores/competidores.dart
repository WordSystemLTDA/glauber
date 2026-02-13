import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';

part 'competidores.g.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore: must_be_immutable

class CompetidoresModelo {
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


  CompetidoresModelo copyWith({
    String? id,
    String? nome,
    String? apelido,
    String? nomeCidade,
    String? siglaEstado,
    String? ativo,
    String? idProva,
    ValueGetter<bool?>? jaExistente,
    ValueGetter<String?>? idParceiroTrocado,
    ValueGetter<String?>? celular,
    ValueGetter<String?>? hccabeceira,
    ValueGetter<String?>? hcpezeiro,
  }) {
    return CompetidoresModelo(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      apelido: apelido ?? this.apelido,
      nomeCidade: nomeCidade ?? this.nomeCidade,
      siglaEstado: siglaEstado ?? this.siglaEstado,
      ativo: ativo ?? this.ativo,
      idProva: idProva ?? this.idProva,
      jaExistente: jaExistente != null ? jaExistente() : this.jaExistente,
      idParceiroTrocado: idParceiroTrocado != null ? idParceiroTrocado() : this.idParceiroTrocado,
      celular: celular != null ? celular() : this.celular,
      hccabeceira: hccabeceira != null ? hccabeceira() : this.hccabeceira,
      hcpezeiro: hcpezeiro != null ? hcpezeiro() : this.hcpezeiro,
    );
  }

  Map<String, dynamic> toMap() {
    return {
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
      id: map['id'] ?? '',
      nome: map['nome'] ?? '',
      apelido: map['apelido'] ?? '',
      nomeCidade: map['nomeCidade'] ?? '',
      siglaEstado: map['siglaEstado'] ?? '',
      ativo: map['ativo'] ?? '',
      idProva: map['idProva'] ?? '',
      jaExistente: map['jaExistente'],
      idParceiroTrocado: map['idParceiroTrocado'],
      celular: map['celular'],
      hccabeceira: map['hccabeceira'],
      hcpezeiro: map['hcpezeiro'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CompetidoresModelo.fromJson(String source) => CompetidoresModelo.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CompetidoresModelo(id: $id, nome: $nome, apelido: $apelido, nomeCidade: $nomeCidade, siglaEstado: $siglaEstado, ativo: $ativo, idProva: $idProva, jaExistente: $jaExistente, idParceiroTrocado: $idParceiroTrocado, celular: $celular, hccabeceira: $hccabeceira, hcpezeiro: $hcpezeiro)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is CompetidoresModelo &&
      other.id == id &&
      other.nome == nome &&
      other.apelido == apelido &&
      other.nomeCidade == nomeCidade &&
      other.siglaEstado == siglaEstado &&
      other.ativo == ativo &&
      other.idProva == idProva &&
      other.jaExistente == jaExistente &&
      other.idParceiroTrocado == idParceiroTrocado &&
      other.celular == celular &&
      other.hccabeceira == hccabeceira &&
      other.hcpezeiro == hcpezeiro;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      nome.hashCode ^
      apelido.hashCode ^
      nomeCidade.hashCode ^
      siglaEstado.hashCode ^
      ativo.hashCode ^
      idProva.hashCode ^
      jaExistente.hashCode ^
      idParceiroTrocado.hashCode ^
      celular.hashCode ^
      hccabeceira.hashCode ^
      hcpezeiro.hashCode;
  }
}
