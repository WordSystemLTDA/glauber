import 'package:provadelaco/src/modulos/home/interator/modelos/evento_modelo.dart';

abstract interface class BuscarServico {
  Future<List<EventoModelo>> listarEventoPorNome(String nomeBusca);
}
