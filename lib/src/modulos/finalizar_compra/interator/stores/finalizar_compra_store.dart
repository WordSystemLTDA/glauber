import 'package:flutter/material.dart';
import 'package:glauber/src/modulos/finalizar_compra/interator/estados/finalizar_compra_estado.dart';
import 'package:glauber/src/modulos/finalizar_compra/interator/modelos/finalizar_compra_modelo.dart';
import 'package:glauber/src/modulos/finalizar_compra/interator/servicos/finalizar_compra_servico.dart';

class FinalizarCompraStore extends ValueNotifier<FinalizarCompraEstado> {
  final FinalizarCompraServico _servico;

  FinalizarCompraStore(this._servico) : super(FinalizarCompraEstadoInicial());

  void inserir(FinalizarCompraModelo dados) async {
    value = Carregando();

    var (sucesso, mensagem) = await _servico.inserir(dados);

    if (sucesso) {
      value = CompraRealizadaComSucesso();
    } else {
      value = ErroAoTentarComprar(erro: Exception(mensagem));
    }
  }
}
