import 'dart:convert';

import 'package:equatable/equatable.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore: must_be_immutable
class CartaoModelo extends Equatable {
  String nomeCartao;
  String numeroCartao;
  String expiracaoCartao;
  String cpfTitularCartao;
  String? codigoSeguracaoCartao;
  String? parcelasCartao;

  CartaoModelo({
    required this.nomeCartao,
    required this.numeroCartao,
    required this.expiracaoCartao,
    required this.cpfTitularCartao,
    this.codigoSeguracaoCartao,
    this.parcelasCartao,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nomeCartao': nomeCartao,
      'numeroCartao': numeroCartao,
      'expiracaoCartao': expiracaoCartao,
      'cpfTitularCartao': cpfTitularCartao,
      'codigoSeguracaoCartao': codigoSeguracaoCartao,
      'parcelasCartao': parcelasCartao,
    };
  }

  factory CartaoModelo.fromMap(Map<String, dynamic> map) {
    return CartaoModelo(
      nomeCartao: map['nomeCartao'] as String,
      numeroCartao: map['numeroCartao'] as String,
      expiracaoCartao: map['expiracaoCartao'] as String,
      cpfTitularCartao: map['cpfTitularCartao'] as String,
      codigoSeguracaoCartao: map['codigoSeguracaoCartao'] != null ? map['codigoSeguracaoCartao'] as String : null,
      parcelasCartao: map['parcelasCartao'] != null ? map['parcelasCartao'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CartaoModelo.fromJson(String source) => CartaoModelo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object?> get props => [
        nomeCartao,
        numeroCartao,
        expiracaoCartao,
        cpfTitularCartao,
        codigoSeguracaoCartao,
        parcelasCartao,
      ];
}
