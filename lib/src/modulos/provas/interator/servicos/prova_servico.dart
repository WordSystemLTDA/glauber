import 'package:provadelaco/src/essencial/providers/usuario/usuario_modelo.dart';
import 'package:provadelaco/src/modulos/provas/interator/modelos/prova_retorno_modelo.dart';

abstract interface class ProvaServico {
  Future<ProvaRetornoModelo> listar(UsuarioModelo? usuario, String idEvento);
}
