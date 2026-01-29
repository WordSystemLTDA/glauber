import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provadelaco/src/data/servicos/handicap_servico.dart';
import 'package:provadelaco/src/domain/models/handicaps_modelo.dart';

class HandiCapStore extends ChangeNotifier {
  final HandiCapServico _handiCapServico;

  HandiCapStore(this._handiCapServico) : super();

  bool carregando = false;

  List<HandiCapsModelos> handicaps = [];

  void listar() async {
    carregando = true;
    notifyListeners();

    var dados = await _handiCapServico.listar();

    handicaps = dados;
    carregando = false;
    notifyListeners();
  }
}
