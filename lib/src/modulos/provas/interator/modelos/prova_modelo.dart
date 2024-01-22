// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:provadelaco/src/modulos/provas/interator/modelos/permitir_compra_modelo.dart';

// ignore: must_be_immutable
class ProvaModelo extends Equatable {
  final String id;
  final String nomeProva;
  final String valor;
  final String hcMinimo;
  final String hcMaximo;
  final PermitirCompraModelo permitirCompra;

  String? nomeCabeceira;
  String? idCabeceira;

  ProvaModelo({
    required this.id,
    required this.nomeProva,
    required this.hcMinimo,
    required this.hcMaximo,
    required this.valor,
    required this.permitirCompra,
    this.nomeCabeceira,
    this.idCabeceira,
  });

  @override
  List<Object?> get props => [id, nomeProva, valor, permitirCompra, idCabeceira, hcMinimo, hcMaximo, nomeCabeceira];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nomeProva': nomeProva,
      'valor': valor,
      'hcMinimo': hcMinimo,
      'hcMaximo': hcMaximo,
      'permitirCompra': permitirCompra.toMap(),
      'nomeCabeceira': nomeCabeceira,
      'idCabeceira': idCabeceira,
    };
  }

  factory ProvaModelo.fromMap(Map<String, dynamic> map) {
    return ProvaModelo(
      id: map['id'] as String,
      nomeProva: map['nomeProva'] as String,
      valor: map['valor'] as String,
      hcMinimo: map['hcMinimo'] as String,
      hcMaximo: map['hcMaximo'] as String,
      permitirCompra: PermitirCompraModelo.fromMap(map['permitirCompra'] as Map<String, dynamic>),
      nomeCabeceira: map['nomeCabeceira'] != null ? map['nomeCabeceira'] as String : null,
      idCabeceira: map['idCabeceira'] != null ? map['idCabeceira'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProvaModelo.fromJson(String source) => ProvaModelo.fromMap(json.decode(source) as Map<String, dynamic>);
}
