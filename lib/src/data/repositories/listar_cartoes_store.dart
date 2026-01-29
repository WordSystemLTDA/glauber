import 'package:flutter/material.dart';
import 'package:provadelaco/src/data/servicos/listar_cartoes_servico.dart';
import 'package:provadelaco/src/domain/models/cartao_modelo.dart';

class ListarCartoesStore extends ChangeNotifier {
  final ListarCartoesServico _servico;

  ListarCartoesStore(this._servico) : super();

  bool carregando = false;
  List<CartaoModelo> cartoes = [];

  void listarCartoes() async {
    carregando = true;
    notifyListeners();

    var lista = await _servico.listarCartoes();

    cartoes = lista;
    carregando = false;
    notifyListeners();
  }
}
