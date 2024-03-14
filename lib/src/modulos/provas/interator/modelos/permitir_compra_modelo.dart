// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:provadelaco/src/modulos/provas/interator/modelos/competidores_modelo2.dart';

class PermitirCompraModelo extends Equatable {
  final bool liberado;
  final String mensagem;
  final String? rota;
  final String? tituloAcao;
  final String? quantMaximaAvulsa;
  final String? quantParceiros;
  final String? permVincularParceiro;
  final List<CompetidoresModelo2>? competidoresJaSelecionados;
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

  @override
  List<Object?> get props => [liberado, mensagem, rota, tituloAcao];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'liberado': liberado,
      'mensagem': mensagem,
      'rota': rota,
      'tituloAcao': tituloAcao,
      'quantMaximaAvulsa': quantMaximaAvulsa,
      'quantParceiros': quantParceiros,
      'permVincularParceiro': permVincularParceiro,
      'competidoresJaSelecionados': competidoresJaSelecionados?.map((x) => x.toMap()).toList(),
      'idCabeceiraInvalido': idCabeceiraInvalido,
    };
  }

  factory PermitirCompraModelo.fromMap(Map<String, dynamic> map) {
    return PermitirCompraModelo(
      liberado: map['liberado'] as bool,
      mensagem: map['mensagem'] as String,
      rota: map['rota'] != null ? map['rota'] as String : null,
      tituloAcao: map['tituloAcao'] != null ? map['tituloAcao'] as String : null,
      quantMaximaAvulsa: map['quantMaximaAvulsa'] != null ? map['quantMaximaAvulsa'] as String : null,
      quantParceiros: map['quantParceiros'] != null ? map['quantParceiros'] as String : null,
      permVincularParceiro: map['permVincularParceiro'] != null ? map['permVincularParceiro'] as String : null,
      competidoresJaSelecionados: map['competidoresJaSelecionados'] != null
          ? List<CompetidoresModelo2>.from(
              (map['competidoresJaSelecionados'] as List<dynamic>).map<CompetidoresModelo2?>(
                (x) => CompetidoresModelo2.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      idCabeceiraInvalido: map['idCabeceiraInvalido'] != null ? map['idCabeceiraInvalido'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PermitirCompraModelo.fromJson(String source) => PermitirCompraModelo.fromMap(json.decode(source) as Map<String, dynamic>);
}
