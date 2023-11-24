import 'package:provadelaco/src/modulos/home/interator/modelos/evento_modelo.dart';

sealed class BuscarEstado {
  final List<EventoModelo> eventos;

  BuscarEstado({required this.eventos});
}

class EstadoInicial extends BuscarEstado {
  EstadoInicial() : super(eventos: []);
}

class Carregando extends BuscarEstado {
  Carregando() : super(eventos: []);
}

class Carregado extends BuscarEstado {
  Carregado({required List<EventoModelo> eventos}) : super(eventos: eventos);
}

class ErroAoCarregar extends BuscarEstado {
  final Exception erro;
  ErroAoCarregar({required this.erro}) : super(eventos: []);
}
