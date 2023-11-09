// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class ProvaModelo extends Equatable {
  final String id;
  final String nomeProva;
  final String valor;
  final bool jaComprou;
  String? idCabeceira;

  ProvaModelo({
    required this.id,
    required this.nomeProva,
    required this.valor,
    required this.jaComprou,
    this.idCabeceira,
  });

  @override
  List<Object?> get props => [id, nomeProva, valor, idCabeceira];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nomeProva': nomeProva,
      'valor': valor,
      'jaComprou': jaComprou,
      'idCabeceira': idCabeceira,
    };
  }

  factory ProvaModelo.fromMap(Map<String, dynamic> map) {
    return ProvaModelo(
      id: map['id'] as String,
      nomeProva: map['nomeProva'] as String,
      valor: map['valor'] as String,
      jaComprou: map['jaComprou'] as bool,
      idCabeceira: map['idCabeceira'] != null ? map['idCabeceira'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProvaModelo.fromJson(String source) => ProvaModelo.fromMap(json.decode(source) as Map<String, dynamic>);
}
