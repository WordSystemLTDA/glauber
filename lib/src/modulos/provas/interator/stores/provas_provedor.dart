import 'package:flutter/material.dart';
import 'package:provadelaco/src/modulos/animais/modelos/modelo_animal.dart';

class ProvasProvedor extends ChangeNotifier {
  ModeloAnimal? _animalSelecionado;
  ModeloAnimal? get animalSelecionado => _animalSelecionado;
  set animalSelecionado(ModeloAnimal? value) {
    _animalSelecionado = value;
    notifyListeners();
  }
}
