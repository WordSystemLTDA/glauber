import 'package:json_annotation/json_annotation.dart';

part 'competidores_modelo2.g.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore: must_be_immutable
@JsonSerializable()
class CompetidoresModelo2 {
  String id;
  String nome;
  String apelido;
  String nomeCidade;
  String siglaEstado;
  String ativo;
  bool jaExistente;
  String idParceiroTrocado;

  CompetidoresModelo2({
    required this.id,
    required this.nome,
    required this.apelido,
    required this.nomeCidade,
    required this.siglaEstado,
    required this.ativo,
    required this.jaExistente,
    required this.idParceiroTrocado,
  });

  factory CompetidoresModelo2.fromJson(Map<String, dynamic> json) => _$CompetidoresModelo2FromJson(json);

  Map<String, dynamic> toJson() => _$CompetidoresModelo2ToJson(this);
}
