// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:provadelaco/domain/models/cartao/cartao.dart';
import 'package:provadelaco/domain/models/prova/prova.dart';

class FormularioCompraModelo {
  final String idProva;
  final String idEmpresa;
  final String idEvento;
  final String idFormaPagamento;
  final String valorIngresso;
  final String valorTaxa;
  final String valorTaxaCartao;
  final String valorDesconto;
  final String valorTotal;
  final String? temValorFiliacao;
  final String tipoDeVenda;
  final List<ProvaModelo> provas;
  final CartaoModelo? cartao;

  FormularioCompraModelo({
    required this.idProva,
    required this.idEmpresa,
    required this.idEvento,
    required this.idFormaPagamento,
    required this.valorIngresso,
    required this.valorTaxa,
    required this.valorTaxaCartao,
    required this.valorDesconto,
    required this.valorTotal,
    this.temValorFiliacao,
    required this.tipoDeVenda,
    required this.provas,
    this.cartao,
  });

  Map<String, dynamic> toMap() {
    return {
      'idProva': idProva,
      'idEmpresa': idEmpresa,
      'idEvento': idEvento,
      'idFormaPagamento': idFormaPagamento,
      'valorIngresso': valorIngresso,
      'valorTaxa': valorTaxa,
      'valorTaxaCartao': valorTaxaCartao,
      'valorDesconto': valorDesconto,
      'valorTotal': valorTotal,
      'temValorFiliacao': temValorFiliacao,
      'tipoDeVenda': tipoDeVenda,
      'provas': provas.map((x) => x.toMap()).toList(),
      'cartao': cartao?.toMap(),
    };
  }

  factory FormularioCompraModelo.fromMap(Map<String, dynamic> map) {
    return FormularioCompraModelo(
      idProva: map['idProva'] ?? '',
      idEmpresa: map['idEmpresa'] ?? '',
      idEvento: map['idEvento'] ?? '',
      idFormaPagamento: map['idFormaPagamento'] ?? '',
      valorIngresso: map['valorIngresso'] ?? '',
      valorTaxa: map['valorTaxa'] ?? '',
      valorTaxaCartao: map['valorTaxaCartao'] ?? '',
      valorDesconto: map['valorDesconto'] ?? '',
      valorTotal: map['valorTotal'] ?? '',
      temValorFiliacao: map['temValorFiliacao'],
      tipoDeVenda: map['tipoDeVenda'] ?? '',
      provas: List<ProvaModelo>.from(map['provas']?.map((x) => ProvaModelo.fromMap(x))),
      cartao: map['cartao'] != null ? CartaoModelo.fromMap(map['cartao']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory FormularioCompraModelo.fromJson(String source) => FormularioCompraModelo.fromMap(json.decode(source));

  FormularioCompraModelo copyWith({
    String? idProva,
    String? idEmpresa,
    String? idEvento,
    String? idFormaPagamento,
    String? valorIngresso,
    String? valorTaxa,
    String? valorTaxaCartao,
    String? valorDesconto,
    String? valorTotal,
    ValueGetter<String?>? temValorFiliacao,
    String? tipoDeVenda,
    List<ProvaModelo>? provas,
    ValueGetter<CartaoModelo?>? cartao,
  }) {
    return FormularioCompraModelo(
      idProva: idProva ?? this.idProva,
      idEmpresa: idEmpresa ?? this.idEmpresa,
      idEvento: idEvento ?? this.idEvento,
      idFormaPagamento: idFormaPagamento ?? this.idFormaPagamento,
      valorIngresso: valorIngresso ?? this.valorIngresso,
      valorTaxa: valorTaxa ?? this.valorTaxa,
      valorTaxaCartao: valorTaxaCartao ?? this.valorTaxaCartao,
      valorDesconto: valorDesconto ?? this.valorDesconto,
      valorTotal: valorTotal ?? this.valorTotal,
      temValorFiliacao: temValorFiliacao != null ? temValorFiliacao() : this.temValorFiliacao,
      tipoDeVenda: tipoDeVenda ?? this.tipoDeVenda,
      provas: provas ?? this.provas,
      cartao: cartao != null ? cartao() : this.cartao,
    );
  }

  @override
  String toString() {
    return 'FormularioCompraModelo(idProva: $idProva, idEmpresa: $idEmpresa, idEvento: $idEvento, idFormaPagamento: $idFormaPagamento, valorIngresso: $valorIngresso, valorTaxa: $valorTaxa, valorTaxaCartao: $valorTaxaCartao, valorDesconto: $valorDesconto, valorTotal: $valorTotal, temValorFiliacao: $temValorFiliacao, tipoDeVenda: $tipoDeVenda, provas: $provas, cartao: $cartao)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is FormularioCompraModelo &&
      other.idProva == idProva &&
      other.idEmpresa == idEmpresa &&
      other.idEvento == idEvento &&
      other.idFormaPagamento == idFormaPagamento &&
      other.valorIngresso == valorIngresso &&
      other.valorTaxa == valorTaxa &&
      other.valorTaxaCartao == valorTaxaCartao &&
      other.valorDesconto == valorDesconto &&
      other.valorTotal == valorTotal &&
      other.temValorFiliacao == temValorFiliacao &&
      other.tipoDeVenda == tipoDeVenda &&
      listEquals(other.provas, provas) &&
      other.cartao == cartao;
  }

  @override
  int get hashCode {
    return idProva.hashCode ^
      idEmpresa.hashCode ^
      idEvento.hashCode ^
      idFormaPagamento.hashCode ^
      valorIngresso.hashCode ^
      valorTaxa.hashCode ^
      valorTaxaCartao.hashCode ^
      valorDesconto.hashCode ^
      valorTotal.hashCode ^
      temValorFiliacao.hashCode ^
      tipoDeVenda.hashCode ^
      provas.hashCode ^
      cartao.hashCode;
  }
}
