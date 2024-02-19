// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:provadelaco/src/modulos/finalizar_compra/interator/modelos/cartao_modelo.dart';
import 'package:provadelaco/src/modulos/provas/interator/modelos/prova_modelo.dart';

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
  final String tipoDeVenda;
  final List<ProvaModelo> provas;
  final String? temValorFiliacao;
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
      'tipoDeVenda': tipoDeVenda,
      'provas': provas.map((x) => x.toMap()).toList(),
      'temValorFiliacao': temValorFiliacao,
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
      tipoDeVenda: map['tipoDeVenda'] as String,
      provas: List<ProvaModelo>.from(
        (map['provas'] as List<dynamic>).map<ProvaModelo>(
          (x) => ProvaModelo.fromMap(x as Map<String, dynamic>),
        ),
      ),
      temValorFiliacao: map['temValorFiliacao'] != null ? map['temValorFiliacao'] as String : null,
      cartao: map['cartao'] != null ? CartaoModelo.fromMap(map['cartao'] as Map<String, dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory FormularioCompraModelo.fromJson(String source) => FormularioCompraModelo.fromMap(json.decode(source) as Map<String, dynamic>);
}
