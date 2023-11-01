import 'package:flutter/material.dart';
import 'package:glauber/src/modulos/finalizar_compra/interator/estados/finalizar_compra_estado.dart';
import 'package:glauber/src/modulos/finalizar_compra/interator/modelos/finalizar_compra_modelo.dart';
import 'package:glauber/src/modulos/finalizar_compra/interator/servicos/finalizar_compra_servico.dart';

class FinalizarCompraStore extends ValueNotifier<FinalizarCompraEstado> {
  final FinalizarCompraServico _servico;

  FinalizarCompraStore(this._servico) : super(FinalizarCompraEstadoInicial());

  void inserir() async {
    value = Carregando();

    bool sucesso = await _servico.inserir(FinalizarCompraModelo(
      idProva: "1",
      idFormaPagamento: "1",
      valorIngresso: "10",
      valorTaxa: "0",
      valorDesconto: "0",
      valorTotal: "10",
      txid: "",
      codigoPix: "codigoPIX",
      tipoDeVenda: "Venda",
    ));

    if (sucesso) {
      value = CompraRealizada();
    } else {
      value = ErroAoTentarComprar(erro: Exception('Erro ao tentar comprar.'));
    }
  }
}
