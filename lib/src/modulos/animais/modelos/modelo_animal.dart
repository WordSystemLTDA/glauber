// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ModeloAnimal {
  final String id;
  final String nomedoanimal;
  final String datanascianimal;
  final String sexo;
  final String racadoanimal;
  final String foto;

  ModeloAnimal({
    required this.id,
    required this.nomedoanimal,
    required this.datanascianimal,
    required this.sexo,
    required this.racadoanimal,
    required this.foto,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nomedoanimal': nomedoanimal,
      'datanascianimal': datanascianimal,
      'sexo': sexo,
      'racadoanimal': racadoanimal,
      'foto': foto,
    };
  }

  factory ModeloAnimal.fromMap(Map<String, dynamic> map) {
    return ModeloAnimal(
      id: map['id'] as String,
      nomedoanimal: map['nomedoanimal'] as String,
      datanascianimal: map['datanascianimal'] as String,
      sexo: map['sexo'] as String,
      racadoanimal: map['racadoanimal'] as String,
      foto: map['foto'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ModeloAnimal.fromJson(String source) => ModeloAnimal.fromMap(json.decode(source) as Map<String, dynamic>);
}
