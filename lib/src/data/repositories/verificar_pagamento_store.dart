import 'package:flutter/material.dart';
import 'package:provadelaco/src/data/servicos/verificar_pagamento_servico_impl.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/estados/verificar_pagamento_estado.dart';

class VerificarPagamentoStore extends ValueNotifier<VerificarPagamentoEstado> {
  final VerificarPagamentoServicoImpl _servico;

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
