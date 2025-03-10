// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';
import 'package:provadelaco/src/modulos/animais/modelos/modelo_animal.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/modelos/nomes_cabeceira_modelo.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/modelos/pagamentos_modelo.dart';
import 'package:provadelaco/src/modulos/home/interator/modelos/evento_modelo.dart';
import 'package:provadelaco/src/modulos/provas/interator/modelos/modalidade_prova_modelo.dart';

part 'prova_retorno_modelo.g.dart';

@JsonSerializable()
class ProvaRetornoModelo {
  final bool sucesso;
  final List<ModalidadeProvaModelo> provas;
  final List<NomesCabeceiraModelo> nomesCabeceira;
  final EventoModelo evento;
  final ModeloAnimal? animalPadrao;
  final List<PagamentosModelo> pagamentoDisponiveis;

  ProvaRetornoModelo({
    required this.sucesso,
    required this.provas,
    required this.nomesCabeceira,
    required this.pagamentoDisponiveis,
    required this.evento,
    this.animalPadrao,
  });

  factory ProvaRetornoModelo.fromJson(Map<String, dynamic> json) => _$ProvaRetornoModeloFromJson(json);

  Map<String, dynamic> toJson() => _$ProvaRetornoModeloToJson(this);
}
