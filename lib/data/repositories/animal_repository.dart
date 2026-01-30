import 'package:flutter/material.dart';
import 'package:provadelaco/data/services/servico_animais.dart';
import 'package:provadelaco/domain/models/animal/animal.dart';

class ProvedorAnimal extends ChangeNotifier {
  final ServicoAnimais _servico;
  ProvedorAnimal(this._servico);

  bool carregando = false;
  List<ModeloAnimal> animais = [];

  Future<void> listar(String pesquisa) async {
    if (carregando) return;

    carregando = true;
    notifyListeners();

    await _servico.listar(pesquisa).then((listaAnimais) {
      animais = listaAnimais;
    });

    carregando = false;
    notifyListeners();
  }

  Future<void> excluir(String id) async {
    if (carregando) return;

    carregando = true;
    notifyListeners();

    await _servico.excluir(id).then((_) {
      animais.removeWhere((animal) => animal.id == id);
    });

    carregando = false;
    notifyListeners();
  }

  void resetarCompras() {
    animais = [];
    carregando = false;
    notifyListeners();
  }
}
