import 'package:flutter/material.dart';
import 'package:provadelaco/src/modulos/calendario/interator/estados/agenda_info_estado.dart';
import 'package:provadelaco/src/modulos/calendario/interator/modelos/agenda_info_modelo.dart';
import 'package:provadelaco/src/modulos/calendario/interator/servicos/agenda_servico.dart';

class AgendaInfoStore extends ValueNotifier<AgendaInfoEstado> {
  final AgendaServico _servico;

  AgendaInfoStore(this._servico) : super(AgendaInfoEstadoInicial());

  void listar(String idCalendario) async {
    value = AgendaInfoCarregando();

    AgendaInfoModelo? agendaInfo = await _servico.listarPorId(idCalendario);

    if (agendaInfo != null) {
      value = AgendaInfoCarregado(agendaInfo: agendaInfo);
    } else {
      value = AgendaInfoErroAoListar(erro: Exception('Erro ao listar'));
    }
  }
}
