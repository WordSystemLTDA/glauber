import 'package:provadelaco/src/essencial/providers/usuario/usuario_modelo.dart';
import 'package:provadelaco/src/modulos/provas/interator/modelos/competidores_modelo.dart';

abstract interface class CompetidoresServico {
  Future<List<CompetidoresModelo>> listarCompetidores(String? idCabeceira, UsuarioModelo? usuario, String pesquisa, String idProva);
}
