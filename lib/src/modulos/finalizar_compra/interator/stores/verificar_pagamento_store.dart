import 'package:flutter/material.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/estados/verificar_pagamento_estado.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/servicos/verificar_pagamento_servico.dart';

class VerificarPagamentoStore extends ValueNotifier<VerificarPagamentoEstado> {
  final VerificarPagamentoServico _servico;

  VerificarPagamentoStore(this._servico) : super(VerificarPagamentoEstadoInicial());

  void verificarPagamento(String idVenda, String idFormaPagamento) async {
    value = Verificando();

    var sucesso = await _servico.verificarPagamento(idVenda, idFormaPagamento);

    if (sucesso) {
      value = SucessoAoVerificar();
    } else {
      value = ErroAoVerificar(erro: Exception('Erro ao verificar'));
    }
  }
}
