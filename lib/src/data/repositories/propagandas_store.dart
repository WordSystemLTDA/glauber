import 'package:flutter/material.dart';
import 'package:provadelaco/src/data/servicos/propagandas_servico_impl.dart';
import 'package:provadelaco/src/domain/models/propaganda_modelo.dart';

class PropagandasStore extends ChangeNotifier {
  final PropagandasServicoImpl _servico;

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
