import 'package:flutter/material.dart';
import 'package:provadelaco/src/modulos/propaganda/interator/modelos/propaganda_modelo.dart';
import 'package:provadelaco/src/modulos/propaganda/interator/servicos/propagandas_servico.dart';

class PropagandasStore extends ChangeNotifier {
  final PropagandasServico _servico;

  PropagandasStore(this._servico);

  bool carregando = false;
  PropagandaModelo? propagandas;

  void listar(String idPropaganda) async {
    carregando = true;
    notifyListeners();

    PropagandaModelo? propagandas = await _servico.listar(idPropaganda);

    if (propagandas != null) {
      propagandas = propagandas;
    }

    carregando = false;
    notifyListeners();
  }
}
