// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:provadelaco/src/modulos/finalizar_compra/interator/modelos/cartao_modelo.dart';
import 'package:provadelaco/src/modulos/provas/interator/modelos/prova_modelo.dart';

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
  final String tipoDeVenda;
  final List<ProvaModelo> provas;
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
    required this.tipoDeVenda,
    required this.provas,
    this.cartao,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
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
      'tipoDeVenda': tipoDeVenda,
      'provas': provas.map((x) => x.toMap()).toList(),
      'cartao': cartao?.toMap(),
    };
  }

  factory FormularioEditarCompraModelo.fromMap(Map<String, dynamic> map) {
    return FormularioEditarCompraModelo(
      idProva: map['idProva'] as String,
      idEmpresa: map['idEmpresa'] as String,
      idEvento: map['idEvento'] as String,
      idVenda: map['idVenda'] as String,
      idFormaPagamento: map['idFormaPagamento'] as String,
      valorIngresso: map['valorIngresso'] as String,
      valorTaxa: map['valorTaxa'] as String,
      valorTaxaCartao: map['valorTaxaCartao'] as String,
      valorDesconto: map['valorDesconto'] as String,
      valorTotal: map['valorTotal'] as String,
      tipoDeVenda: map['tipoDeVenda'] as String,
      provas: List<ProvaModelo>.from(
        (map['provas'] as List<int>).map<ProvaModelo>(
          (x) => ProvaModelo.fromMap(x as Map<String, dynamic>),
        ),
      ),
      cartao: map['cartao'] != null ? CartaoModelo.fromMap(map['cartao'] as Map<String, dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory FormularioEditarCompraModelo.fromJson(String source) => FormularioEditarCompraModelo.fromMap(json.decode(source) as Map<String, dynamic>);
}
