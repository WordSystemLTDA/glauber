import 'package:flutter/material.dart';
import 'package:provadelaco/data/services/listar_cartoes_servico.dart';
import 'package:provadelaco/domain/models/cartao/cartao.dart';

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
