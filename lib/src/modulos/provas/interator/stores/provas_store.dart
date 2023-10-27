import 'package:flutter/material.dart';
import 'package:glauber/src/modulos/provas/interator/estados/provas_estado.dart';
import 'package:glauber/src/modulos/provas/interator/servicos/prova_servico.dart';

class ProvasStore extends ValueNotifier<ProvasEstado> {
  final ProvaServico _provaServico;

  ProvasStore(this._provaServico) : super(EstadoInicial());

  void listar(String idEvento) async {
    value = ProvasCarregando();

    var resposta = await _provaServico.listar(idEvento);

    if (resposta.sucesso) {
      value = ProvasCarregado(provas: resposta.provas, evento: resposta.evento);
    } else {
      value = ErroAoCarregar(erro: Exception('Erro ao listar.'));
    }
  }
}
