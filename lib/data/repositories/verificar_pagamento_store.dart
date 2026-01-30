import 'package:flutter/material.dart';
import 'package:provadelaco/data/servicos/verificar_pagamento_servico.dart';

class VerificarPagamentoStore extends ChangeNotifier {
  final VerificarPagamentoServico _servico;

  VerificarPagamentoStore(this._servico) : super();

  bool carregando = false;

  Future<({bool sucesso})> verificarPagamento(String idVenda, String idFormaPagamento) async {
    carregando = true;
    notifyListeners();

    var (:sucesso) = await _servico.verificarPagamento(idVenda, idFormaPagamento);

    carregando = false;
    notifyListeners();

    return (sucesso: sucesso);
  }
}
