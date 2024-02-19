// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:provadelaco/src/modulos/finalizar_compra/interator/modelos/cartao_modelo.dart';

class FormularioEditarCompraModelo {
  final String idProva;
  final String idEmpresa;
  final String idEvento;
  final String idVenda;
  final String idFormaPagamento;
  final CartaoModelo? cartao;

  FormularioEditarCompraModelo({
    required this.idProva,
    required this.idEmpresa,
    required this.idEvento,
    required this.idVenda,
    required this.idFormaPagamento,
    this.cartao,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idProva': idProva,
      'idEmpresa': idEmpresa,
      'idEvento': idEvento,
      'idVenda': idVenda,
      'idFormaPagamento': idFormaPagamento,
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
      cartao: map['cartao'] != null ? CartaoModelo.fromMap(map['cartao'] as Map<String, dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory FormularioEditarCompraModelo.fromJson(String source) => FormularioEditarCompraModelo.fromMap(json.decode(source) as Map<String, dynamic>);
}
