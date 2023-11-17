import 'package:flutter/material.dart';
import 'package:provadelaco/src/modulos/ordem_de_entrada/interator/estados/orderdeentrada_estado.dart';
import 'package:provadelaco/src/modulos/ordem_de_entrada/interator/modelos/ordem_de_entrada_modelo.dart';
import 'package:provadelaco/src/modulos/ordem_de_entrada/interator/servicos/ordemdeentrada_servico.dart';

class OrdemDeEntradaStore extends ValueNotifier<OrdemDeEntradaEstado> {
  final OrdemDeEntradaServico _servico;

  OrdemDeEntradaStore(this._servico) : super(OrdemDeEntradaEstadoInicial());

  void listar() async {
    value = OrdemDeEntradaCarregando();

    List<OrdemDeEntradaModelo> ordemdeentradas = await _servico.listar();

    if (ordemdeentradas.isNotEmpty) {
      value = OrdemDeEntradaCarregado(ordemdeentradas: ordemdeentradas);
    } else {
      value = OrdemDeEntradaErroAoListar(erro: Exception('Erro ao listar'));
    }
  }
}
