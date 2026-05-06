// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
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
  final bool? podeFazerProva;
  final bool? podeFazerCabeca;
  final bool? podeFazerPezeiro;
  final bool? podeFazerLadoSelecionado;
  final String? motivoProva;
  final String? motivoCabeca;
  final String? motivoPezeiro;
  final String? motivoLadoSelecionado;
  final Map<String, dynamic>? elegibilidade;

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
    this.podeFazerProva,
    this.podeFazerCabeca,
    this.podeFazerPezeiro,
    this.podeFazerLadoSelecionado,
    this.motivoProva,
    this.motivoCabeca,
    this.motivoPezeiro,
    this.motivoLadoSelecionado,
    this.elegibilidade,
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
    bool? podeFazerProva,
    bool? podeFazerCabeca,
    bool? podeFazerPezeiro,
    bool? podeFazerLadoSelecionado,
    ValueGetter<String?>? motivoProva,
    ValueGetter<String?>? motivoCabeca,
    ValueGetter<String?>? motivoPezeiro,
    ValueGetter<String?>? motivoLadoSelecionado,
    ValueGetter<Map<String, dynamic>?>? elegibilidade,
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
      podeFazerProva: podeFazerProva ?? this.podeFazerProva,
      podeFazerCabeca: podeFazerCabeca ?? this.podeFazerCabeca,
      podeFazerPezeiro: podeFazerPezeiro ?? this.podeFazerPezeiro,
      podeFazerLadoSelecionado: podeFazerLadoSelecionado ?? this.podeFazerLadoSelecionado,
      motivoProva: motivoProva != null ? motivoProva() : this.motivoProva,
      motivoCabeca: motivoCabeca != null ? motivoCabeca() : this.motivoCabeca,
      motivoPezeiro: motivoPezeiro != null ? motivoPezeiro() : this.motivoPezeiro,
      motivoLadoSelecionado: motivoLadoSelecionado != null ? motivoLadoSelecionado() : this.motivoLadoSelecionado,
      elegibilidade: elegibilidade != null ? elegibilidade() : this.elegibilidade,
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
      'competidoresJaSelecionados': competidoresJaSelecionados?.map((x) => x.toMap()).toList(),
      'idCabeceiraInvalido': idCabeceiraInvalido,
      'podeFazerProva': podeFazerProva,
      'podeFazerCabeca': podeFazerCabeca,
      'podeFazerPezeiro': podeFazerPezeiro,
      'podeFazerLadoSelecionado': podeFazerLadoSelecionado,
      'motivoProva': motivoProva,
      'motivoCabeca': motivoCabeca,
      'motivoPezeiro': motivoPezeiro,
      'motivoLadoSelecionado': motivoLadoSelecionado,
      'elegibilidade': elegibilidade,
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
      podeFazerProva: map['podeFazerProva'],
      podeFazerCabeca: map['podeFazerCabeca'],
      podeFazerPezeiro: map['podeFazerPezeiro'],
      podeFazerLadoSelecionado: map['podeFazerLadoSelecionado'],
      motivoProva: map['motivoProva'],
      motivoCabeca: map['motivoCabeca'],
      motivoPezeiro: map['motivoPezeiro'],
      motivoLadoSelecionado: map['motivoLadoSelecionado'],
      elegibilidade: map['elegibilidade'] != null ? Map<String, dynamic>.from(map['elegibilidade']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PermitirCompraModelo.fromJson(String source) => PermitirCompraModelo.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PermitirCompraModelo(liberado: $liberado, mensagem: $mensagem, rota: $rota, tituloAcao: $tituloAcao, quantMaximaAvulsa: $quantMaximaAvulsa, quantParceiros: $quantParceiros, permVincularParceiro: $permVincularParceiro, competidoresJaSelecionados: $competidoresJaSelecionados, idCabeceiraInvalido: $idCabeceiraInvalido, podeFazerProva: $podeFazerProva, podeFazerCabeca: $podeFazerCabeca, podeFazerPezeiro: $podeFazerPezeiro, podeFazerLadoSelecionado: $podeFazerLadoSelecionado, motivoProva: $motivoProva, motivoCabeca: $motivoCabeca, motivoPezeiro: $motivoPezeiro, motivoLadoSelecionado: $motivoLadoSelecionado, elegibilidade: $elegibilidade)';
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
        other.idCabeceiraInvalido == idCabeceiraInvalido &&
        other.podeFazerProva == podeFazerProva &&
        other.podeFazerCabeca == podeFazerCabeca &&
        other.podeFazerPezeiro == podeFazerPezeiro &&
        other.podeFazerLadoSelecionado == podeFazerLadoSelecionado &&
        other.motivoProva == motivoProva &&
        other.motivoCabeca == motivoCabeca &&
        other.motivoPezeiro == motivoPezeiro &&
        other.motivoLadoSelecionado == motivoLadoSelecionado &&
        mapEquals(other.elegibilidade, elegibilidade);
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
        idCabeceiraInvalido.hashCode ^
        podeFazerProva.hashCode ^
        podeFazerCabeca.hashCode ^
        podeFazerPezeiro.hashCode ^
        podeFazerLadoSelecionado.hashCode ^
        motivoProva.hashCode ^
        motivoCabeca.hashCode ^
        motivoPezeiro.hashCode ^
        motivoLadoSelecionado.hashCode ^
        elegibilidade.hashCode;
  }
}
