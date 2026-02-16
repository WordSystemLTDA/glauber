// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/widgets.dart';

import 'package:provadelaco/domain/models/cartao/cartao.dart';

class FormularioEditarCompraModelo {
  final String idProva;
  final String idEmpresa;
  final String idEvento;
  final String idVenda;
  final String idFormaPagamento;
  final String valorIngresso;
  final String valorTaxa;
  final String valorTaxaCartao;
  final String valorDesconto;
  final String valorTotal;
  final String? temValorFiliacao;
  final String? filiacaoJaPaga;
  final int? parcelasFiliacao;
  final CartaoModelo? cartao;

  FormularioEditarCompraModelo({
    required this.idProva,
    required this.idEmpresa,
    required this.idEvento,
    required this.idVenda,
    required this.idFormaPagamento,
    required this.valorIngresso,
    required this.valorTaxa,
    required this.valorTaxaCartao,
    required this.valorDesconto,
    required this.valorTotal,
    this.temValorFiliacao,
    this.filiacaoJaPaga,
    this.parcelasFiliacao,
    this.cartao,
  });

  Map<String, dynamic> toMap() {
    return {
      'idProva': idProva,
      'idEmpresa': idEmpresa,
      'idEvento': idEvento,
      'idVenda': idVenda,
      'idFormaPagamento': idFormaPagamento,
      'valorIngresso': valorIngresso,
      'valorTaxa': valorTaxa,
      'valorTaxaCartao': valorTaxaCartao,
      'valorDesconto': valorDesconto,
      'valorTotal': valorTotal,
      'temValorFiliacao': temValorFiliacao,
      'filiacaoJaPaga': filiacaoJaPaga,
      'parcelasFiliacao': parcelasFiliacao,
      'cartao': cartao?.toMap(),
    };
  }

  factory FormularioEditarCompraModelo.fromMap(Map<String, dynamic> map) {
    return FormularioEditarCompraModelo(
      idProva: map['idProva'] ?? '',
      idEmpresa: map['idEmpresa'] ?? '',
      idEvento: map['idEvento'] ?? '',
      idVenda: map['idVenda'] ?? '',
      idFormaPagamento: map['idFormaPagamento'] ?? '',
      valorIngresso: map['valorIngresso'] ?? '',
      valorTaxa: map['valorTaxa'] ?? '',
      valorTaxaCartao: map['valorTaxaCartao'] ?? '',
      valorDesconto: map['valorDesconto'] ?? '',
      valorTotal: map['valorTotal'] ?? '',
      temValorFiliacao: map['temValorFiliacao'],
      filiacaoJaPaga: map['filiacaoJaPaga'],
      parcelasFiliacao: map['parcelasFiliacao']?.toInt(),
      cartao: map['cartao'] != null ? CartaoModelo.fromMap(map['cartao']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory FormularioEditarCompraModelo.fromJson(String source) => FormularioEditarCompraModelo.fromMap(json.decode(source));

  FormularioEditarCompraModelo copyWith({
    String? idProva,
    String? idEmpresa,
    String? idEvento,
    String? idVenda,
    String? idFormaPagamento,
    String? valorIngresso,
    String? valorTaxa,
    String? valorTaxaCartao,
    String? valorDesconto,
    String? valorTotal,
    ValueGetter<String?>? temValorFiliacao,
    ValueGetter<String?>? filiacaoJaPaga,
    ValueGetter<int?>? parcelasFiliacao,
    ValueGetter<CartaoModelo?>? cartao,
  }) {
    return FormularioEditarCompraModelo(
      idProva: idProva ?? this.idProva,
      idEmpresa: idEmpresa ?? this.idEmpresa,
      idEvento: idEvento ?? this.idEvento,
      idVenda: idVenda ?? this.idVenda,
      idFormaPagamento: idFormaPagamento ?? this.idFormaPagamento,
      valorIngresso: valorIngresso ?? this.valorIngresso,
      valorTaxa: valorTaxa ?? this.valorTaxa,
      valorTaxaCartao: valorTaxaCartao ?? this.valorTaxaCartao,
      valorDesconto: valorDesconto ?? this.valorDesconto,
      valorTotal: valorTotal ?? this.valorTotal,
      temValorFiliacao: temValorFiliacao != null ? temValorFiliacao() : this.temValorFiliacao,
      filiacaoJaPaga: filiacaoJaPaga != null ? filiacaoJaPaga() : this.filiacaoJaPaga,
      parcelasFiliacao: parcelasFiliacao != null ? parcelasFiliacao() : this.parcelasFiliacao,
      cartao: cartao != null ? cartao() : this.cartao,
    );
  }

  @override
  String toString() {
    return 'FormularioEditarCompraModelo(idProva: $idProva, idEmpresa: $idEmpresa, idEvento: $idEvento, idVenda: $idVenda, idFormaPagamento: $idFormaPagamento, valorIngresso: $valorIngresso, valorTaxa: $valorTaxa, valorTaxaCartao: $valorTaxaCartao, valorDesconto: $valorDesconto, valorTotal: $valorTotal, temValorFiliacao: $temValorFiliacao, filiacaoJaPaga: $filiacaoJaPaga, parcelasFiliacao: $parcelasFiliacao, cartao: $cartao)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is FormularioEditarCompraModelo &&
      other.idProva == idProva &&
      other.idEmpresa == idEmpresa &&
      other.idEvento == idEvento &&
      other.idVenda == idVenda &&
      other.idFormaPagamento == idFormaPagamento &&
      other.valorIngresso == valorIngresso &&
      other.valorTaxa == valorTaxa &&
      other.valorTaxaCartao == valorTaxaCartao &&
      other.valorDesconto == valorDesconto &&
      other.valorTotal == valorTotal &&
      other.temValorFiliacao == temValorFiliacao &&
      other.filiacaoJaPaga == filiacaoJaPaga &&
      other.parcelasFiliacao == parcelasFiliacao &&
      other.cartao == cartao;
  }

  @override
  int get hashCode {
    return idProva.hashCode ^
      idEmpresa.hashCode ^
      idEvento.hashCode ^
      idVenda.hashCode ^
      idFormaPagamento.hashCode ^
      valorIngresso.hashCode ^
      valorTaxa.hashCode ^
      valorTaxaCartao.hashCode ^
      valorDesconto.hashCode ^
      valorTotal.hashCode ^
      temValorFiliacao.hashCode ^
      filiacaoJaPaga.hashCode ^
      parcelasFiliacao.hashCode ^
      cartao.hashCode;
  }
}
