import 'package:flutter/material.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_modelo.dart';
import 'package:provadelaco/src/modulos/provas/interator/estados/provas_ao_vivo_estado.dart';
import 'package:provadelaco/src/modulos/provas/interator/servicos/prova_servico.dart';

class ProvasAoVivoStore extends ValueNotifier<ProvasAoVivoEstado> {
  final ProvaServico _provaServico;

  ProvasAoVivoStore(this._provaServico) : super(EstadoInicial());

  void listar(UsuarioModelo? usuario, String idEmpresa, String idEvento) async {
    value = ProvasCarregando();

    var resposta = await _provaServico.listarAoVivo(usuario, idEmpresa, idEvento);

    value = ProvasCarregado(listaCompeticao: resposta.listaCompeticao, evento: resposta.evento, nomesCabeceira: resposta.nomesCabeceira);
  }

  Future<void> atualizarLista(UsuarioModelo? usuario, String idEmpresa, String idEvento) async {
    var resposta = await _provaServico.listarAoVivo(usuario, idEmpresa, idEvento);

    value = ProvasCarregado(listaCompeticao: resposta.listaCompeticao, evento: resposta.evento, nomesCabeceira: resposta.nomesCabeceira);
  }
}
