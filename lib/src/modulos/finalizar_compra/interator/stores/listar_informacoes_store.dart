import 'package:flutter/material.dart';
import 'package:glauber/src/modulos/finalizar_compra/interator/estados/listar_informacoes_estado.dart';
import 'package:glauber/src/modulos/finalizar_compra/interator/servicos/listar_informacoes_servico.dart';
import 'package:glauber/src/modulos/provas/interator/modelos/prova_modelo.dart';

class ListarInformacoesStore extends ValueNotifier<ListarInformacoesEstado> {
  final ListarInformacoesServico _servico;

  ListarInformacoesStore(this._servico) : super(ListarInformacoesEstadoInicial());

  void listarInformacoes(List<ProvaModelo> provas, String idEvento) async {
    value = CarregandoInformacoes();

    var (sucesso, mensagem, dados) = await _servico.listarInformacoes(provas, idEvento);

    if (sucesso) {
      value = CarregadoInformacoes(dados: dados);
    } else {
      value = ErroAoListar(erro: Exception(mensagem));
    }
  }
}
