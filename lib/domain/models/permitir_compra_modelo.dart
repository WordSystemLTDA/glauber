// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:provadelaco/domain/models/competidores/competidores.dart';


class PermitirCompraModelo {
  final bool liberado;
  final String mensagem;
  final String? rota;
  final String? tituloAcao;
  final String? quantMaximaAvulsa;
  final String? quantParceiros;
  final String? permVincularParceiro;
  final List<CompetidoresModelo>? competidoresJaSelecionados;
  final String? idCabeceiraInvalido;

  const PermitirCompraModelo({
    required this.liberado,
    required this.mensagem,
    this.rota,
    this.tituloAcao,
    this.quantMaximaAvulsa,
    this.quantParceiros,
    this.permVincularParceiro,
    this.competidoresJaSelecionados,
    this.idCabeceiraInvalido,
  });



  PermitirCompraModelo copyWith({
    bool? liberado,
    String? mensagem,
    ValueGetter<String?>? rota,
    ValueGetter<String?>? tituloAcao,
    ValueGetter<String?>? quantMaximaAvulsa,
    ValueGetter<String?>? quantParceiros,
    ValueGetter<String?>? permVincularParceiro,
    ValueGetter<List<CompetidoresModelo>?>? competidoresJaSelecionados,
    ValueGetter<String?>? idCabeceiraInvalido,
  }) {
    return PermitirCompraModelo(
      liberado: liberado ?? this.liberado,
      mensagem: mensagem ?? this.mensagem,
      rota: rota != null ? rota() : this.rota,
      tituloAcao: tituloAcao != null ? tituloAcao() : this.tituloAcao,
      quantMaximaAvulsa: quantMaximaAvulsa != null ? quantMaximaAvulsa() : this.quantMaximaAvulsa,
      quantParceiros: quantParceiros != null ? quantParceiros() : this.quantParceiros,
      permVincularParceiro: permVincularParceiro != null ? permVincularParceiro() : this.permVincularParceiro,
      competidoresJaSelecionados: competidoresJaSelecionados != null ? competidoresJaSelecionados() : this.competidoresJaSelecionados,
      idCabeceiraInvalido: idCabeceiraInvalido != null ? idCabeceiraInvalido() : this.idCabeceiraInvalido,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'liberado': liberado,
      'mensagem': mensagem,
      'rota': rota,
      'tituloAcao': tituloAcao,
      'quantMaximaAvulsa': quantMaximaAvulsa,
      'quantParceiros': quantParceiros,
      'permVincularParceiro': permVincularParceiro,
      'competidoresJaSelecionados': competidoresJaSelecionados?.map((x) => x?.toMap())?.toList(),
      'idCabeceiraInvalido': idCabeceiraInvalido,
    };
  }

  factory PermitirCompraModelo.fromMap(Map<String, dynamic> map) {
    return PermitirCompraModelo(
      liberado: map['liberado'] ?? false,
      mensagem: map['mensagem'] ?? '',
      rota: map['rota'],
      tituloAcao: map['tituloAcao'],
      quantMaximaAvulsa: map['quantMaximaAvulsa'],
      quantParceiros: map['quantParceiros'],
      permVincularParceiro: map['permVincularParceiro'],
      competidoresJaSelecionados: map['competidoresJaSelecionados'] != null ? List<CompetidoresModelo>.from(map['competidoresJaSelecionados']?.map((x) => CompetidoresModelo.fromMap(x))) : null,
      idCabeceiraInvalido: map['idCabeceiraInvalido'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PermitirCompraModelo.fromJson(String source) => PermitirCompraModelo.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PermitirCompraModelo(liberado: $liberado, mensagem: $mensagem, rota: $rota, tituloAcao: $tituloAcao, quantMaximaAvulsa: $quantMaximaAvulsa, quantParceiros: $quantParceiros, permVincularParceiro: $permVincularParceiro, competidoresJaSelecionados: $competidoresJaSelecionados, idCabeceiraInvalido: $idCabeceiraInvalido)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is PermitirCompraModelo &&
      other.liberado == liberado &&
      other.mensagem == mensagem &&
      other.rota == rota &&
      other.tituloAcao == tituloAcao &&
      other.quantMaximaAvulsa == quantMaximaAvulsa &&
      other.quantParceiros == quantParceiros &&
      other.permVincularParceiro == permVincularParceiro &&
      listEquals(other.competidoresJaSelecionados, competidoresJaSelecionados) &&
      other.idCabeceiraInvalido == idCabeceiraInvalido;
  }

  @override
  int get hashCode {
    return liberado.hashCode ^
      mensagem.hashCode ^
      rota.hashCode ^
      tituloAcao.hashCode ^
      quantMaximaAvulsa.hashCode ^
      quantParceiros.hashCode ^
      permVincularParceiro.hashCode ^
      competidoresJaSelecionados.hashCode ^
      idCabeceiraInvalido.hashCode;
  }
}
