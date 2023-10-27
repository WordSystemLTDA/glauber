import 'package:flutter/foundation.dart';
import 'package:glauber/src/modulos/home/interator/estados/home_estado.dart';
import 'package:glauber/src/modulos/home/interator/servicos/home_servico.dart';

class HomeStore extends ValueNotifier<HomeEstado> {
  final HomeServico _homeServico;

  HomeStore(this._homeServico) : super(EstadoInicial());

  void listar() async {
    value = Carregando();

    var resposta = await _homeServico.listar();

    if (resposta.sucesso) {
      value = Carregado(eventos: resposta.eventos, propagandas: resposta.propagandas);
    } else {
      value = ErroAoCarregar(erro: Exception('Erro ao listar.'));
    }
  }
}
