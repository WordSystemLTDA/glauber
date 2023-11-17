import 'package:provadelaco/src/modulos/home/interator/modelos/evento_modelo.dart';

sealed class HomeEstado {
  final List<EventoModelo> eventos;
  final List<EventoModelo> propagandas;

  HomeEstado({required this.eventos, required this.propagandas});
}

class EstadoInicial extends HomeEstado {
  EstadoInicial() : super(eventos: [], propagandas: []);
}

class Carregando extends HomeEstado {
  Carregando() : super(eventos: [], propagandas: []);
}

class Carregado extends HomeEstado {
  Carregado({required List<EventoModelo> eventos, required List<EventoModelo> propagandas}) : super(eventos: eventos, propagandas: propagandas);
}

class ErroAoCarregar extends HomeEstado {
  final Exception erro;
  ErroAoCarregar({required this.erro}) : super(eventos: [], propagandas: []);
}
