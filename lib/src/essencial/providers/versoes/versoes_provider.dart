import 'package:flutter/foundation.dart';
import 'package:provadelaco/src/essencial/providers/versoes/versoes_modelo.dart';

class VersoesProvider extends ChangeNotifier {
  VersoesModelo? _versoes;

  VersoesModelo? get versoes => _versoes;

  void setVersoes(VersoesModelo? versao) {
    _versoes = versao;
    notifyListeners();
  }
}
