import 'package:glauber/src/modulos/home/interator/modelos/evento_modelo.dart';
import 'package:glauber/src/modulos/provas/interator/modelos/prova_modelo.dart';

sealed class ProvasEstado {
  final List<ProvaModelo> provas;
  final EventoModelo? evento;

  ProvasEstado({required this.provas, this.evento});
}

class EstadoInicial extends ProvasEstado {
  EstadoInicial() : super(provas: []);
}

class ProvasCarregando extends ProvasEstado {
  ProvasCarregando() : super(provas: []);
}

class ProvasCarregado extends ProvasEstado {
  ProvasCarregado({required List<ProvaModelo> provas, required EventoModelo evento}) : super(provas: provas, evento: evento);
}

class ErroAoCarregar extends ProvasEstado {
  final Exception erro;
  ErroAoCarregar({required this.erro}) : super(provas: []);
}
