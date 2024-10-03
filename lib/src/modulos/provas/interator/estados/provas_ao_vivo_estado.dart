import 'package:provadelaco/src/modulos/finalizar_compra/interator/modelos/nomes_cabeceira_modelo.dart';
import 'package:provadelaco/src/modulos/home/interator/modelos/evento_modelo.dart';
import 'package:provadelaco/src/modulos/provas/interator/modelos/modelo_prova_ao_vivo.dart';

sealed class ProvasAoVivoEstado {
  final List<ModeloProvaAoVivo> listaCompeticao;
  final EventoModelo? evento;
  final List<NomesCabeceiraModelo>? nomesCabeceira;

  ProvasAoVivoEstado({required this.listaCompeticao, this.evento, this.nomesCabeceira});
}

class EstadoInicial extends ProvasAoVivoEstado {
  EstadoInicial() : super(listaCompeticao: []);
}

class ProvasCarregando extends ProvasAoVivoEstado {
  ProvasCarregando() : super(listaCompeticao: []);
}

class ProvasCarregado extends ProvasAoVivoEstado {
  ProvasCarregado({
    required super.listaCompeticao,
    required EventoModelo super.evento,
    required List<NomesCabeceiraModelo> super.nomesCabeceira,
  });
}

class ErroAoCarregar extends ProvasAoVivoEstado {
  final Exception erro;
  ErroAoCarregar({required this.erro}) : super(listaCompeticao: []);
}
