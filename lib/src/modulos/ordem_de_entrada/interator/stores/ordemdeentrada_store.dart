import 'package:flutter/material.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_modelo.dart';
import 'package:provadelaco/src/modulos/ordem_de_entrada/interator/estados/orderdeentrada_estado.dart';
import 'package:provadelaco/src/modulos/ordem_de_entrada/interator/modelos/ordem_de_entrada_modelo.dart';
import 'package:provadelaco/src/modulos/ordem_de_entrada/interator/servicos/ordemdeentrada_servico.dart';

class OrdemDeEntradaStore extends ValueNotifier<OrdemDeEntradaEstado> {
  final OrdemDeEntradaServico _servico;

  OrdemDeEntradaStore(this._servico) : super(OrdemDeEntradaEstadoInicial());

  void listar(UsuarioModelo? usuario) async {
    value = OrdemDeEntradaCarregando();

    List<OrdemDeEntradaModelo> ordemdeentradas = await _servico.listar(usuario);

    value = OrdemDeEntradaCarregado(ordemdeentradas: ordemdeentradas);
  }

  void atualizarLista(UsuarioModelo? usuario) async {
    List<OrdemDeEntradaModelo> ordemdeentradas = await _servico.listar(usuario);

    value = OrdemDeEntradaCarregado(ordemdeentradas: ordemdeentradas);
  }
}
