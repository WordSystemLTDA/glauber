import 'package:flutter/material.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_modelo.dart';
import 'package:provadelaco/src/modulos/compras/interator/estados/compras_estado.dart';
import 'package:provadelaco/src/modulos/compras/interator/modelos/compras_modelo.dart';
import 'package:provadelaco/src/modulos/compras/interator/servicos/compras_servico.dart';

class ComprasStore extends ValueNotifier<ComprasEstado> {
  final ComprasServico _servico;

  ComprasStore(this._servico) : super(ComprasEstadoInicial());

  void listar(UsuarioModelo? usuario) async {
    value = ComprasCarregando();

    List<ComprasModelo> compras = await _servico.listar(usuario);

    if (compras.isNotEmpty) {
      value = ComprasCarregado(compras: compras);
    } else {
      value = ComprasErroAoListar(erro: Exception('Erro ao listar'));
    }
  }
}
