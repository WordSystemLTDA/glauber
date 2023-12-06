// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class ProvaModelo extends Equatable {
  final String id;
  final String nomeProva;
  final String valor;
  final String hcMinimo;
  final String hcMaximo;
  final bool jaComprou;
  final bool compraLiberada;
  String? idCabeceira;
  String? tempoFaltante;

  ProvaModelo({
    required this.id,
    required this.nomeProva,
    required this.hcMinimo,
    required this.hcMaximo,
    required this.valor,
    required this.jaComprou,
    required this.compraLiberada,
    this.idCabeceira,
    this.tempoFaltante,
  });

  @override
  List<Object?> get props => [id, nomeProva, valor, jaComprou, idCabeceira, tempoFaltante, hcMinimo, hcMaximo, compraLiberada];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nomeProva': nomeProva,
      'valor': valor,
      'hcMinimo': hcMinimo,
      'hcMaximo': hcMaximo,
      'jaComprou': jaComprou,
      'compraLiberada': compraLiberada,
      'idCabeceira': idCabeceira,
      'tempoFaltante': tempoFaltante,
    };
  }

  factory ProvaModelo.fromMap(Map<String, dynamic> map) {
    return ProvaModelo(
      id: map['id'] as String,
      nomeProva: map['nomeProva'] as String,
      valor: map['valor'] as String,
      hcMinimo: map['hcMinimo'] as String,
      hcMaximo: map['hcMaximo'] as String,
      jaComprou: map['jaComprou'] as bool,
      compraLiberada: map['compraLiberada'] as bool,
      idCabeceira: map['idCabeceira'] != null ? map['idCabeceira'] as String : null,
      tempoFaltante: map['tempoFaltante'] != null ? map['tempoFaltante'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProvaModelo.fromJson(String source) => ProvaModelo.fromMap(json.decode(source) as Map<String, dynamic>);
}
