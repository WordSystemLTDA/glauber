// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:provadelaco/src/modulos/provas/interator/modelos/prova_modelo.dart';

class FormularioCompraModelo {
  final String idProva;
  final String idEmpresa;
  final String idEvento;
  final String idFormaPagamento;
  final String valorIngresso;
  final String valorTaxa;
  final String valorDesconto;
  final String valorTotal;
  final String tipoDeVenda;
  final List<ProvaModelo> provas;

  FormularioCompraModelo({
    required this.idProva,
    required this.idEmpresa,
    required this.idEvento,
    required this.idFormaPagamento,
    required this.valorIngresso,
    required this.valorTaxa,
    required this.valorDesconto,
    required this.valorTotal,
    required this.tipoDeVenda,
    required this.provas,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idProva': idProva,
      'idEmpresa': idEmpresa,
      'idEvento': idEvento,
      'idFormaPagamento': idFormaPagamento,
      'valorIngresso': valorIngresso,
      'valorTaxa': valorTaxa,
      'valorDesconto': valorDesconto,
      'valorTotal': valorTotal,
      'tipoDeVenda': tipoDeVenda,
      'provas': provas.map((x) => x.toMap()).toList(),
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
      valorDesconto: map['valorDesconto'] as String,
      valorTotal: map['valorTotal'] as String,
      tipoDeVenda: map['tipoDeVenda'] as String,
      provas: List<ProvaModelo>.from(
        (map['provas'] as List<int>).map<ProvaModelo>(
          (x) => ProvaModelo.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory FormularioCompraModelo.fromJson(String source) => FormularioCompraModelo.fromMap(json.decode(source) as Map<String, dynamic>);
}
