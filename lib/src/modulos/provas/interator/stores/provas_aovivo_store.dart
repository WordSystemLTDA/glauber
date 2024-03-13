import 'package:flutter/material.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_modelo.dart';
import 'package:provadelaco/src/modulos/provas/interator/estados/provas_estado.dart';
import 'package:provadelaco/src/modulos/provas/interator/servicos/prova_servico.dart';

class ProvasAoVivoStore extends ValueNotifier<ProvasEstado> {
  final ProvaServico _provaServico;

  ProvasAoVivoStore(this._provaServico) : super(EstadoInicial());

  void listar(UsuarioModelo? usuario, String idEvento, String tipo) async {
    value = ProvasCarregando();

    var resposta = await _provaServico.listar(usuario, idEvento, tipo);

    if (resposta.sucesso) {
      value = ProvasCarregado(provas: resposta.provas, evento: resposta.evento, nomesCabeceira: resposta.nomesCabeceira, pagamentosDisponiveis: resposta.pagamentoDisponiveis);
    } else {
      value = ErroAoCarregar(erro: Exception('Erro ao listar.'));
    }
  }

  void atualizarLista(UsuarioModelo? usuario, String idEvento, String tipo) async {
    var resposta = await _provaServico.listar(usuario, idEvento, tipo);

    if (resposta.sucesso) {
      value = ProvasCarregado(provas: resposta.provas, evento: resposta.evento, nomesCabeceira: resposta.nomesCabeceira, pagamentosDisponiveis: resposta.pagamentoDisponiveis);
    } else {
      value = ErroAoCarregar(erro: Exception('Erro ao listar.'));
    }
  }
}
