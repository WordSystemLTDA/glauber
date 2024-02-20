import 'package:provadelaco/src/modulos/provas/interator/modelos/competidores_modelo.dart';

abstract interface class CompetidoresServico {
  Future<List<CompetidoresModelo>> listarCompetidores(String pesquisa);
}
