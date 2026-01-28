import 'package:json_annotation/json_annotation.dart';

part 'competidores_modelo.g.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore: must_be_immutable
@JsonSerializable()
class CompetidoresModelo {
  String id;
  String nome;
  String apelido;
  String nomeCidade;
  String siglaEstado;
  String ativo;
  String idProva;
  bool? jaExistente;
  String? idParceiroTrocado;
  String? celular;
  String? hccabeceira;
  String? hcpezeiro;

  CompetidoresModelo({
    required this.id,
    required this.nome,
    required this.apelido,
    required this.nomeCidade,
    required this.siglaEstado,
    required this.ativo,
    required this.idProva,
    this.jaExistente,
    this.idParceiroTrocado,
    this.celular,
    this.hccabeceira,
    this.hcpezeiro,
  });

  factory CompetidoresModelo.fromJson(Map<String, dynamic> json) => _$CompetidoresModeloFromJson(json);

  Map<String, dynamic> toJson() => _$CompetidoresModeloToJson(this);
}
