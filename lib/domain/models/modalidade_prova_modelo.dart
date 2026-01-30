import 'package:json_annotation/json_annotation.dart';
import 'package:provadelaco/domain/models/prova/prova_modelo.dart';

part 'modalidade_prova_modelo.g.dart';

@JsonSerializable()
class ModalidadeProvaModelo {
  final String modalidade;
  final String nomemodalidade;
  final List<ProvaModelo> provas;

  ModalidadeProvaModelo({required this.modalidade, required this.nomemodalidade, required this.provas});

  factory ModalidadeProvaModelo.fromJson(Map<String, dynamic> json) => _$ModalidadeProvaModeloFromJson(json);

  Map<String, dynamic> toJson() => _$ModalidadeProvaModeloToJson(this);
}
