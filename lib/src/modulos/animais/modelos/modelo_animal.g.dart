// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modelo_animal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModeloAnimal _$ModeloAnimalFromJson(Map<String, dynamic> json) => ModeloAnimal(
      id: json['id'] as String,
      nomedoanimal: json['nomedoanimal'] as String,
      datanascianimal: json['datanascianimal'] as String,
      sexo: json['sexo'] as String,
      racadoanimal: json['racadoanimal'] as String,
      foto: json['foto'] as String,
      soupropietario: json['soupropietario'] as bool,
    );

Map<String, dynamic> _$ModeloAnimalToJson(ModeloAnimal instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nomedoanimal': instance.nomedoanimal,
      'datanascianimal': instance.datanascianimal,
      'sexo': instance.sexo,
      'racadoanimal': instance.racadoanimal,
      'foto': instance.foto,
      'soupropietario': instance.soupropietario,
    };
