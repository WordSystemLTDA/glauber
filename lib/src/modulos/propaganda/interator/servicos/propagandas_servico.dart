import 'package:provadelaco/src/modulos/propaganda/interator/modelos/propaganda_modelo.dart';

abstract interface class PropagandasServico {
  Future<PropagandaModelo?> listar(String idPropaganda);
}
