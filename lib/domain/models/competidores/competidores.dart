import 'dart:convert';

import 'package:flutter/widgets.dart';

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
  String? idVincularParceiros;
  String? celular;
  String? hccabeceira;
  String? hcpezeiro;
  String? hccabeceiraParceiro;
  String? hcpezeiroParceiro;
  String? somaDupla;
  String? somatoriProva;
  bool? podeCorrer;
  String? mensagemValidacao;
  List<String>? motivosBloqueio;

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
    this.idVincularParceiros,
    this.celular,
    this.hccabeceira,
    this.hcpezeiro,
    this.hccabeceiraParceiro,
    this.hcpezeiroParceiro,
    this.somaDupla,
    this.somatoriProva,
    this.podeCorrer,
    this.mensagemValidacao,
    this.motivosBloqueio,
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
    ValueGetter<String?>? idVincularParceiros,
    ValueGetter<String?>? celular,
    ValueGetter<String?>? hccabeceira,
    ValueGetter<String?>? hcpezeiro,
    ValueGetter<String?>? hccabeceiraParceiro,
    ValueGetter<String?>? hcpezeiroParceiro,
    ValueGetter<String?>? somaDupla,
    ValueGetter<String?>? somatoriProva,
    ValueGetter<bool?>? podeCorrer,
    ValueGetter<String?>? mensagemValidacao,
    ValueGetter<List<String>?>? motivosBloqueio,
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
      idVincularParceiros: idVincularParceiros != null ? idVincularParceiros() : this.idVincularParceiros,
      celular: celular != null ? celular() : this.celular,
      hccabeceira: hccabeceira != null ? hccabeceira() : this.hccabeceira,
      hcpezeiro: hcpezeiro != null ? hcpezeiro() : this.hcpezeiro,
      hccabeceiraParceiro: hccabeceiraParceiro != null ? hccabeceiraParceiro() : this.hccabeceiraParceiro,
      hcpezeiroParceiro: hcpezeiroParceiro != null ? hcpezeiroParceiro() : this.hcpezeiroParceiro,
      somaDupla: somaDupla != null ? somaDupla() : this.somaDupla,
      somatoriProva: somatoriProva != null ? somatoriProva() : this.somatoriProva,
      podeCorrer: podeCorrer != null ? podeCorrer() : this.podeCorrer,
      mensagemValidacao: mensagemValidacao != null ? mensagemValidacao() : this.mensagemValidacao,
      motivosBloqueio: motivosBloqueio != null ? motivosBloqueio() : this.motivosBloqueio,
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
      'idVincularParceiros': idVincularParceiros,
      'celular': celular,
      'hccabeceira': hccabeceira,
      'hcpezeiro': hcpezeiro,
      'hccabeceiraParceiro': hccabeceiraParceiro,
      'hcpezeiroParceiro': hcpezeiroParceiro,
      'somaDupla': somaDupla,
      'somatoriProva': somatoriProva,
      'podeCorrer': podeCorrer,
      'mensagemValidacao': mensagemValidacao,
      'motivosBloqueio': motivosBloqueio,
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
      idVincularParceiros: map['idVincularParceiros'],
      celular: map['celular'],
      hccabeceira: map['hccabeceira'],
      hcpezeiro: map['hcpezeiro'],
      hccabeceiraParceiro: map['hccabeceiraParceiro'],
      hcpezeiroParceiro: map['hcpezeiroParceiro'],
      somaDupla: map['somaDupla'],
      somatoriProva: map['somatoriProva'],
      podeCorrer: map['podeCorrer'],
      mensagemValidacao: map['mensagemValidacao'],
      motivosBloqueio: map['motivosBloqueio'] != null ? List<String>.from(map['motivosBloqueio']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CompetidoresModelo.fromJson(String source) => CompetidoresModelo.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CompetidoresModelo(id: $id, nome: $nome, apelido: $apelido, nomeCidade: $nomeCidade, siglaEstado: $siglaEstado, ativo: $ativo, idProva: $idProva, jaExistente: $jaExistente, idParceiroTrocado: $idParceiroTrocado, idVincularParceiros: $idVincularParceiros, celular: $celular, hccabeceira: $hccabeceira, hcpezeiro: $hcpezeiro, hccabeceiraParceiro: $hccabeceiraParceiro, hcpezeiroParceiro: $hcpezeiroParceiro, somaDupla: $somaDupla, somatoriProva: $somatoriProva, podeCorrer: $podeCorrer, mensagemValidacao: $mensagemValidacao, motivosBloqueio: $motivosBloqueio)';
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
        other.idVincularParceiros == idVincularParceiros &&
        other.celular == celular &&
        other.hccabeceira == hccabeceira &&
        other.hcpezeiro == hcpezeiro &&
        other.hccabeceiraParceiro == hccabeceiraParceiro &&
        other.hcpezeiroParceiro == hcpezeiroParceiro &&
        other.somaDupla == somaDupla &&
        other.somatoriProva == somatoriProva &&
        other.podeCorrer == podeCorrer &&
        other.mensagemValidacao == mensagemValidacao &&
        other.motivosBloqueio == motivosBloqueio;
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
        idVincularParceiros.hashCode ^
        celular.hashCode ^
        hccabeceira.hashCode ^
        hcpezeiro.hashCode ^
        hccabeceiraParceiro.hashCode ^
        hcpezeiroParceiro.hashCode ^
        somaDupla.hashCode ^
        somatoriProva.hashCode ^
        podeCorrer.hashCode ^
        mensagemValidacao.hashCode ^
        motivosBloqueio.hashCode;
  }
}
