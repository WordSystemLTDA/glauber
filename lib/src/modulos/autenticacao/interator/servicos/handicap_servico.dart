import 'package:provadelaco/src/modulos/autenticacao/interator/modelos/handicaps_modelo.dart';

abstract interface class HandiCapServico {
  Future<List<HandiCapsModelos>> listar();
}
