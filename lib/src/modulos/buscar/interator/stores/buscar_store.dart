import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:provadelaco/src/modulos/buscar/interator/estados/buscar_estado.dart';
import 'package:provadelaco/src/modulos/buscar/interator/servicos/buscar_servico.dart';

class BuscarStore extends ValueNotifier<BuscarEstado> {
  final BuscarServico _servico;

  BuscarStore(this._servico) : super(EstadoInicial());

  Timer? debounce;

  void listarEventoPorNome(String nomeBusca) async {
    value = Carregando();

    if (debounce?.isActive ?? false) {
      debounce!.cancel();
    }

    debounce = Timer(const Duration(seconds: 1), () async {
      var resposta = await _servico.listarEventoPorNome(nomeBusca);

      if (resposta.isNotEmpty) {
        value = Carregado(eventos: resposta);
      } else {
        value = ErroAoCarregar(erro: Exception('Erro ao listar.'));
      }
    });
  }
}
