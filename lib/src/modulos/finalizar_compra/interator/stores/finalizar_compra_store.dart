import 'package:flutter/material.dart';
import 'package:glauber/src/modulos/finalizar_compra/interator/estados/finalizar_compra_estado.dart';
import 'package:glauber/src/modulos/finalizar_compra/interator/modelos/formulario_compra_modelo.dart';
import 'package:glauber/src/modulos/finalizar_compra/interator/servicos/finalizar_compra_servico.dart';

class FinalizarCompraStore extends ValueNotifier<FinalizarCompraEstado> {
  final FinalizarCompraServico _servico;

  FinalizarCompraStore(this._servico) : super(FinalizarCompraEstadoInicial());

  void inserir(FormularioCompraModelo dados) async {
    value = Carregando();

    var dadosRetorno = await _servico.inserir(dados);

    if (dadosRetorno.sucesso) {
      value = CompraRealizadaComSucesso(dados: dadosRetorno.dados);
    } else {
      value = ErroAoTentarComprar(erro: Exception(dadosRetorno.mensagem));
    }
  }
}
