// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';
import 'package:provadelaco/domain/models/competidores/competidores_modelo2.dart';

part 'permitir_compra_modelo.g.dart';

@JsonSerializable()
class PermitirCompraModelo {
  final bool liberado;
  final String mensagem;
  final String? rota;
  final String? tituloAcao;
  final String? quantMaximaAvulsa;
  final String? quantParceiros;
  final String? permVincularParceiro;
  final List<CompetidoresModelo2>? competidoresJaSelecionados;
  final String? idCabeceiraInvalido;

  const PermitirCompraModelo({
    required this.liberado,
    required this.mensagem,
    this.rota,
    this.tituloAcao,
    this.quantMaximaAvulsa,
    this.quantParceiros,
    this.permVincularParceiro,
    this.competidoresJaSelecionados,
    this.idCabeceiraInvalido,
  });

  factory PermitirCompraModelo.fromJson(Map<String, dynamic> json) => _$PermitirCompraModeloFromJson(json);

  Map<String, dynamic> toJson() => _$PermitirCompraModeloToJson(this);
}
