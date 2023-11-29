import 'package:provadelaco/src/modulos/perfil/interator/modelos/cidade_modelo.dart';

abstract interface class CidadeServico {
  Future<List<CidadeModelo>?> listar(String? nome);
}
