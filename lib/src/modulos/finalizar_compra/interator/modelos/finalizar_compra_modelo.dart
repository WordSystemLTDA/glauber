// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class FinalizarCompraModelo {
  final String idProva;
  final String idEmpresa;
  final String idFormaPagamento;
  final String valorIngresso;
  final String valorTaxa;
  final String valorDesconto;
  final String valorTotal;
  final String tipoDeVenda;

  FinalizarCompraModelo({
    required this.idProva,
    required this.idEmpresa,
    required this.idFormaPagamento,
    required this.valorIngresso,
    required this.valorTaxa,
    required this.valorDesconto,
    required this.valorTotal,
    required this.tipoDeVenda,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idProva': idProva,
      'idEmpresa': idEmpresa,
      'idFormaPagamento': idFormaPagamento,
      'valorIngresso': valorIngresso,
      'valorTaxa': valorTaxa,
      'valorDesconto': valorDesconto,
      'valorTotal': valorTotal,
      'tipoDeVenda': tipoDeVenda,
    };
  }

  factory FinalizarCompraModelo.fromMap(Map<String, dynamic> map) {
    return FinalizarCompraModelo(
      idProva: map['idProva'] as String,
      idEmpresa: map['idEmpresa'] as String,
      idFormaPagamento: map['idFormaPagamento'] as String,
      valorIngresso: map['valorIngresso'] as String,
      valorTaxa: map['valorTaxa'] as String,
      valorDesconto: map['valorDesconto'] as String,
      valorTotal: map['valorTotal'] as String,
      tipoDeVenda: map['tipoDeVenda'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory FinalizarCompraModelo.fromJson(String source) => FinalizarCompraModelo.fromMap(json.decode(source) as Map<String, dynamic>);
}
