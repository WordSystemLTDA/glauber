// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

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
    required this.tipoDeVenda,
    required this.provas,
    this.temValorFiliacao,
    this.cartao,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
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
      'provas': provas.map((x) => x.toJson()).toList(),
      'cartao': cartao?.toMap(),
    };
  }

  factory FormularioCompraModelo.fromMap(Map<String, dynamic> map) {
    return FormularioCompraModelo(
      idProva: map['idProva'] as String,
      idEmpresa: map['idEmpresa'] as String,
      idEvento: map['idEvento'] as String,
      idFormaPagamento: map['idFormaPagamento'] as String,
      valorIngresso: map['valorIngresso'] as String,
      valorTaxa: map['valorTaxa'] as String,
      valorTaxaCartao: map['valorTaxaCartao'] as String,
      valorDesconto: map['valorDesconto'] as String,
      valorTotal: map['valorTotal'] as String,
      temValorFiliacao: map['temValorFiliacao'] != null ? map['temValorFiliacao'] as String : null,
      tipoDeVenda: map['tipoDeVenda'] as String,
      provas: List<ProvaModelo>.from(
        (map['provas'] as List<dynamic>).map<ProvaModelo>(
          (x) => ProvaModelo.fromJson(x as Map<String, dynamic>),
        ),
      ),
      cartao: map['cartao'] != null ? CartaoModelo.fromMap(map['cartao'] as Map<String, dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory FormularioCompraModelo.fromJson(String source) => FormularioCompraModelo.fromMap(json.decode(source) as Map<String, dynamic>);
}
