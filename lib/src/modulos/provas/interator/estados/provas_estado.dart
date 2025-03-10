import 'package:provadelaco/src/modulos/animais/modelos/modelo_animal.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/modelos/nomes_cabeceira_modelo.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/modelos/pagamentos_modelo.dart';
import 'package:provadelaco/src/modulos/home/interator/modelos/evento_modelo.dart';
import 'package:provadelaco/src/modulos/provas/interator/modelos/modalidade_prova_modelo.dart';

sealed class ProvasEstado {
  final List<ModalidadeProvaModelo> provas;
  final EventoModelo? evento;
  final ModeloAnimal? animalPadrao;
  final List<NomesCabeceiraModelo>? nomesCabeceira;
  final List<PagamentosModelo>? pagamentosDisponiveis;

  ProvasEstado({required this.provas, this.evento, this.animalPadrao, this.nomesCabeceira, this.pagamentosDisponiveis});
}

class EstadoInicial extends ProvasEstado {
  EstadoInicial() : super(provas: []);
}

class ProvasCarregando extends ProvasEstado {
  ProvasCarregando() : super(provas: []);
}

class ProvasCarregado extends ProvasEstado {
  ProvasCarregado({
    required super.provas,
    required EventoModelo super.evento,
    super.animalPadrao,
    required List<NomesCabeceiraModelo> super.nomesCabeceira,
    required List<PagamentosModelo> super.pagamentosDisponiveis,
  });
}

class ErroAoCarregar extends ProvasEstado {
  final Exception erro;
  ErroAoCarregar({required this.erro}) : super(provas: []);
}
