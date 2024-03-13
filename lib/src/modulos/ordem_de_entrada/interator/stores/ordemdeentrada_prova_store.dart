import 'package:flutter/material.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_modelo.dart';
import 'package:provadelaco/src/modulos/ordem_de_entrada/interator/estados/orderdeentrada_estado_prova.dart';
import 'package:provadelaco/src/modulos/ordem_de_entrada/interator/modelos/prova_parceiros_modelo.dart';
import 'package:provadelaco/src/modulos/ordem_de_entrada/interator/servicos/ordemdeentrada_servico.dart';

class OrdemDeEntradaProvaStore extends ValueNotifier<OrdemDeEntradaEstadoProva> {
  final OrdemDeEntradaServico _servico;

  OrdemDeEntradaProvaStore(this._servico) : super(OrdemDeEntradaEstadoProvaInicial());

  void listar(UsuarioModelo? usuario, String idProva) async {
    value = OrdemDeEntradaCarregando();

    List<ProvaParceirosModelos> ordemdeentradas = await _servico.listarPorProva(usuario, idProva);

    value = OrdemDeEntradaCarregado(ordemdeentradas: ordemdeentradas);
  }

  void atualizarLista(UsuarioModelo? usuario, String idProva) async {
    List<ProvaParceirosModelos> ordemdeentradas = await _servico.listarPorProva(usuario, idProva);

    value = OrdemDeEntradaCarregado(ordemdeentradas: ordemdeentradas);
  }
}
