import 'package:glauber/src/modulos/finalizar_compra/interator/modelos/nomes_cabeceira_modelo.dart';
import 'package:glauber/src/modulos/home/interator/modelos/evento_modelo.dart';
import 'package:glauber/src/modulos/provas/interator/modelos/prova_modelo.dart';

sealed class ProvasEstado {
  final List<ProvaModelo> provas;
  final EventoModelo? evento;
  final List<NomesCabeceiraModelo>? nomesCabeceira;

  ProvasEstado({required this.provas, this.evento, this.nomesCabeceira});
}

class EstadoInicial extends ProvasEstado {
  EstadoInicial() : super(provas: []);
}

class ProvasCarregando extends ProvasEstado {
  ProvasCarregando() : super(provas: []);
}

class ProvasCarregado extends ProvasEstado {
  ProvasCarregado({required List<ProvaModelo> provas, required EventoModelo evento, required List<NomesCabeceiraModelo> nomesCabeceira})
      : super(provas: provas, evento: evento, nomesCabeceira: nomesCabeceira);
}

class ErroAoCarregar extends ProvasEstado {
  final Exception erro;
  ErroAoCarregar({required this.erro}) : super(provas: []);
}
