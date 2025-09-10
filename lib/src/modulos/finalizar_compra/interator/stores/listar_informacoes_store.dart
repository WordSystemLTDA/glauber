import 'package:flutter/material.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_modelo.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/estados/listar_informacoes_estado.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/servicos/listar_informacoes_servico.dart';
import 'package:provadelaco/src/modulos/provas/interator/modelos/prova_modelo.dart';

class ListarInformacoesStore extends ValueNotifier<ListarInformacoesEstado> {
  final ListarInformacoesServico _servico;

  ListarInformacoesStore(this._servico) : super(ListarInformacoesEstadoInicial());

  Future<ListarInformacoesEstado> listarInformacoes(UsuarioModelo? usuario, List<ProvaModelo> provas, String idEvento, bool editando, String idVenda) async {
    value = CarregandoInformacoes();

    var (sucesso, mensagem, dados) = await _servico.listarInformacoes(usuario, provas, idEvento, editando, idVenda);

    if (sucesso) {
      value = CarregadoInformacoes(dados: dados);
    } else {
      value = ErroAoListar(erro: Exception(mensagem));
    }

    return value;
  }
}
