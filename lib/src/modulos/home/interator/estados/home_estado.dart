import 'package:provadelaco/src/domain/models/categoria_modelo.dart';
import 'package:provadelaco/src/domain/models/evento_modelo.dart';
import 'package:provadelaco/src/domain/models/propaganda_modelo.dart';

sealed class HomeEstado {
  final List<EventoModelo> eventos;
  final List<EventoModelo> eventosTopo;
  final List<PropagandaModelo> propagandas;
  final List<CategoriaModelo> categorias;

  HomeEstado({required this.eventos, required this.eventosTopo, required this.propagandas, required this.categorias});
}

class EstadoInicial extends HomeEstado {
  EstadoInicial() : super(eventos: [], eventosTopo: [], propagandas: [], categorias: []);
}

class Carregando extends HomeEstado {
  Carregando() : super(eventos: [], eventosTopo: [], propagandas: [], categorias: []);
}

class Carregado extends HomeEstado {
  Carregado({required super.eventos, required super.eventosTopo, required super.propagandas, required super.categorias});
}

class ErroAoCarregar extends HomeEstado {
  final Exception erro;
  ErroAoCarregar({required this.erro}) : super(eventos: [], eventosTopo: [], propagandas: [], categorias: []);
}
