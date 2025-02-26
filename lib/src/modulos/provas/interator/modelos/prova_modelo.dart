// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';
import 'package:provadelaco/src/modulos/provas/interator/modelos/competidores_modelo.dart';
import 'package:provadelaco/src/modulos/provas/interator/modelos/permitir_compra_modelo.dart';

part 'prova_modelo.g.dart';

// ignore: must_be_immutable
@JsonSerializable()
class ProvaModelo {
  final String id;
  final String nomeProva;
  final String valor;
  final String hcMinimo;
  final String hcMaximo;
  final String avulsa;
  final String quantMinima;
  final String quantMaxima;
  final PermitirCompraModelo permitirCompra;
  final String permitirSorteio;
  final String habilitarAoVivo;
  final String idListaCompeticao;
  final String? liberarReembolso;
  final String? descricao;
  final String? somatoriaHandicaps;
  final bool? sorteio;
  final String permitirEditarParceiros;
  String? nomeCabeceira;
  String? idCabeceira;
  List<CompetidoresModelo>? competidores;

  ProvaModelo({
    required this.id,
    required this.nomeProva,
    required this.valor,
    required this.hcMinimo,
    required this.hcMaximo,
    required this.avulsa,
    required this.quantMinima,
    required this.quantMaxima,
    required this.permitirCompra,
    required this.permitirSorteio,
    required this.habilitarAoVivo,
    required this.idListaCompeticao,
    this.liberarReembolso = 'Não',
    this.descricao,
    this.somatoriaHandicaps,
    this.sorteio,
    required this.permitirEditarParceiros,
    this.nomeCabeceira,
    this.idCabeceira,
    this.competidores,
  });

  factory ProvaModelo.fromJson(Map<String, dynamic> json) => _$ProvaModeloFromJson(json);

  Map<String, dynamic> toJson() => _$ProvaModeloToJson(this);
}
