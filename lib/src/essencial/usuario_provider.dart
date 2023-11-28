import 'package:flutter/foundation.dart';
import 'package:provadelaco/src/essencial/usuario_modelo.dart';

class UsuarioProvider extends ChangeNotifier {
  UsuarioModelo? _usuario;

  UsuarioModelo? get usuario => _usuario;

  void setUsuario(UsuarioModelo? novoUsuario) {
    _usuario = novoUsuario;
    notifyListeners();
  }
}
