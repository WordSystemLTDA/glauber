import 'package:flutter/material.dart';
import 'package:provadelaco/src/data/servicos/listar_cartoes_servico_impl.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/estados/listar_cartoes_estado.dart';

class ListarCartoesStore extends ValueNotifier<ListarCartoesEstado> {
  final ListarCartoesServicoImpl _servico;

  ListarCartoesStore(this._servico) : super(ListarCartoesEstadoInicial());

  void listarCartoes() async {
    value = CartoesCarregandoInformacoes();

    var cartoes = await _servico.listarCartoes();

    if (cartoes.isNotEmpty) {
      value = CartoesCarregadoInformacoes(cartoes: cartoes);
    } else {
      value = CartoesErroAoListar(erro: Exception(''));
    }
  }
}
