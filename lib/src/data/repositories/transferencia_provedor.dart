import 'package:flutter/material.dart';
import 'package:provadelaco/src/data/servicos/compras_servico_impl.dart';

import 'package:provadelaco/src/modulos/compras/interator/estados/transferencia_estado.dart';
import 'package:provadelaco/src/domain/models/compras_modelo.dart';

class TransferenciaProvedor extends ValueNotifier<TransferenciaEstado> {
  final ComprasServicoImpl _comprasServico;

  TransferenciaProvedor(this._comprasServico) : super(TransferenciaEstadoInicial());

  void transferirCompras(List<ComprasModelo> comprasTransferencia, String novoCliente) async {
    value = Transferindo();

    var resposta = await _comprasServico.transferirCompras(comprasTransferencia, novoCliente);

    var (sucesso, mensagem) = resposta;

    if (sucesso) {
      value = TransferidoComSucesso(mensagem: mensagem);
    } else {
      value = ErroAoTransferir(erro: Exception(mensagem));
    }
  }
}
