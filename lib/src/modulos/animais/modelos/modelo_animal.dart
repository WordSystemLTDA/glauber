// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'modelo_animal.g.dart';

@JsonSerializable()
class ModeloAnimal {
  final String id;
  final String nomedoanimal;
  final String datanascianimal;
  final String sexo;
  final String padrao;
  final String racadoanimal;
  final String foto;
  final bool soupropietario;

  ModeloAnimal({
    required this.id,
    required this.nomedoanimal,
    required this.datanascianimal,
    required this.sexo,
    required this.padrao,
    required this.racadoanimal,
    required this.foto,
    required this.soupropietario,
  });

  factory ModeloAnimal.fromJson(Map<String, dynamic> json) => _$ModeloAnimalFromJson(json);

  Map<String, dynamic> toJson() => _$ModeloAnimalToJson(this);
}
