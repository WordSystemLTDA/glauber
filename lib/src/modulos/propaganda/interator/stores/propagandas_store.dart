import 'package:flutter/material.dart';
import 'package:provadelaco/src/modulos/propaganda/interator/modelos/propaganda_modelo.dart';
import 'package:provadelaco/src/modulos/propaganda/interator/estados/propagandas_estado.dart';

import 'package:provadelaco/src/modulos/propaganda/interator/servicos/propagandas_servico.dart';

class PropagandasStore extends ValueNotifier<PropagandasEstado> {
  final PropagandasServico _servico;

  PropagandasStore(this._servico) : super(PropagandasEstadoInicial());

  void listar(String idPropaganda) async {
    value = PropagandasCarregando();

    PropagandaModelo? propagandas = await _servico.listar(idPropaganda);

    if (propagandas != null) {
      value = PropagandasCarregado(propagandas: propagandas);
    } else {
      value = PropagandasErroAoListar(erro: Exception('Erro ao listar'));
    }
  }
}
