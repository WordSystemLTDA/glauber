import 'package:provadelaco/src/modulos/provas/interator/modelos/prova_retorno_modelo.dart';

abstract interface class ProvaServico {
  Future<ProvaRetornoModelo> listar(String idEvento);
}
