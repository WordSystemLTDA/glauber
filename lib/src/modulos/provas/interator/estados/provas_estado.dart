import 'package:provadelaco/src/modulos/finalizar_compra/interator/modelos/nomes_cabeceira_modelo.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/modelos/pagamentos_modelo.dart';
import 'package:provadelaco/src/modulos/home/interator/modelos/evento_modelo.dart';
import 'package:provadelaco/src/modulos/provas/interator/modelos/prova_modelo.dart';

sealed class ProvasEstado {
  final List<ProvaModelo> provas;
  final EventoModelo? evento;
  final List<NomesCabeceiraModelo>? nomesCabeceira;
  final List<PagamentosModelo>? pagamentosDisponiveis;

  ProvasEstado({required this.provas, this.evento, this.nomesCabeceira, this.pagamentosDisponiveis});
}

class EstadoInicial extends ProvasEstado {
  EstadoInicial() : super(provas: []);
}

class ProvasCarregando extends ProvasEstado {
  ProvasCarregando() : super(provas: []);
}

class ProvasCarregado extends ProvasEstado {
  ProvasCarregado(
      {required List<ProvaModelo> provas, required EventoModelo evento, required List<NomesCabeceiraModelo> nomesCabeceira, required List<PagamentosModelo> pagamentosDisponiveis})
      : super(provas: provas, evento: evento, nomesCabeceira: nomesCabeceira, pagamentosDisponiveis: pagamentosDisponiveis);
}

class ErroAoCarregar extends ProvasEstado {
  final Exception erro;
  ErroAoCarregar({required this.erro}) : super(provas: []);
}
