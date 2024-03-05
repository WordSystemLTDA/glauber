// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class PermitirCompraModelo extends Equatable {
  final bool liberado;
  final String mensagem;
  final String? rota;
  final String? tituloAcao;
  final String? quantMaximaAvulsa;
  final String? parceirosSelecao;

  const PermitirCompraModelo({
    required this.liberado,
    required this.mensagem,
    this.rota,
    this.tituloAcao,
    this.quantMaximaAvulsa,
    this.parceirosSelecao,
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
      'parceirosSelecao': parceirosSelecao,
    };
  }

  factory PermitirCompraModelo.fromMap(Map<String, dynamic> map) {
    return PermitirCompraModelo(
      liberado: map['liberado'] as bool,
      mensagem: map['mensagem'] as String,
      rota: map['rota'] != null ? map['rota'] as String : null,
      tituloAcao: map['tituloAcao'] != null ? map['tituloAcao'] as String : null,
      quantMaximaAvulsa: map['quantMaximaAvulsa'] != null ? map['quantMaximaAvulsa'] as String : null,
      parceirosSelecao: map['parceirosSelecao'] != null ? map['parceirosSelecao'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PermitirCompraModelo.fromJson(String source) => PermitirCompraModelo.fromMap(json.decode(source) as Map<String, dynamic>);
}
