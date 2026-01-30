import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:provadelaco/data/services/buscar_servico.dart';
import 'package:provadelaco/domain/models/evento/evento.dart';

class BuscarStore extends ChangeNotifier {
  final BuscarServico _servico;

  BuscarStore(this._servico) : super();

  Timer? debounce;

  bool carregando = false;

  List<EventoModelo> eventos = [];

  void listarEventoPorNome(String nomeBusca) async {
    carregando = true;
    notifyListeners();

    if (debounce?.isActive ?? false) {
      debounce!.cancel();
    }

    debounce = Timer(const Duration(seconds: 1), () async {
      var resposta = await _servico.listarEventoPorNome(nomeBusca);

      eventos = resposta;
      carregando = false;
      notifyListeners();
    });
  }
}
